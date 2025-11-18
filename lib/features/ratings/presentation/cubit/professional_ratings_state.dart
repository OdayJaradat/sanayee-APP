part of 'professional_ratings_cubit.dart';

class ProfessionalRatingsState extends Equatable {
  final bool isLoading;
  final List<Rating> ratings;
  final String? errorMessage;

  const ProfessionalRatingsState({
    required this.isLoading,
    required this.ratings,
    this.errorMessage,
  });

  factory ProfessionalRatingsState.initial() =>
      const ProfessionalRatingsState(isLoading: false, ratings: []);

  double get averageRating {
    if (ratings.isEmpty) {
      return 0;
    }
    final total = ratings.fold<double>(
      0.0,
      (sum, r) => sum + r.rating.toDouble(),
    );
    return total / ratings.length;
  }

  int get reviewsCount => ratings.length;

  ProfessionalRatingsState copyWith({
    bool? isLoading,
    List<Rating>? ratings,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ProfessionalRatingsState(
      isLoading: isLoading ?? this.isLoading,
      ratings: ratings ?? this.ratings,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [isLoading, ratings, errorMessage];
}
