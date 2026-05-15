import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/app_colors.dart';
import '../../../../core/config/app_spacing.dart';
import '../../admin_injection.dart';
import '../../domain/entities/admin_request_details.dart';
import '../cubit/admin_request_details_cubit.dart';
import '../widgets/admin_scaffold.dart';

/// Admin request details page with timeline
class AdminRequestDetailsPage extends StatelessWidget {
  final String requestId;

  const AdminRequestDetailsPage({
    super.key,
    required this.requestId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AdminInjection.createRequestDetailsCubit()..load(requestId),
      child: _AdminRequestDetailsView(requestId: requestId),
    );
  }
}

class _AdminRequestDetailsView extends StatelessWidget {
  final String requestId;

  const _AdminRequestDetailsView({required this.requestId});

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      title: 'تفاصيل الطلب',
      actions: [
        BlocBuilder<AdminRequestDetailsCubit, AdminRequestDetailsState>(
          builder: (context, state) {
            return IconButton(
              onPressed: state.isLoading
                  ? null
                  : () => context.read<AdminRequestDetailsCubit>().refresh(requestId),
              icon: state.isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.refresh_rounded),
              tooltip: 'تحديث',
            );
          },
        ),
      ],
      child: BlocBuilder<AdminRequestDetailsCubit, AdminRequestDetailsState>(
        builder: (context, state) {
          if (state.isLoading || state.isInitial) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.xl),
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (state.hasError) {
            return _buildErrorView(context, state.errorMessage!);
          }

          final details = state.dataOrNull!;
          return _buildContent(context, details);
        },
      ),
    );
  }

  Widget _buildErrorView(BuildContext context, String message) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 64,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'حدث خطأ',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.lg),
            FilledButton.icon(
              onPressed: () =>
                  context.read<AdminRequestDetailsCubit>().refresh(requestId),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, AdminRequestDetails details) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Breadcrumb / Back button
        _buildBreadcrumb(context),
        const SizedBox(height: AppSpacing.lg),

        // Main content in two columns
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left: Request Summary
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  _buildSummaryCard(context, details),
                  const SizedBox(height: AppSpacing.lg),
                  _buildOffersCard(context, details),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.lg),

            // Right: Timeline
            Expanded(
              child: _buildTimelineCard(context, details),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBreadcrumb(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        TextButton.icon(
          onPressed: () => context.go('/admin/requests'),
          icon: const Icon(Icons.arrow_back_rounded, size: 18),
          label: const Text('العودة للطلبات'),
          style: TextButton.styleFrom(
            foregroundColor: theme.colorScheme.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(BuildContext context, AdminRequestDetails details) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(Icons.assignment_rounded, color: theme.colorScheme.primary),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'ملخص الطلب',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              _buildStatusBadge(details.status),
            ],
          ),
          const Divider(height: AppSpacing.xl),

          // Title
          Text(
            details.title.isEmpty ? 'بدون عنوان' : details.title,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // Description
          if (details.description != null && details.description!.isNotEmpty)
            Text(
              details.description!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          const SizedBox(height: AppSpacing.lg),

          // Details Grid
          Wrap(
            spacing: AppSpacing.xl,
            runSpacing: AppSpacing.md,
            children: [
              _buildDetailItem(
                context,
                Icons.tag_rounded,
                'رقم الطلب',
                details.shortId,
              ),
              if (details.category != null)
                _buildDetailItem(
                  context,
                  Icons.category_rounded,
                  'التصنيف',
                  details.category!,
                ),
              if (details.budget != null)
                _buildDetailItem(
                  context,
                  Icons.attach_money_rounded,
                  'الميزانية',
                  '${details.budget!.toStringAsFixed(0)} ₪',
                ),
              if (details.city != null)
                _buildDetailItem(
                  context,
                  Icons.location_city_rounded,
                  'المدينة',
                  details.city!,
                ),
              _buildDetailItem(
                context,
                Icons.person_rounded,
                'العميل',
                details.clientName ?? '—',
              ),
              if (details.professionalName != null)
                _buildDetailItem(
                  context,
                  Icons.engineering_rounded,
                  'الصنايعي',
                  details.professionalName!,
                ),
              _buildDetailItem(
                context,
                Icons.calendar_today_rounded,
                'تاريخ الإنشاء',
                _formatDateTime(details.createdAt),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: theme.colorScheme.primary),
          const SizedBox(width: AppSpacing.sm),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
              Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOffersCard(BuildContext context, AdminRequestDetails details) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.local_offer_rounded, color: theme.colorScheme.primary),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'العروض (${details.offers.length})',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Divider(height: AppSpacing.xl),

          if (details.offers.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Text(
                  'لا توجد عروض',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ),
            )
          else
            ...details.offers.map((offer) => _buildOfferItem(context, offer)),
        ],
      ),
    );
  }

  Widget _buildOfferItem(BuildContext context, AdminOffer offer) {
    final theme = Theme.of(context);
    final isAccepted = offer.status == 'accepted';

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isAccepted
            ? Colors.green.withValues(alpha: 0.05)
            : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        border: Border.all(
          color: isAccepted
              ? Colors.green.withValues(alpha: 0.3)
              : theme.colorScheme.outlineVariant,
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: isAccepted
                ? Colors.green.withValues(alpha: 0.2)
                : Colors.orange.withValues(alpha: 0.2),
            child: Icon(
              isAccepted ? Icons.check_circle : Icons.person,
              color: isAccepted ? Colors.green : Colors.orange,
              size: 20,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  offer.professionalName ?? 'صنايعي',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (offer.message != null && offer.message!.isNotEmpty)
                  Text(
                    offer.message!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${offer.amount?.toStringAsFixed(0) ?? "—"} ₪',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryPurple,
                ),
              ),
              _buildOfferStatusBadge(offer.status),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineCard(BuildContext context, AdminRequestDetails details) {
    final theme = Theme.of(context);
    final events = details.timelineEvents;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.timeline_rounded, color: theme.colorScheme.primary),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'سجل الأحداث',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Divider(height: AppSpacing.xl),

          if (events.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Text(
                  'لا توجد أحداث',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ),
            )
          else
            ...events.asMap().entries.map((entry) {
              final index = entry.key;
              final event = entry.value;
              final isLast = index == events.length - 1;
              return _buildTimelineItem(context, event, isLast);
            }),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(
    BuildContext context,
    TimelineEvent event,
    bool isLast,
  ) {
    final theme = Theme.of(context);
    final color = _getEventColor(event.type);
    final icon = _getEventIcon(event.type);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline line and dot
        Column(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 16, color: color),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                color: theme.colorScheme.outlineVariant,
              ),
          ],
        ),
        const SizedBox(width: AppSpacing.md),

        // Content
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (event.description.isNotEmpty)
                  Text(
                    event.description,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                Text(
                  _formatDateTime(event.timestamp),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(String status) {
    final color = _getStatusColor(status);
    final label = _getStatusLabel(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildOfferStatusBadge(String status) {
    final color = status == 'accepted'
        ? Colors.green
        : status == 'rejected'
            ? Colors.red
            : Colors.grey;
    final label = status == 'accepted'
        ? 'مقبول'
        : status == 'rejected'
            ? 'مرفوض'
            : 'قيد الانتظار';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w500),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'open':
        return Colors.blue;
      case 'assigned':
        return Colors.purple;
      case 'pending_review':
        return Colors.orange;
      case 'completed':
        return Colors.green;
      case 'closed':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  String _getStatusLabel(String status) {
    switch (status) {
      case 'open':
        return 'مفتوح';
      case 'assigned':
        return 'قيد التنفيذ';
      case 'pending_review':
        return 'بانتظار المراجعة';
      case 'completed':
        return 'مكتمل';
      case 'closed':
        return 'مغلق';
      default:
        return status;
    }
  }

  Color _getEventColor(TimelineEventType type) {
    switch (type) {
      case TimelineEventType.requestCreated:
        return Colors.blue;
      case TimelineEventType.offerSubmitted:
        return Colors.orange;
      case TimelineEventType.requestAssigned:
        return Colors.purple;
      case TimelineEventType.requestCompleted:
        return Colors.green;
      case TimelineEventType.requestClosed:
        return Colors.grey;
    }
  }

  IconData _getEventIcon(TimelineEventType type) {
    switch (type) {
      case TimelineEventType.requestCreated:
        return Icons.add_circle_rounded;
      case TimelineEventType.offerSubmitted:
        return Icons.local_offer_rounded;
      case TimelineEventType.requestAssigned:
        return Icons.person_add_rounded;
      case TimelineEventType.requestCompleted:
        return Icons.check_circle_rounded;
      case TimelineEventType.requestClosed:
        return Icons.cancel_rounded;
    }
  }

  String _formatDateTime(DateTime? date) {
    if (date == null) return '—';
    return '${date.day}/${date.month}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
