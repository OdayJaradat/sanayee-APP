import 'package:flutter/material.dart';
import '../../../../core/config/app_spacing.dart';
import '../../data/models/professional_stats_model.dart';



class ProfessionalStatsStrip extends StatelessWidget {
  final ProfessionalStatsModel stats;

  const ProfessionalStatsStrip({required this.stats, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            context,
            icon: Icons.star,
            iconColor: Colors.amber,
            value: _formatRating(stats.avgRating),
            label: 'التقييم',
          ),
          _buildDivider(theme),
          _buildStatItem(
            context,
            icon: Icons.reviews,
            iconColor: theme.colorScheme.primary,
            value: stats.ratingsCount.toString(),
            label: 'تقييم',
          ),
          _buildDivider(theme),
          _buildStatItem(
            context,
            icon: Icons.check_circle,
            iconColor: Colors.green,
            value: stats.completedRequests.toString(),
            label: 'طلب منجز',
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String value,
    required String label,
  }) {
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: iconColor, size: 20),
        const SizedBox(width: AppSpacing.xs),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDivider(ThemeData theme) {
    return Container(
      height: 32,
      width: 1,
      color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
    );
  }

  
  String _formatRating(double rating) {
    final rounded = (rating * 2).round() / 2;
    return rounded.toStringAsFixed(1);
  }
}
