import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/rating.dart';
import '../../domain/usecases/add_rating_use_case.dart';
import '../../domain/usecases/get_ratings_for_professional_use_case.dart';

part 'rating_state.dart';

@injectable
class RatingCubit extends Cubit<RatingState> {
  RatingCubit(this._addRatingUseCase, this._getRatingsForProfessionalUseCase)
    : super(RatingState.initial());

  final AddRatingUseCase _addRatingUseCase;
  final GetRatingsForProfessionalUseCase _getRatingsForProfessionalUseCase;

  Future<void> checkExistingRating({
    required String professionalId,
    required String requestId,
    required String clientId,
    
  }) async {
    final result = await _getRatingsForProfessionalUseCase(
      professionalId.trim(),
    );

    result.when(
      ok: (ratings) {
        final hasRating = ratings.any(
          (rating) =>
              rating.requestId == requestId && rating.clientId == clientId,
        );
        emit(state.copyWith(hasExistingRating: hasRating, clearError: true));
      },
      err: (failure) {
        emit(state.copyWith(errorMessage: failure.message));
      },
    );
  }

  Future<void> submitRating(Rating rating) async {
    emit(
      state.copyWith(
        isSubmitting: true,
        submissionSuccess: false,
        clearError: true,
      ),
    );

    final result = await _addRatingUseCase(rating);

    result.when(
      ok: (_) {
        emit(
          state.copyWith(
            isSubmitting: false,
            submissionSuccess: true,
            hasExistingRating: true,
          ),
        );
      },
      err: (failure) {
        emit(
          state.copyWith(
            isSubmitting: false,
            errorMessage: failure.message,
            submissionSuccess: false,
          ),
        );
      },
    );
  }

  void clearError() {
    emit(state.copyWith(clearError: true));
  }

  void resetSuccess() {
    emit(state.copyWith(submissionSuccess: false));
  }
}
