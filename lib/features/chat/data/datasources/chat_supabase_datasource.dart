import 'dart:async';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/conversation_model.dart';
import '../models/message_model.dart';

@injectable
class ChatSupabaseDataSource {
  final SupabaseClient _supabase;

  final Map<String, StreamController<List<ConversationModel>>>
  _conversationControllers = {};
  final Map<String, StreamController<List<MessageModel>>> _messageControllers =
      {};

  final Map<String, RealtimeChannel> _conversationChannels = {};
  final Map<String, RealtimeChannel> _messageChannels = {};

  ChatSupabaseDataSource(this._supabase);

  Future<ConversationModel> ensureConversationFor({
    required String requestId,
    required String clientId,
    required String professionalId,
  }) async {
    final existingResponse = await _supabase
        .from('conversations')
        .select()
        .eq('request_id', requestId)
        .limit(1)
        .maybeSingle();

    if (existingResponse != null) {
      return ConversationModel.fromJson(existingResponse);
    }

    try {
      final isHiringPost = requestId.startsWith('hiring-');

      final newResponse = await _supabase
          .from('conversations')
          .insert({
            'request_id': requestId,
            'client_id': clientId,
            'professional_id': professionalId,
            'reference_type': isHiringPost ? 'hiring_post' : 'service_request',
            'created_at': DateTime.now().toIso8601String(),
            'unread_count_for_client': 0,
            'unread_count_for_pro': 0,
          })
          .select()
          .single();

      return ConversationModel.fromJson(newResponse);
    } catch (e) {
      final _ = e;
      final createdResponse = await _supabase
          .from('conversations')
          .select()
          .eq('request_id', requestId)
          .limit(1)
          .maybeSingle();

      if (createdResponse == null) {
        throw Exception('فشل في إنشاء أو العثور على المحادثة');
      }

      return ConversationModel.fromJson(createdResponse);
    }
  }

  Future<List<ConversationModel>> listConversations(String userId) async {
    final allConversations = await _supabase
        .from('conversations')
        .select()
        .or('client_id.eq.$userId,professional_id.eq.$userId')
        .order('last_message_at', ascending: false);

    final conversations = (allConversations as List)
        .map((json) => ConversationModel.fromJson(json))
        .toList();

    return conversations.where((conv) {
      if (conv.clientId == userId) {
        return !conv.deletedForClient;
      } else {
        return !conv.deletedForPro;
      }
    }).toList();
  }

