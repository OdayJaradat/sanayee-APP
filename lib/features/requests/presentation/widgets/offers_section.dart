import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/config/app_spacing.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../professionals/domain/entities/offer.dart';
import '../../../profile/domain/repositories/profile_repository.dart';
import '../../../../app/injection.dart';
import 'counter_offer_dialog.dart';

class OffersSection extends StatelessWidget {
  final List<Offer> offers;
  final bool canManageOffers;
  final Function(String offerId) onAccept;
  final Function(String offerId) onDecline;
  final Function(String offerId, double newAmount, String? note) onCounter;
  final String requestId;

  const OffersSection({
    super.key,
    required this.offers,
    required this.canManageOffers,
    required this.onAccept,
    required this.onDecline,
    required this.onCounter,
    required this.requestId,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppStrings.offers, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: AppSpacing.md),
        if (offers.isEmpty)
          const EmptyState(
            icon: Icons.local_offer_outlined,
            title: AppStrings.noOffers,
            message: '',
          )
        else
          ...offers.map(
            (offer) => _OfferCard(
              key: ValueKey('offer_card_${offer.id}'),
              offer: offer,
              canManageOffers: canManageOffers,
              onAccept: () => onAccept(offer.id),
              onDecline: () => onDecline(offer.id),
              onCounter: () => _showCounterDialog(context, offer),
            ),
          ),
      ],
    );
  }

  void _showCounterDialog(BuildContext context, Offer offer) {
    showDialog(
      context: context,
      builder: (context) => CounterOfferDialog(
        currentAmount: offer.amount,
        onSubmit: (newAmount, note) => onCounter(offer.id, newAmount, note),
      ),
    );
  }
}

class _OfferCard extends StatelessWidget {
  final Offer offer;
  final bool canManageOffers;
  final VoidCallback onAccept;
  final VoidCallback onDecline;
  final VoidCallback onCounter;

  const _OfferCard({
    super.key,
    required this.offer,
    required this.canManageOffers,
    required this.onAccept,
    required this.onDecline,
    required this.onCounter,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('yyyy-MM-dd HH:mm', 'ar');
    final theme = Theme.of(context);

    return AppCard(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.monetization_on,
                    color: theme.colorScheme.primary,
                    size: 20,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    '${offer.amount.toStringAsFixed(0)} شيكل',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
              _buildStatusChip(context, offer.status),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          _ProfessionalInfoWidget(professionalId: offer.professionalId),
          const SizedBox(height: AppSpacing.xs),
          Text(
            offer.professionalId,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),

          if (offer.note != null && offer.note!.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: theme.colorScheme.secondaryContainer.withValues(
                  alpha: 0.3,
                ),
                borderRadius: BorderRadius.circular(AppSpacing.sm),
                border: Border.all(
                  color: theme.colorScheme.secondaryContainer,
                  width: 1,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.note_outlined,
                    size: 18,
                    color: theme.colorScheme.onSecondaryContainer,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: Text(
                      offer.note!,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSecondaryContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Icon(
                Icons.access_time,
                size: 14,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                dateFormat.format(offer.createdAt),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),

          if (canManageOffers && offer.status == 'pending') ...[
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    key: ValueKey('btn_accept_${offer.id}'),
                    onPressed: onAccept,
                    label: AppStrings.offerAccept,
                    variant: AppButtonVariant.filled,
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: AppButton(
                    key: ValueKey('btn_decline_${offer.id}'),
                    onPressed: onDecline,
                    label: AppStrings.offerDecline,
                    variant: AppButtonVariant.outlined,
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: AppButton(
                    key: ValueKey('btn_counter_${offer.id}'),
                    onPressed: onCounter,
                    label: AppStrings.offerCounter,
                    variant: AppButtonVariant.outlined,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusChip(BuildContext context, String status) {
    final colorScheme = Theme.of(context).colorScheme;

    final (label, color) = switch (status) {
      'pending' => (AppStrings.statusPending, colorScheme.primary),
      'accepted' => (AppStrings.statusAccepted, Colors.green),
      'declined' => (AppStrings.statusDeclined, Colors.red),
      'countered' => (AppStrings.statusCountered, colorScheme.secondary),
      _ => (status, colorScheme.onSurface),
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _ProfessionalInfoWidget extends StatelessWidget {
  final String professionalId;

  const _ProfessionalInfoWidget({required this.professionalId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (!sl.isRegistered<ProfileRepository>()) {
      String displayName = '?????';
      return InkWell(
        onTap: () => context.push('/professionals/$professionalId'),
        borderRadius: BorderRadius.circular(AppSpacing.sm),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(AppSpacing.sm),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: theme.colorScheme.primaryContainer,
                child: Text(
                  displayName.isNotEmpty ? displayName[0] : '?',
                  style: TextStyle(
                    color: theme.colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayName,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'عرض الملف',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.6,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
              ),
            ],
          ),
        ),
      );
    }
    return FutureBuilder(
      future: sl<ProfileRepository>().getProfileById(professionalId),
      builder: (context, snapshot) {
        String displayName = 'صنايعي';

        if (snapshot.hasData) {
          final result = snapshot.data!;
          result.fold(
            (failure) => displayName = 'صنايعي',
            (profile) => displayName = profile.fullName,
          );
        }

        return InkWell(
          onTap: () => context.push('/professionals/$professionalId'),
          borderRadius: BorderRadius.circular(AppSpacing.sm),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(AppSpacing.sm),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: theme.colorScheme.primaryContainer,
                  child: Text(
                    displayName.isNotEmpty ? displayName[0] : 'م',
                    style: TextStyle(
                      color: theme.colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        displayName,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'انقر لعرض الملف الشخصي',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.6,
                          ),
                        ),
                      ),
                      Text(
                        'عرض الملف',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.6,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

