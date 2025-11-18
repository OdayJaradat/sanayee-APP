import 'package:injectable/injectable.dart';
import '../../../../core/error/result.dart';
import '../repositories/hiring_posts_repository.dart';

@injectable
class CloseHiringPost {
  final HiringPostsRepository _repository;

  CloseHiringPost(this._repository);

  
  
  
  Future<Result<void>> call(String postId) async {
    return await _repository.close(postId);
  }
}
