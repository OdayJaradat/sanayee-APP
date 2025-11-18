import 'package:injectable/injectable.dart';
import '../../../../core/error/result.dart';
import '../repositories/hiring_posts_repository.dart';

@injectable
class DeleteHiringPost {
  final HiringPostsRepository _repository;

  DeleteHiringPost(this._repository);

  
  Future<Result<void>> call(String postId) async {
    return await _repository.delete(postId);
  }
}
