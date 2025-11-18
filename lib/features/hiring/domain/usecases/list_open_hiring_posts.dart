import 'package:injectable/injectable.dart';
import '../../../../core/error/result.dart';
import '../entities/hiring_post.dart';
import '../repositories/hiring_posts_repository.dart';

@injectable
class ListOpenHiringPosts {
  final HiringPostsRepository _repository;

  ListOpenHiringPosts(this._repository);

  
  
  
  
  Future<Result<List<HiringPost>>> call() async {
    return await _repository.listOpenPosts();
  }
}
