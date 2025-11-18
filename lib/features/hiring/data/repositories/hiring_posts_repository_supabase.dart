import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/error/result.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/hiring_post.dart';
import '../../domain/repositories/hiring_posts_repository.dart';
import '../datasources/hiring_posts_supabase_datasource.dart';
import '../models/hiring_post_model.dart';


@LazySingleton(as: HiringPostsRepository, env: [Environment.prod])
class HiringPostsRepositorySupabase implements HiringPostsRepository {
  final HiringPostsSupabaseDataSource _dataSource;

  HiringPostsRepositorySupabase(this._dataSource);

  @override
  Future<Result<HiringPost>> create(HiringPost post) async {
    try {
      final model = HiringPostModel.fromEntity(post);
      final result = await _dataSource.create(model);
      return Ok(result.toEntity());
    } on PostgrestException catch (e) {
      return Err(_handlePostgrestError(e));
    } catch (e) {
      return Err(ServerFailure('فشل في إنشاء الإعلان: $e'));
    }
  }

  @override
  Future<Result<void>> close(String postId) async {
    try {
      await _dataSource.close(postId);
      return const Ok(null);
    } on PostgrestException catch (e) {
      return Err(_handlePostgrestError(e));
    } catch (e) {
      return Err(ServerFailure('فشل في إغلاق الإعلان: $e'));
    }
  }

  @override
  Future<Result<void>> reopen(String postId) async {
    try {
      await _dataSource.reopen(postId);
      return const Ok(null);
    } on PostgrestException catch (e) {
      return Err(_handlePostgrestError(e));
    } catch (e) {
      return Err(ServerFailure('فشل في إعادة تفعيل الإعلان: $e'));
    }
  }

  @override
  Future<Result<void>> delete(String postId) async {
    try {
      await _dataSource.delete(postId);
      return const Ok(null);
    } on PostgrestException catch (e) {
      return Err(_handlePostgrestError(e));
    } catch (e) {
      return Err(ServerFailure('فشل في حذف الإعلان: $e'));
    }
  }

  @override
  Future<Result<List<HiringPost>>> listMyPosts(String professionalId) async {
    try {
      final models = await _dataSource.listMyPosts(professionalId);
      final entities = models.map((m) => m.toEntity()).toList();
      return Ok(entities);
    } on PostgrestException catch (e) {
      return Err(_handlePostgrestError(e));
    } catch (e) {
      return Err(ServerFailure('فشل في جلب الإعلانات: $e'));
    }
  }

  @override
  Future<Result<List<HiringPost>>> listOpenPosts() async {
    try {
      final models = await _dataSource.listOpenPosts();
      final entities = models.map((m) => m.toEntity()).toList();
      return Ok(entities);
    } on PostgrestException catch (e) {
      return Err(_handlePostgrestError(e));
    } catch (e) {
      return Err(ServerFailure('فشل في جلب الإعلانات: $e'));
    }
  }

  @override
  Future<Result<HiringPost>> getById(String postId) async {
    try {
      final model = await _dataSource.getById(postId);
      return Ok(model.toEntity());
    } on PostgrestException catch (e) {
      return Err(_handlePostgrestError(e));
    } catch (e) {
      return Err(ServerFailure('فشل في جلب الإعلان: $e'));
    }
  }

  
  Failure _handlePostgrestError(PostgrestException e) {
    final code = e.code;
    final message = e.message;

    if (code == '23503') {
      return const NotFoundFailure('المستخدم غير موجود');
    } else if (code == '23514') {
      return const ValidationFailure('بيانات الإعلان غير صحيحة');
    } else if (code == '42501') {
      return const UnauthorizedFailure('ليس لديك صلاحية لتعديل هذا الإعلان');
    }

    return ServerFailure('خطأ في قاعدة البيانات: $message (Code: $code)');
  }
}
