import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/conversation.dart';
import '../../domain/repositories/chat_repository.dart';
import '../../domain/usecases/stream_conversations.dart';
import '../../../requests/domain/usecases/get_request_by_id.dart';
import '../../../auth/domain/usecases/get_current_user.dart';
import '../../../profile/domain/repositories/profile_repository.dart';

part 'chat_list_state.dart';

@injectable
class ChatListCubit extends Cubit<ChatListState> {
  final StreamConversations _streamConversations;
  final GetRequestById _getRequestById;
  final GetCurrentUser _getCurrentUser;
  final ProfileRepository _profileRepository;
  final ChatRepository _chatRepository;

  StreamSubscription? _conversationsSubscription;

  ChatListCubit(
    this._streamConversations,
    this._getRequestById,
    this._getCurrentUser,
    this._profileRepository,
    this._chatRepository,
  ) : super(const ChatListState.initial());

  
  Future<void> streamConversations() async {
    emit(const ChatListState.loading());

    try {
      final userResult = await _getCurrentUser();

      userResult.fold(
        (failure) {
          if (!isClosed) {
            emit(ChatListState.error(failure.message));
          }
        },
        (user) {
          if (user == null) {
            if (!isClosed) {
              emit(const ChatListState.error('المستخدم غير مسجل دخول'));
            }
            return;
          }

          streamConversationsFor(user.id);
        },
      );
    } catch (e) {
      if (!isClosed) {
        emit(ChatListState.error('فشل تحميل المحادثات: ${e.toString()}'));
      }
    }
  }

  void streamConversationsFor(String userId) {
    emit(const ChatListState.loading());

    _conversationsSubscription?.cancel();
    _conversationsSubscription = _streamConversations(userId).listen(
      (result) async {
        result.when(
          ok: (conversations) async {
            final conversationsWithTitles = <ConversationWithTitle>[];

            for (final conv in conversations) {
              String displayName = 'محادثة';
              String subtitle = '';

              final otherUserId = conv.clientId == userId
                  ? conv.professionalId
                  : conv.clientId;

              final profileResult = await _profileRepository.getProfileById(
                otherUserId,
              );
              profileResult.fold(
                (failure) {
                  displayName = 'مستخدم';
                },
                (profile) {
                  displayName = profile.fullName;
                },
              );

              if (conv.requestId.startsWith('hiring-')) {
                subtitle = 'محادثة توظيف';
              } else {
                final requestResult = await _getRequestById(conv.requestId);
                requestResult.when(
                  ok: (request) => subtitle = request.title,
                  err: (_) => subtitle = 'طلب خدمة',
                );
              }

              conversationsWithTitles.add(
                ConversationWithTitle(
                  conversation: conv,
                  requestTitle: displayName,
                  requestSubtitle: subtitle,
                ),
              );
            }

            
            if (!isClosed) {
              emit(ChatListState.loaded(conversationsWithTitles));
            }
          },
          err: (failure) {
            if (!isClosed) {
              emit(ChatListState.error(failure.message));
            }
          },
        );
      },
      onError: (error) {
        if (!isClosed) {
          emit(ChatListState.error('خطأ في الاتصال: ${error.toString()}'));
        }
      },
    );
  }

  Future<void> deleteConversation({
    required String conversationId,
    required String userId,
  }) async {
    try {
      final result = await _chatRepository.deleteConversationForUser(
        conversationId: conversationId,
        userId: userId,
      );

      result.when(
        ok: (_) {},
        err: (failure) {
          if (!isClosed) {
            emit(ChatListState.error('فشل حذف المحادثة: ${failure.message}'));
          }
        },
      );
    } catch (e) {
      if (!isClosed) {
        emit(ChatListState.error('فشل حذف المحادثة: ${e.toString()}'));
      }
    }
  }

  @override
  Future<void> close() {
    _conversationsSubscription?.cancel();
    return super.close();
  }
}

class ConversationWithTitle {
  final Conversation conversation;
  final String requestTitle; 
  final String requestSubtitle; 

  ConversationWithTitle({
    required this.conversation,
    required this.requestTitle,
    required this.requestSubtitle,
  });
}
