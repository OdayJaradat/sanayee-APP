part of 'rating_cubit.dart';

class RatingState extends Equatable {
  final bool isSubmitting;
  final bool hasExistingRating;
  final bool submissionSuccess;
  final String? errorMessage;

  const RatingState({
    required this.isSubmitting,
    required this.hasExistingRating,
    required this.submissionSuccess,
    this.errorMessage,
  });

  factory RatingState.initial() => const RatingState(
    isSubmitting: false,
    hasExistingRating: false,
    submissionSuccess: false,
  );

  RatingState copyWith({
    bool? isSubmitting,
    bool? hasExistingRating,
    bool? submissionSuccess,
    String? errorMessage,
    bool clearError = false,
  }) {
    return RatingState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
      hasExistingRating: hasExistingRating ?? this.hasExistingRating,
      submissionSuccess: submissionSuccess ?? this.submissionSuccess,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
    isSubmitting,
    hasExistingRating,
    submissionSuccess,
    errorMessage,
  ];
}
