import 'package:injectable/injectable.dart';
import '../../../../core/error/result.dart';
import '../repositories/hiring_posts_repository.dart';

@injectable
class ReopenHiringPost {
  final HiringPostsRepository _repository;

  ReopenHiringPost(this._repository);

  
  
  
  Future<Result<void>> call(String postId) async {
    return await _repository.reopen(postId);
  }
}
