import 'package:injectable/injectable.dart';
import '../../../../core/error/result.dart';
import '../entities/hiring_post.dart';
import '../repositories/hiring_posts_repository.dart';

@injectable
class ListMyHiringPosts {
  final HiringPostsRepository _repository;

  ListMyHiringPosts(this._repository);

  
  
  
  Future<Result<List<HiringPost>>> call(String professionalId) async {
    return await _repository.listMyPosts(professionalId);
  }
}
