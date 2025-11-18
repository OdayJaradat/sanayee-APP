part of 'chat_room_cubit.dart';

sealed class ChatRoomState extends Equatable {
  const ChatRoomState();

  const factory ChatRoomState.initial() = _Initial;
  const factory ChatRoomState.loading() = _Loading;
  const factory ChatRoomState.loaded(List<Message> messages) = _Loaded;
  const factory ChatRoomState.sending(List<Message> messages) = _Sending;
  const factory ChatRoomState.error(String message) = _Error;

  @override
  List<Object?> get props => [];
}

class _Initial extends ChatRoomState {
  const _Initial();
}

class _Loading extends ChatRoomState {
  const _Loading();
}

class _Loaded extends ChatRoomState {
  final List<Message> messages;

  const _Loaded(this.messages);

  @override
  List<Object?> get props => [messages];
}

class _Sending extends ChatRoomState {
  final List<Message> messages;

  const _Sending(this.messages);

  @override
  List<Object?> get props => [messages];
}

class _Error extends ChatRoomState {
  final String message;

  const _Error(this.message);

  @override
  List<Object?> get props => [message];
}
