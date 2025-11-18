import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import '../../../../core/config/app_spacing.dart';
import '../../../../core/config/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/specializations.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../domain/entities/service_request.dart';

class RequestCard extends StatelessWidget {
  final ServiceRequest request;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const RequestCard({
    required this.request,
    this.onTap,
    this.onDelete,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Slidable(
      key: ValueKey('slidable_${request.id}'),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (_) {
              if (onDelete != null) {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('حذف الطلب'),
                    content: const Text('هل أنت متأكد من حذف هذا الطلب؟'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        child: const Text('إلغاء'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                          onDelete!();
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.red,
                        ),
                        child: const Text('حذف'),
                      ),
                    ],
                  ),
                );
              }
            },
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'حذف',
          ),
        ],
      ),
      child: AppCard(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    request.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                _buildStatusChip(context),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              request.description,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Icon(
                  Icons.category_outlined,
                  size: 16,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  _getCategoryLabel(request.category),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                const Spacer(),
                if (request.budget != null) ...[
                  Icon(
                    Icons.attach_money,
                    size: 16,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    '${request.budget!.toStringAsFixed(0)} ₪',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              _formatDate(request.createdAt),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(BuildContext context) {
    final (label, color) = _getStatusInfo(request.status);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  (String, Color) _getStatusInfo(String status) {
    return switch (status) {
      'open' => (AppStrings.statusOpen, AppColors.info),
      'negotiating' => (AppStrings.statusNegotiating, AppColors.warning),
      'assigned' => (AppStrings.statusAssigned, AppColors.primaryPurple),
      'done' => (AppStrings.statusDone, AppColors.success),
      'canceled' => (AppStrings.statusCanceled, AppColors.error),
      _ => (status, AppColors.neutral500),
    };
  }

  String _getCategoryLabel(String category) {
    if (Specializations.all.contains(category)) {
      return category;
    }
    return category;
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 60) {
      return 'منذ ${difference.inMinutes} دقيقة';
    } else if (difference.inHours < 24) {
      return 'منذ ${difference.inHours} ساعة';
    } else if (difference.inDays < 7) {
      return 'منذ ${difference.inDays} يوم';
    } else {
      return DateFormat('dd/MM/yyyy').format(date);
    }
  }
}
