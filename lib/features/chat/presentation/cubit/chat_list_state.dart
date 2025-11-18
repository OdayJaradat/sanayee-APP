part of 'chat_list_cubit.dart';

sealed class ChatListState extends Equatable {
  const ChatListState();

  const factory ChatListState.initial() = _Initial;
  const factory ChatListState.loading() = _Loading;
  const factory ChatListState.loaded(
    List<ConversationWithTitle> conversations,
  ) = _Loaded;
  const factory ChatListState.error(String message) = _Error;

  @override
  List<Object?> get props => [];
}

class _Initial extends ChatListState {
  const _Initial();
}

class _Loading extends ChatListState {
  const _Loading();
}

class _Loaded extends ChatListState {
  final List<ConversationWithTitle> conversations;

  const _Loaded(this.conversations);

  @override
  List<Object?> get props => [conversations];
}

class _Error extends ChatListState {
  final String message;

  const _Error(this.message);

  @override
  List<Object?> get props => [message];
}
