import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:sanayee_app/features/ratings/presentation/cubit/rating_cubit.dart';
import 'package:sanayee_app/features/ratings/presentation/widgets/rating_dialog.dart';
import '../../../../app/injection.dart';
import '../../../../core/config/app_spacing.dart';
import '../../../../core/config/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/error_view.dart';
import '../../domain/entities/service_request.dart';
import '../../../professionals/domain/entities/offer.dart';
import '../cubit/request_details_cubit.dart';
import '../cubit/requests_cubit.dart';
import '../widgets/offers_section.dart';

class RequestDetailsPage extends StatelessWidget {
  final String requestId;
  final bool isClientView;

  const RequestDetailsPage({
    required this.requestId,
    this.isClientView = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<RequestDetailsCubit>()..loadRequest(requestId),
        ),
        BlocProvider(create: (_) => sl<RatingCubit>()),
      ],
      child: _RequestDetailsView(
        requestId: requestId,
        isClientView: isClientView,
      ),
    );
  }
}

class _RequestDetailsView extends StatefulWidget {
  final String requestId;
  final bool isClientView;

  const _RequestDetailsView({
    required this.requestId,
    required this.isClientView,
  });

  @override
  State<_RequestDetailsView> createState() => _RequestDetailsViewState();
}

class _RequestDetailsViewState extends State<_RequestDetailsView> {
  String? _handledRatingRequestId;
  bool _dialogOpen = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RequestDetailsCubit, RequestDetailsState>(
      listener: (context, state) async {
        if (state.toString().contains('Deleted')) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('تم حذف الطلب بنجاح'),
              backgroundColor: Colors.green,
            ),
          );

