import 'package:equatable/equatable.dart';
import '../../domain/entities/hiring_post.dart';

abstract class HiringPostsState extends Equatable {
  const HiringPostsState();

  @override
  List<Object?> get props => [];
}

class HiringPostsInitial extends HiringPostsState {
  const HiringPostsInitial();
}

class HiringPostsLoading extends HiringPostsState {
  const HiringPostsLoading();
}

class HiringPostsLoaded extends HiringPostsState {
  final List<HiringPost> posts;

  const HiringPostsLoaded(this.posts);

  @override
  List<Object?> get props => [posts];
}

class HiringPostsError extends HiringPostsState {
  final String message;

  const HiringPostsError(this.message);

  @override
  List<Object?> get props => [message];
}

class HiringPostOperationLoading extends HiringPostsState {
  const HiringPostOperationLoading();
}

class HiringPostOperationSuccess extends HiringPostsState {
  final String message;

  const HiringPostOperationSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class HiringPostOperationError extends HiringPostsState {
  final String message;

  const HiringPostOperationError(this.message);

  @override
  List<Object?> get props => [message];
}
