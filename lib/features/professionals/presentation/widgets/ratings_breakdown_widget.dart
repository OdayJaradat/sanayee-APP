import 'package:flutter/material.dart';
import '../../../../app/injection.dart';
import '../../domain/repositories/professionals_repository.dart';
import '../../../../core/config/app_spacing.dart';

class RatingsBreakdownWidget extends StatelessWidget {
  final String professionalId;

  const RatingsBreakdownWidget({super.key, required this.professionalId});

  @override
  Widget build(BuildContext context) {
    final professionalRepo = sl<ProfessionalsRepository>();

    return FutureBuilder(
      future: professionalRepo.fetchRatingsBreakdown(professionalId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.md),
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.md),
              child: Text(
                'فشل في تحميل توزيع التقييمات',
                style: TextStyle(color: Colors.red),
              ),
            ),
          );
        }

        return snapshot.data!.when(
          ok: (breakdown) {
            if (breakdown.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.md),
                  child: Text('لا يوجد تقييمات بعد'),
                ),
              );
            }

            final sortedBreakdown = List.from(breakdown)
              ..sort((a, b) => b.rating.compareTo(a.rating));

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'توزيع التقييمات',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: AppSpacing.md),
                ...sortedBreakdown.map(
                  (item) => _buildRatingRow(
                    context: context,
                    rating: item.rating,
                    count: item.count,
                    percentage: item.percentage,
                  ),
                ),
              ],
            );
          },
          err: (failure) => Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Text(
                failure.message,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRatingRow({
    required BuildContext context,
    required int rating,
    required int count,
    required double percentage,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: Row(
              children: [
                Text(
                  '$rating',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.star, color: Colors.amber, size: 16),
              ],
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: percentage / 100.0,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(
                  _getColorForRating(rating),
                ),
                minHeight: 8,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          SizedBox(
            width: 80,
            child: Text(
              '${percentage.toStringAsFixed(0)}% ($count)',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Color _getColorForRating(int rating) {
    switch (rating) {
      case 5:
        return Colors.green;
      case 4:
        return Colors.lightGreen;
      case 3:
        return Colors.amber;
      case 2:
        return Colors.orange;
      case 1:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