          context.pop(true);
        }

        if (state.toString().contains('OfferAccepted')) {
          final acceptedState = state as dynamic;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(acceptedState.message ?? 'تم قبول العرض'),
              backgroundColor: Colors.green,
              action: SnackBarAction(
                label: AppStrings.openChat,
                onPressed: () {
                  context.push('/chats/${acceptedState.conversationId}');
                },
              ),
            ),
          );
          context.read<RequestsCubit>().loadRequests();
        }

        if (state.toString().contains('OfferActionSuccess')) {
          final successState = state as dynamic;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(successState.message ?? 'تمت العملية بنجاح'),
              backgroundColor: Colors.green,
            ),
          );
          context.read<RequestsCubit>().loadRequests();
        }

        if (state.toString().contains('CompletionConfirmed')) {
          final confirmedState = state as dynamic;

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(confirmedState.message ?? 'تم تأكيد الإنجاز بنجاح'),
              backgroundColor: Colors.green,
            ),
          );

          context.read<RequestsCubit>().loadRequests();
        }

        if (state.toString().contains('Loaded')) {
          final loadedState = state as dynamic;
          final request = loadedState.request as ServiceRequest;

          if (widget.isClientView &&
              request.status == 'completed' &&
              request.completedAt != null &&
              _handledRatingRequestId != request.id) {
            await _maybeShowRatingDialog(context, request);
          }
        }
      },
      builder: (context, state) {
        final stateStr = state.toString();

        if (stateStr.contains('Loading')) {
          return Scaffold(
            appBar: AppBar(title: const Text('تفاصيل الطلب')),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        if (stateStr.contains('Error')) {
          final errorState = state as dynamic;
          return Scaffold(
            appBar: AppBar(title: const Text('تفاصيل الطلب')),
            body: ErrorView(
              message: errorState.message ?? 'حدث خطأ',
              onRetry: () {
                final cubit = context.read<RequestDetailsCubit>();
                final router = GoRouter.of(context);
                final location = router.routerDelegate.currentConfiguration.uri
                    .toString();
                final id = location.split('/').last;
                cubit.loadRequest(id);
              },
            ),
          );
        }

        if (stateStr.contains('Loaded')) {
          final loadedState = state as dynamic;
          return _buildRequestDetails(
            context,
            loadedState.request,
            loadedState.offers,
            isDeleting: false,
            isOfferActionInProgress: false,
          );
        }

        if (stateStr.contains('OfferActionInProgress')) {
          final progressState = state as dynamic;
          return _buildRequestDetails(
            context,
            progressState.request,
            progressState.offers,
            isDeleting: false,
            isOfferActionInProgress: true,
          );
        }

        if (stateStr.contains('Deleting')) {
          final loadedData = state as dynamic;
          try {
            return _buildRequestDetails(
              context,
              loadedData.request,
              loadedData.offers,
              isDeleting: true,
              isOfferActionInProgress: false,
            );
          } catch (e) {
            return Scaffold(
              appBar: AppBar(title: const Text('تفاصيل الطلب')),
              body: const Center(child: CircularProgressIndicator()),
            );
          }
        }

        return Scaffold(
          appBar: AppBar(title: const Text('تفاصيل الطلب')),
          body: const Center(child: Text('لا توجد بيانات')),
        );
      },
    );
  }

  Widget _buildRequestDetails(
    BuildContext context,
    ServiceRequest request,
    List<Offer> offers, {
    required bool isDeleting,
    required bool isOfferActionInProgress,
  }) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('تفاصيل الطلب')),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildStatusChip(context, request.status),
                const SizedBox(height: AppSpacing.lg),

                // show rejection reason if job rejected
                if (request.rejectionReason != null &&
                    request.rejectionReason!.isNotEmpty) ...[
                  _buildRejectionNotice(context, request),
                  const SizedBox(height: AppSpacing.lg),
                ],

                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'معلومات الطلب',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _buildInfoRow(
                        context,
                        Icons.title,
                        AppStrings.title,
                        request.title,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _buildInfoRow(
                        context,
                        Icons.description,
                        AppStrings.description,
                        request.description,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _buildInfoRow(
                        context,
                        Icons.category,
                        AppStrings.category,
                        _getCategoryLabel(request.category),
                      ),
                      if (request.budget != null) ...[
                        const SizedBox(height: AppSpacing.md),
                        _buildInfoRow(
                          context,
                          Icons.attach_money,
                          AppStrings.budget,
                          '${request.budget!.toStringAsFixed(0)} ₪',
                        ),
                      ],
                      const SizedBox(height: AppSpacing.md),
                      _buildInfoRow(
                        context,
                        Icons.calendar_today,
                        'تاريخ الإنشاء',
                        DateFormat(
                          'yyyy-MM-dd HH:mm',
                        ).format(request.createdAt),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSpacing.md),

                if (request.assignedProfessionalId != null &&
                    (request.status == 'assigned' ||
                        request.status == 'pending_review' ||
                        request.status == 'completed')) ...[
                  _buildProfessionalInfoCard(context, request),
                  const SizedBox(height: AppSpacing.md),
                ],

                if (request.status == 'completed' &&
                    request.completedAt != null) ...[
                  _buildCompletionDetailsCard(context, request),
                  const SizedBox(height: AppSpacing.md),
                ],

                _buildOffersSection(
                  context,
                  request,
                  offers,
                  isOfferActionInProgress,
                ),

                const SizedBox(height: AppSpacing.xl),

                if (request.status == 'pending_review') ...[
                  Row(
                    children: [
                      Expanded(
                        child: AppButton(
                          label: AppStrings.confirmCompletion,
                          onPressed: isOfferActionInProgress
                              ? null
                              : () {
                                  context
                                      .read<RequestDetailsCubit>()
                                      .confirmCompletion(
                                        request.id,
                                        request.clientId,
                                      );
                                },
                          fullWidth: true,
                          isLoading: isOfferActionInProgress,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: AppButton(
                          label: AppStrings.rejectCompletion,
                          onPressed: isOfferActionInProgress
                              ? null
                              : () => _showRejectCompletionDialog(
                                  context,
                                  request.id,
                                  request.clientId,
                                ),
                          variant: AppButtonVariant.outlined,
                          fullWidth: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                ],

                AppButton(
                  label: 'تعديل',
                  onPressed: null,
                  icon: Icons.edit,
                  fullWidth: true,
                ),
                const SizedBox(height: AppSpacing.sm),

                if (request.status != 'completed' &&
                    request.status != 'closed') ...[
                  AppButton(
                    label: AppStrings.closeRequest,
                    onPressed: isOfferActionInProgress
                        ? null
                        : () => _showCloseConfirmation(
                            context,
                            request.id,
                            request.clientId,
                          ),
                    variant: AppButtonVariant.outlined,
                    icon: Icons.lock,
                    fullWidth: true,
                  ),
                ],
              ],
            ),
          ),
          if (isOfferActionInProgress)
            Container(
              color: Colors.black26,
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }

  Widget _buildOffersSection(
    BuildContext context,
    ServiceRequest request,
    List<Offer> offers,
    bool isOfferActionInProgress,
  ) {
    final canShowOffers = [
      'open',
      'negotiating',
      'assigned',
    ].contains(request.status);
    final canManageOffers = ['open', 'negotiating'].contains(request.status);

    if (!canShowOffers) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        const SizedBox(height: AppSpacing.xl),
        OffersSection(
          offers: offers,
          canManageOffers: canManageOffers,
          requestId: request.id,
          onAccept: (offerId) {
            context.read<RequestDetailsCubit>().acceptOfferAction(
              offerId,
              request.id,
              request.clientId,
            );
          },
          onDecline: (offerId) {
            context.read<RequestDetailsCubit>().declineOfferAction(
              offerId,
              request.id,
            );
          },
          onCounter: (offerId, newAmount, note) {
            context.read<RequestDetailsCubit>().counterOfferAction(
              offerId: offerId,
              requestId: request.id,
              newAmount: newAmount,
              note: note,
            );
          },
        ),
      ],
    );
  }

  Future<void> _maybeShowRatingDialog(
    BuildContext context,
    ServiceRequest request,
  ) async {
    if (_handledRatingRequestId == request.id) return;

    final shouldShowDialog =
        request.status == 'completed' &&
        request.assignedProfessionalId != null &&
        !_dialogOpen;

    if (!shouldShowDialog) return;

    final ratingCubit = context.read<RatingCubit>();
    await ratingCubit.checkExistingRating(
      professionalId: request.assignedProfessionalId!,
      requestId: request.id,
      clientId: request.clientId,
    );

    if (ratingCubit.state.hasExistingRating) {
      _handledRatingRequestId = request.id;
      return;
    }

    _handledRatingRequestId = request.id;

    _dialogOpen = true;
    if (!context.mounted) return;
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => BlocProvider(
        create: (_) => sl<RatingCubit>(),
        child: RatingDialog(
          requestId: request.id,
          professionalId: request.assignedProfessionalId!,
          clientId: request.clientId,
        ),
      ),
    );
    _dialogOpen = false;

    if (result == true && request.assignedProfessionalId != null) {}
  }

  Widget _buildStatusChip(BuildContext context, String status) {
    final (label, color) = _getStatusInfo(status);

    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
          border: Border.all(color: color, width: 2),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.primary),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                value,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
                softWrap: true,
                overflow: TextOverflow.visible,
              ),
            ],
          ),
        ),
      ],
    );
  }

  (String, Color) _getStatusInfo(String status) {
    return switch (status) {
      'open' => (AppStrings.statusOpen, AppColors.info),
      'negotiating' => (AppStrings.statusNegotiating, AppColors.warning),
      'assigned' => (AppStrings.statusAssigned, AppColors.primaryPurple),
      'pending_review' => (AppStrings.statusPendingReview, AppColors.warning),
      'completed' => (AppStrings.statusCompleted, AppColors.success),
      'done' => (AppStrings.statusDone, AppColors.success),
      'canceled' => (AppStrings.statusCanceled, AppColors.error),
      _ => (status, AppColors.neutral500),
    };
  }

  void _showRejectCompletionDialog(
    BuildContext context,
    String requestId,
    String clientId,
  ) {
    final reasonController = TextEditingController();

    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(AppStrings.rejectCompletion),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(AppStrings.rejectCompletionMessage),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: reasonController,
              decoration: InputDecoration(
                labelText: AppStrings.rejectCompletionReason,
                hintText: AppStrings.rejectCompletionReasonHint,
                border: const OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<RequestDetailsCubit>().rejectCompletion(
                requestId,
                clientId,
                reason: reasonController.text.isNotEmpty
                    ? reasonController.text
                    : null,
              );
            },
            child: Text(AppStrings.rejectCompletion),
          ),
        ],
      ),
    ).then((_) => reasonController.dispose());
  }

  void _showCloseConfirmation(
    BuildContext context,
    String requestId,
    String clientId,
  ) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(AppStrings.closeRequest),
        content: const Text(
          'هل أنت متأكد من إغلاق هذا الطلب؟ لن تتمكن من إعادة فتحه بعد ذلك.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<RequestDetailsCubit>().closeRequestAction(
                requestId,
                clientId,
              );
            },
            child: Text(AppStrings.closeRequest),
          ),
        ],
      ),
    );
  }

  String _getCategoryLabel(String category) {
    return switch (category) {
      'plumbing' => 'سباكة',
      'electrical' => 'كهرباء',
      'carpentry' => 'نجارة',
      'painting' => 'دهان',
      'cleaning' => 'تنظيف',
      _ => category,
    };
  }

  Widget _buildProfessionalInfoCard(
    BuildContext context,
    ServiceRequest request,
  ) {
    final theme = Theme.of(context);
    return AppCard(
      child: InkWell(
        onTap: () {
          if (request.assignedProfessionalId != null) {
            context.push('/professionals/${request.assignedProfessionalId}');
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.person_outline,
                    color: theme.colorScheme.primary,
                    size: 24,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    'الصنايعي المكلف',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              const Divider(),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'اضغط لعرض الملف الشخصي للصنايعي',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompletionDetailsCard(
    BuildContext context,
    ServiceRequest request,
  ) {
    final theme = Theme.of(context);
    final dateFormatter = DateFormat('dd/MM/yyyy - HH:mm', 'ar');

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.check_circle,
                  color: AppColors.success,
                  size: 28,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'تم إنجاز الطلب',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.success,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      dateFormatter.format(request.completedAt!),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.6,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    widget.isClientView
                        ? 'شكراً لك! تم إكمال هذا الطلب بنجاح'
                        : 'تم إكمال هذا الطلب. أحسنت!',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRejectionNotice(BuildContext context, ServiceRequest request) {
    final theme = Theme.of(context);
    return AppCard(
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          border: Border.all(color: Colors.red.shade300, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.cancel_rounded,
                  color: Colors.red.shade700,
                  size: 28,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    'تم رفض الإنجاز',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.red.shade900,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'سبب الرفض:',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.red.shade800,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    request.rejectionReason!,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: Colors.red.shade900,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              width: double.infinity,
              child: AppButton(
                label: 'تبليغ الادمن',
                onPressed: () {
                  // TODO: need to implement admin reporting system
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('سيتم تطوير هذه الميزة فيما بعد'),
                      backgroundColor: Colors.blue,
                    ),
                  );
                },
                icon: Icons.flag_rounded,
                variant: AppButtonVariant.outlined,
                fullWidth: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
