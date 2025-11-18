import 'dart:async';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/error/result.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/conversation.dart';
import '../../domain/entities/message.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_supabase_datasource.dart';
import '../models/conversation_model.dart';
import '../models/message_model.dart';


@LazySingleton(as: ChatRepository, env: [Environment.prod])
class ChatRepositorySupabase implements ChatRepository {
  final ChatSupabaseDataSource _dataSource;

  ChatRepositorySupabase(this._dataSource);

  @override
  Future<Result<Conversation>> ensureConversationFor({
    required String requestId,
    required String clientId,
    required String professionalId,
  }) async {
    try {
      final model = await _dataSource.ensureConversationFor(
        requestId: requestId,
        clientId: clientId,
        professionalId: professionalId,
      );
      return Ok(model.toEntity());
    } on PostgrestException catch (e) {
      return Err(_handlePostgrestError(e));
    } catch (e) {
      return Err(ServerFailure('خطأ في إنشاء المحادثة: $e'));
    }
  }

  @override
  Future<Result<List<Conversation>>> listConversations(String userId) async {
    try {
      final models = await _dataSource.listConversations(userId);
      final entities = models.map((m) => m.toEntity()).toList();
      return Ok(entities);
    } on PostgrestException catch (e) {
      return Err(_handlePostgrestError(e));
    } catch (e) {
      return Err(ServerFailure('خطأ في جلب المحادثات: $e'));
    }
  }

  @override
  Future<Result<List<Message>>> listMessages(String conversationId) async {
    try {
      final models = await _dataSource.listMessages(conversationId);
      final entities = models.map((m) => m.toEntity()).toList();
      return Ok(entities);
    } on PostgrestException catch (e) {
      return Err(_handlePostgrestError(e));
    } catch (e) {
      return Err(ServerFailure('خطأ في جلب الرسائل: $e'));
    }
  }

  @override
  Future<Result<Message>> sendMessage({
    required String conversationId,
    required String senderId,
    required String text,
  }) async {
    try {
      final model = await _dataSource.sendMessage(
        conversationId: conversationId,
        senderId: senderId,
        text: text,
      );
      return Ok(model.toEntity());
    } on PostgrestException catch (e) {
      return Err(_handlePostgrestError(e));
    } catch (e) {
      return Err(ServerFailure('خطأ في إرسال الرسالة: $e'));
    }
  }

  @override
  Stream<Result<List<Conversation>>> streamConversations(String userId) {
    return _dataSource
        .streamConversations(userId)
        .transform(
          StreamTransformer<
            List<ConversationModel>,
            Result<List<Conversation>>
          >.fromHandlers(
            handleData: (models, sink) {
              try {
                final entities = models.map((m) => m.toEntity()).toList();
                sink.add(Ok(entities));
              } catch (e) {
                sink.add(Err(ServerFailure('خطأ في معالجة المحادثات: $e')));
              }
            },
            handleError: (error, stackTrace, sink) {
              final failure = error is PostgrestException
                  ? _handlePostgrestError(error)
                  : ServerFailure('خطأ في استقبال المحادثات: $error');
              sink.add(Err(failure));
            },
          ),
        );
  }

  @override
  Stream<Result<List<Message>>> streamMessages(String conversationId) {
    return _dataSource
        .streamMessages(conversationId)
        .transform(
          StreamTransformer<
            List<MessageModel>,
            Result<List<Message>>
          >.fromHandlers(
            handleData: (models, sink) {
              try {
                final entities = models.map((m) => m.toEntity()).toList();
                sink.add(Ok(entities));
              } catch (e) {
                sink.add(Err(ServerFailure('خطأ في معالجة الرسائل: $e')));
              }
            },
            handleError: (error, stackTrace, sink) {
              final failure = error is PostgrestException
                  ? _handlePostgrestError(error)
                  : ServerFailure('خطأ في استقبال الرسائل: $error');
              sink.add(Err(failure));
            },
          ),
        );
  }

  @override
  Future<Result<void>> markAsRead({
    required String conversationId,
    required String userId,
  }) async {
    try {
      await _dataSource.markAsRead(
        conversationId: conversationId,
        userId: userId,
      );
      return const Ok(null);
    } on PostgrestException catch (e) {
      return Err(_handlePostgrestError(e));
    } catch (e) {
      return Err(ServerFailure('خطأ في تعليم الرسائل كمقروءة: $e'));
    }
  }

  @override
  Future<Result<void>> deleteConversationForUser({
    required String conversationId,
    required String userId,
  }) async {
    try {
      await _dataSource.deleteConversationForUser(
        conversationId: conversationId,
        userId: userId,
      );
      return const Ok(null);
    } on PostgrestException catch (e) {
      return Err(_handlePostgrestError(e));
    } catch (e) {
      return Err(ServerFailure('خطأ في حذف المحادثة: $e'));
    }
  }

  
  Failure _handlePostgrestError(PostgrestException e) {
    final code = e.code;
    final message = e.message;

    if (code == '23505') {
      return const ServerFailure('المحادثة موجودة بالفعل');
    } else if (code == '23503') {
      return const NotFoundFailure('الطلب أو المستخدم غير موجود');
    } else if (code == '42501') {
      return const UnauthorizedFailure(
        'ليس لديك صلاحية للوصول إلى هذه المحادثة',
      );
    }

    return ServerFailure('خطأ في قاعدة البيانات: $message (Code: $code)');
  }
}
