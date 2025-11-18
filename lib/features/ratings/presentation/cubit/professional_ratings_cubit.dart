import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/rating.dart';
import '../../domain/usecases/get_ratings_for_professional_use_case.dart';

part 'professional_ratings_state.dart';

@injectable
class ProfessionalRatingsCubit extends Cubit<ProfessionalRatingsState> {
  ProfessionalRatingsCubit(this._getRatingsForProfessionalUseCase)
    : super(ProfessionalRatingsState.initial());

  final GetRatingsForProfessionalUseCase _getRatingsForProfessionalUseCase;

  Future<void> loadRatings(String professionalId) async {
    emit(state.copyWith(isLoading: true, clearError: true));

    final result = await _getRatingsForProfessionalUseCase(
      professionalId.trim(),
    );

    result.when(
      ok: (ratings) {
        emit(
          state.copyWith(isLoading: false, ratings: ratings, clearError: true),
        );
      },
      err: (failure) {
        emit(state.copyWith(isLoading: false, errorMessage: failure.message));
      },
    );
  }
}
