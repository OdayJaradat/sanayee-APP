import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import '../../../../app/injection.dart';
import '../../../../core/config/app_spacing.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../shared/widgets/error_view.dart';
import '../../domain/entities/rating.dart';
import '../cubit/professional_ratings_cubit.dart';

class ProfessionalRatingsPage extends StatelessWidget {
  const ProfessionalRatingsPage({
    required this.professionalId,
    required this.professionalName,
    super.key,
  });

  final String professionalId;
  final String professionalName;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<ProfessionalRatingsCubit>()..loadRatings(professionalId),
      child: _ProfessionalRatingsView(
        professionalId: professionalId,
        professionalName: professionalName,
      ),
    );
  }
}

class _ProfessionalRatingsView extends StatelessWidget {
  const _ProfessionalRatingsView({
    required this.professionalId,
    required this.professionalName,
  });

  final String professionalId;
  final String professionalName;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.ratingListTitle(professionalName))),
      body: BlocBuilder<ProfessionalRatingsCubit, ProfessionalRatingsState>(
        builder: (context, state) {
          if (state.isLoading && state.ratings.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.errorMessage != null && state.ratings.isEmpty) {
            return ErrorView(
              message: state.errorMessage!,
              onRetry: () => context
                  .read<ProfessionalRatingsCubit>()
                  .loadRatings(professionalId),
            );
          }

          if (state.ratings.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Text(
                  AppStrings.ratingEmptyState,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium,
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => context
                .read<ProfessionalRatingsCubit>()
                .loadRatings(professionalId),
            child: ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.md),
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildHeader(theme, state),
                      const SizedBox(height: AppSpacing.lg),
                      _RatingListItem(rating: state.ratings[index]),
                    ],
                  );
                }
                return _RatingListItem(rating: state.ratings[index]);
              },
              separatorBuilder: (_, index) =>
                  const SizedBox(height: AppSpacing.md),
              itemCount: state.ratings.length,
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, ProfessionalRatingsState state) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              AppStrings.ratingOverallTitle,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            RatingBarIndicator(
              rating: state.averageRating,
              itemBuilder: (context, _) =>
                  const Icon(Icons.star, color: Colors.amber),
              itemCount: 5,
              itemSize: 32,
              direction: Axis.horizontal,
              unratedColor: theme.colorScheme.outline.withValues(alpha: 0.3),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              state.averageRating.toStringAsFixed(1),
              style: theme.textTheme.displaySmall?.copyWith(
                color: Colors.amber.shade700,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              AppStrings.ratingReviewsCount(state.reviewsCount),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RatingListItem extends StatelessWidget {
  const _RatingListItem({required this.rating});

  final Rating rating;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat.yMMMd();

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildStars(rating.rating),
                const Spacer(),
                Text(
                  dateFormat.format(rating.createdAt),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              rating.comment ?? AppStrings.ratingNoComment,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              AppStrings.ratingClientLabel(rating.clientId),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStars(int value) {
    return RatingBarIndicator(
      rating: value.toDouble(),
      itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.amber),
      itemCount: 5,
      itemSize: 20,
      direction: Axis.horizontal,
      unratedColor: Colors.grey.shade300,
    );
  }
}