  Stream<List<ConversationModel>> streamConversations(String userId) {
    final streamKey = 'conversations_$userId';

    if (_conversationControllers.containsKey(streamKey)) {
      return _conversationControllers[streamKey]!.stream;
    }

    final controller = StreamController<List<ConversationModel>>.broadcast(
      onCancel: () => _cleanupConversationStream(streamKey),
    );
    _conversationControllers[streamKey] = controller;

    listConversations(userId)
        .then((conversations) {
          if (!controller.isClosed) {
            controller.add(conversations);
          }
        })
        .catchError((error) {
          if (!controller.isClosed) {
            controller.addError(error);
          }
        });

    final channelClient = _supabase.channel('conversations_client_$userId');
    channelClient
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'conversations',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'client_id',
            value: userId,
          ),
          callback: (payload) {
            listConversations(userId)
                .then((conversations) {
                  if (!controller.isClosed) {
                    controller.add(conversations);
                  }
                })
                .catchError((error) {
                  if (!controller.isClosed) {
                    controller.addError(error);
                  }
                });
          },
        )
        .subscribe();

    final channelPro = _supabase.channel('conversations_pro_$userId');
    channelPro
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'conversations',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'professional_id',
            value: userId,
          ),
          callback: (payload) {
            listConversations(userId)
                .then((conversations) {
                  if (!controller.isClosed) {
                    controller.add(conversations);
                  }
                })
                .catchError((error) {
                  if (!controller.isClosed) {
                    controller.addError(error);
                  }
                });
          },
        )
        .subscribe();

    _conversationChannels['${streamKey}_client'] = channelClient;
    _conversationChannels['${streamKey}_pro'] = channelPro;

    return controller.stream;
  }

  Future<List<MessageModel>> listMessages(String conversationId) async {
    final response = await _supabase
        .from('messages')
        .select()
        .eq('conversation_id', conversationId)
        .order('created_at', ascending: true);

    return (response as List)
        .map((json) => MessageModel.fromJson(json))
        .toList();
  }

  Stream<List<MessageModel>> streamMessages(String conversationId) {
    final streamKey = 'messages_$conversationId';

    if (_messageControllers.containsKey(streamKey)) {
      return _messageControllers[streamKey]!.stream;
    }

    final controller = StreamController<List<MessageModel>>.broadcast(
      onCancel: () => _cleanupMessageStream(streamKey),
    );
    _messageControllers[streamKey] = controller;

    listMessages(conversationId)
        .then((messages) {
          if (!controller.isClosed) {
            controller.add(messages);
          }
        })
        .catchError((error) {
          if (!controller.isClosed) {
            controller.addError(error);
          }
        });

    final channel = _supabase.channel('messages_$conversationId');

    channel
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'messages',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'conversation_id',
            value: conversationId,
          ),
          callback: (payload) {
            listMessages(conversationId)
                .then((messages) {
                  if (!controller.isClosed) {
                    controller.add(messages);
                  }
                })
                .catchError((error) {
                  if (!controller.isClosed) {
                    controller.addError(error);
                  }
                });
          },
        )
        .subscribe();

    _messageChannels[streamKey] = channel;

    return controller.stream;
  }

  Future<MessageModel> sendMessage({
    required String conversationId,
    required String senderId,
    required String text,
  }) async {
    final conversationResponse = await _supabase
        .from('conversations')
        .select()
        .eq('id', conversationId)
        .single();

    final conversation = ConversationModel.fromJson(conversationResponse);

    final isClient = conversation.clientId == senderId;
    final recipientId = isClient
        ? conversation.professionalId
        : conversation.clientId;

    final messageResponse = await _supabase
        .from('messages')
        .insert({
          'conversation_id': conversationId,
          'sender_id': senderId,
          'text': text,
          'created_at': DateTime.now().toIso8601String(),
          'read_by': [senderId],
        })
        .select()
        .single();

    final message = MessageModel.fromJson(messageResponse);

    await _supabase
        .from('conversations')
        .update({
          'last_message_at': message.createdAt.toIso8601String(),
          'last_message_text': text,
          if (isClient)
            'unread_count_for_pro': conversation.unreadCountForPro + 1
          else
            'unread_count_for_client': conversation.unreadCountForClient + 1,
        })
        .eq('id', conversationId);

    try {
      final senderData = await _supabase
          .from('profiles')
          .select('full_name')
          .eq('id', senderId)
          .maybeSingle();

      final senderName = senderData?['full_name'] as String? ?? 'مستخدم';

      final messagePreview = text.length > 50
          ? '${text.substring(0, 50)}...'
          : text;

      // notification sent successfully (commented out for simplification)
      final _ =
          '$senderName: $messagePreview to $recipientId in $conversationId';
    } catch (e) {
      final _ = e;
    }

    return message;
  }

  Future<void> markAsRead({
    required String conversationId,
    required String userId,
  }) async {
    final conversationResponse = await _supabase
        .from('conversations')
        .select()
        .eq('id', conversationId)
        .single();

    final conversation = ConversationModel.fromJson(conversationResponse);
    final isClient = conversation.clientId == userId;

    await _supabase
        .from('conversations')
        .update({
          if (isClient)
            'unread_count_for_client': 0
          else
            'unread_count_for_pro': 0,
        })
        .eq('id', conversationId);

    final messages = await listMessages(conversationId);

    for (final message in messages) {
      if (!message.readBy.contains(userId)) {
        await _supabase
            .from('messages')
            .update({
              'read_by': [...message.readBy, userId],
            })
            .eq('id', message.id);
      }
    }
  }

  Future<void> deleteConversationForUser({
    required String conversationId,
    required String userId,
  }) async {
    final conversationResponse = await _supabase
        .from('conversations')
        .select()
        .eq('id', conversationId)
        .single();
    final conversation = ConversationModel.fromJson(conversationResponse);
    final isClient = conversation.clientId == userId;
    await _supabase
        .from('conversations')
        .update({
          if (isClient) 'deleted_for_client': true else 'deleted_for_pro': true,
        })
        .eq('id', conversationId);
  }

  void _cleanupConversationStream(String streamKey) {
    _conversationChannels['${streamKey}_client']?.unsubscribe();
    _conversationChannels.remove('${streamKey}_client');
    _conversationChannels['${streamKey}_pro']?.unsubscribe();
    _conversationChannels.remove('${streamKey}_pro');
    _conversationControllers[streamKey]?.close();
    _conversationControllers.remove(streamKey);
  }

  void _cleanupMessageStream(String streamKey) {
    _messageChannels[streamKey]?.unsubscribe();
    _messageChannels.remove(streamKey);
    _messageControllers[streamKey]?.close();
    _messageControllers.remove(streamKey);
  }

  void dispose() {
    for (final key in _conversationControllers.keys.toList()) {
      _cleanupConversationStream(key);
    }
    for (final key in _messageControllers.keys.toList()) {
      _cleanupMessageStream(key);
    }
  }
}
