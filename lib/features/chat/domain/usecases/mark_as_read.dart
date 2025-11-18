import 'package:injectable/injectable.dart';
import '../../../../core/error/result.dart';
import '../repositories/chat_repository.dart';

@lazySingleton
class MarkAsRead {
  final ChatRepository _repository;

  MarkAsRead(this._repository);

  Future<Result<void>> call({
    required String conversationId,
    required String userId,
  }) {
    return _repository.markAsRead(
      conversationId: conversationId,
      userId: userId,
    );
  }
}
