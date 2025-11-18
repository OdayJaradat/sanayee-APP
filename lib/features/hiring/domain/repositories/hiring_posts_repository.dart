import '../../../../core/error/result.dart';
import '../entities/hiring_post.dart';

abstract class HiringPostsRepository {
  
  Future<Result<HiringPost>> create(HiringPost post);

  
  Future<Result<void>> close(String postId);

  
  Future<Result<void>> reopen(String postId);

  
  Future<Result<void>> delete(String postId);

  
  Future<Result<List<HiringPost>>> listMyPosts(String professionalId);

  
  Future<Result<List<HiringPost>>> listOpenPosts();

  
  Future<Result<HiringPost>> getById(String postId);
}
