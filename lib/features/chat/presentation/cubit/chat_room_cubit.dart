import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/message.dart';
import '../../domain/usecases/stream_messages.dart';
import '../../domain/usecases/send_message.dart';
import '../../domain/usecases/mark_as_read.dart';

part 'chat_room_state.dart';

@injectable
class ChatRoomCubit extends Cubit<ChatRoomState> {
  final StreamMessages _streamMessages;
  final SendMessage _sendMessage;
  final MarkAsRead _markAsRead;

  StreamSubscription? _messagesSubscription;

  ChatRoomCubit(this._streamMessages, this._sendMessage, this._markAsRead)
    : super(const ChatRoomState.initial());

  void streamMessagesFor(String conversationId) {
    emit(const ChatRoomState.loading());

    _messagesSubscription?.cancel();
    _messagesSubscription = _streamMessages(conversationId).listen((result) {
      result.when(
        ok: (messages) => emit(ChatRoomState.loaded(messages)),
        err: (failure) => emit(ChatRoomState.error(failure.message)),
      );
    });
  }

  Future<void> markConversationAsRead({
    required String conversationId,
    required String userId,
  }) async {
    await _markAsRead(conversationId: conversationId, userId: userId);
  }

  Future<void> sendMessageAction({
    required String conversationId,
    required String senderId,
    required String text,
  }) async {
    final result = await _sendMessage(
      conversationId: conversationId,
      senderId: senderId,
      text: text,
    );

    result.when(
      ok: (_) {}, 
      err: (failure) {
        emit(ChatRoomState.error(failure.message));
      },
    );
  }

  @override
  Future<void> close() {
    _messagesSubscription?.cancel();
    return super.close();
  }
}
