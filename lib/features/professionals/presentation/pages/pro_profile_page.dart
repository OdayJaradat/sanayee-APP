import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:sanayee_app/core/constants/app_strings.dart';
import 'package:sanayee_app/features/ratings/presentation/cubit/professional_ratings_cubit.dart';
import '../../../../app/injection.dart';
import '../../../../core/config/app_spacing.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/error_view.dart';
import '../cubit/pro_profile_cubit.dart';
import '../widgets/professional_stats_strip.dart';

class ProProfilePage extends StatelessWidget {
  final String professionalId;

  const ProProfilePage({required this.professionalId, super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              sl<ProProfileCubit>()..loadProfessional(professionalId),
        ),
        BlocProvider(
          create: (_) =>
              sl<ProfessionalRatingsCubit>()..loadRatings(professionalId),
        ),
      ],
      child: _ProProfileView(professionalId: professionalId),
    );
  }
}

class _ProProfileView extends StatelessWidget {
  final String professionalId;

  const _ProProfileView({required this.professionalId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('الملف الشخصي')),
      body: BlocBuilder<ProProfileCubit, ProProfileState>(
        builder: (context, state) {
          final stateStr = state.toString();

          if (stateStr.contains('Loading')) {
            return const Center(child: CircularProgressIndicator());
          }

          if (stateStr.contains('Error')) {
            final errorState = state as dynamic;
            return ErrorView(
              message: errorState.message ?? 'حدث خطأ',
              onRetry: () => context.read<ProProfileCubit>().loadProfessional(
                professionalId,
              ),
            );
          }

          if (stateStr.contains('Loaded')) {
            final loadedState = state as dynamic;
            final professional = loadedState.professional;
            final cubit = context.read<ProProfileCubit>();
            final stats = cubit.cachedStats;
            final ratingsState = context
                .watch<ProfessionalRatingsCubit>()
                .state;

            final double averageRating = stats != null
                ? stats.avgRating
                : (ratingsState.ratings.isNotEmpty
                      ? ratingsState.averageRating
                      : 0.0); 

            final String proId = professional.id.isEmpty
                ? professionalId
                : professional.id;

            final int reviewsCount = stats != null
                ? stats.ratingsCount
                : ratingsState.reviewsCount;

            final bool isRatingsLoading =
                ratingsState.isLoading && ratingsState.ratings.isEmpty;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppCard(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: theme.colorScheme.primaryContainer,
                          child: professional.avatarUrl != null
                              ? ClipOval(
                                  child: Image.network(
                                    professional.avatarUrl!,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Icon(
                                      Icons.person,
                                      size: 50,
                                      color:
                                          theme.colorScheme.onPrimaryContainer,
                                    ),
                                  ),
                                )
                              : Icon(
                                  Icons.person,
                                  size: 50,
                                  color: theme.colorScheme.onPrimaryContainer,
                                ),
                        ),
                        const SizedBox(height: AppSpacing.md),

                        Text(
                          professional.name,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacing.sm),

                        Column(
                          children: [
                            RatingBarIndicator(
                              rating: averageRating,
                              itemBuilder: (context, _) =>
                                  const Icon(Icons.star, color: Colors.amber),
                              itemCount: 5,
                              itemSize: 28,
                              direction: Axis.horizontal,
                              unratedColor: theme.colorScheme.outline
                                  .withValues(alpha: 0.3),
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  averageRating.toStringAsFixed(1),
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.amber[700],
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.xs),
                                if (isRatingsLoading)
                                  const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                else
                                  Text(
                                    AppStrings.ratingReviewsCountShort(
                                      reviewsCount,
                                    ),
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: theme.colorScheme.onSurface
                                          .withValues(alpha: 0.6),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Align(
                          child: OutlinedButton.icon(
                            onPressed: () => _openRatingsList(
                              context,
                              id: proId,
                              name: professional.name,
                            ),
                            icon: const Icon(Icons.reviews_outlined),
                            label: const Text(AppStrings.ratingViewAllButton),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  if (stats != null) ...[
                    ProfessionalStatsStrip(stats: stats),
                    const SizedBox(height: AppSpacing.lg),
                  ],

                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'المهارات',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Wrap(
                          spacing: AppSpacing.sm,
                          runSpacing: AppSpacing.sm,
                          children: professional.skills
                              .map<Widget>(
                                (skill) => Chip(
                                  label: Text(skill),
                                  backgroundColor:
                                      theme.colorScheme.secondaryContainer,
                                  labelStyle: TextStyle(
                                    color:
                                        theme.colorScheme.onSecondaryContainer,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ),
                  ),

                  if (professional.bio != null) ...[
                    const SizedBox(height: AppSpacing.lg),
                    AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'نبذة عني',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Text(
                            professional.bio!,
                            style: theme.textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _openRatingsList(
    BuildContext context, {
    required String id,
    required String name,
  }) {
    context.push('/professionals/$id/ratings', extra: name);
  }
}
