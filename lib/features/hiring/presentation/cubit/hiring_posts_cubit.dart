import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/job_type.dart';
import '../../domain/entities/service_category.dart';
import '../../domain/entities/pay_type.dart';
import '../../domain/entities/post_status.dart';
import '../../domain/usecases/close_hiring_post.dart';
import '../../domain/usecases/create_hiring_post.dart';
import '../../domain/usecases/delete_hiring_post.dart';
import '../../domain/usecases/reopen_hiring_post.dart';
import '../../domain/usecases/list_my_hiring_posts.dart';
import '../../domain/usecases/list_open_hiring_posts.dart';
import 'hiring_posts_state.dart';

@injectable
class HiringPostsCubit extends Cubit<HiringPostsState> {
  final CreateHiringPost _createHiringPost;
  final CloseHiringPost _closeHiringPost;
  final ReopenHiringPost _reopenHiringPost;
  final DeleteHiringPost _deleteHiringPost;
  final ListMyHiringPosts _listMyHiringPosts;
  final ListOpenHiringPosts _listOpenHiringPosts;

  HiringPostsCubit(
    this._createHiringPost,
    this._closeHiringPost,
    this._reopenHiringPost,
    this._deleteHiringPost,
    this._listMyHiringPosts,
    this._listOpenHiringPosts,
  ) : super(const HiringPostsInitial());

  Future<void> loadMyPosts(String professionalId) async {
    emit(const HiringPostsLoading());

    final result = await _listMyHiringPosts(professionalId);

    result.when(
      ok: (posts) => emit(HiringPostsLoaded(posts)),
      err: (failure) => emit(HiringPostsError(failure.message)),
    );
  }

  Future<void> loadOpenPosts() async {
    emit(const HiringPostsLoading());

    final result = await _listOpenHiringPosts();

    result.when(
      ok: (posts) => emit(HiringPostsLoaded(posts)),
      err: (failure) => emit(HiringPostsError(failure.message)),
    );
  }

  Future<void> createPost({
    String? professionalId,
    required String title,
    required String description,
    required JobType jobType,
    String? durationText,
    double? salaryAmount,
    Map<String, double>? location,
    ServiceCategory? category,
    String? governorate,
    String? locality,
    String? address,
    PayType? payType,
    double? fixedAmount,
    double? rangeMin,
    double? rangeMax,
  }) async {
    emit(const HiringPostOperationLoading());

    final result = await _createHiringPost(
      professionalId: professionalId ?? '',
      title: title,
      description: description,
      jobType: jobType,
      durationText: durationText,
      salaryAmount: salaryAmount,
      location: location,
      category: category,
      governorate: governorate,
      locality: locality,
      address: address,
      payType: payType,
      fixedAmount: fixedAmount,
      rangeMin: rangeMin,
      rangeMax: rangeMax,
    );

    result.when(
      ok: (_) => emit(const HiringPostOperationSuccess('تم نشر الطلب بنجاح')),
      err: (failure) => emit(HiringPostOperationError(failure.message)),
    );
  }

  Future<void> closePost(String postId) async {
    
    final result = await _closeHiringPost(postId);

    await result.when(
      ok: (_) async {
        if (state is HiringPostsLoaded) {
          final currentPosts = (state as HiringPostsLoaded).posts;
          final updatedPosts = currentPosts.map((post) {
            if (post.id == postId) {
              return post.copyWith(status: PostStatus.closed);
            }
            return post;
          }).toList();

          
          emit(HiringPostsLoaded(updatedPosts));

          await Future.delayed(const Duration(milliseconds: 50));
          emit(const HiringPostOperationSuccess('تم إغلاق الإعلان بنجاح'));

          
          await Future.delayed(const Duration(milliseconds: 50));
          emit(HiringPostsLoaded(updatedPosts));
        }
      },
      err: (failure) async => emit(HiringPostOperationError(failure.message)),
    );
  }

  Future<void> reopenPost(String postId) async {
    
    final result = await _reopenHiringPost(postId);

    await result.when(
      ok: (_) async {
        if (state is HiringPostsLoaded) {
          final currentPosts = (state as HiringPostsLoaded).posts;
          final updatedPosts = currentPosts.map((post) {
            if (post.id == postId) {
              return post.copyWith(status: PostStatus.open);
            }
            return post;
          }).toList();

          
          emit(HiringPostsLoaded(updatedPosts));

          await Future.delayed(const Duration(milliseconds: 50));
          emit(
            const HiringPostOperationSuccess('تم إعادة تفعيل الإعلان بنجاح'),
          );

          
          await Future.delayed(const Duration(milliseconds: 50));
          emit(HiringPostsLoaded(updatedPosts));
        }
      },
      err: (failure) async => emit(HiringPostOperationError(failure.message)),
    );
  }

  Future<void> deletePost(String postId) async {
    
    final result = await _deleteHiringPost(postId);

    await result.when(
      ok: (_) async {
        if (state is HiringPostsLoaded) {
          final currentPosts = (state as HiringPostsLoaded).posts;
          final updatedPosts = currentPosts
              .where((p) => p.id != postId)
              .toList();

          
          emit(HiringPostsLoaded(updatedPosts));

          await Future.delayed(const Duration(milliseconds: 50));
          emit(const HiringPostOperationSuccess('تم حذف الإعلان نهائياً'));

          
          await Future.delayed(const Duration(milliseconds: 50));
          emit(HiringPostsLoaded(updatedPosts));
        }
      },
      err: (failure) async => emit(HiringPostOperationError(failure.message)),
    );
  }
}
