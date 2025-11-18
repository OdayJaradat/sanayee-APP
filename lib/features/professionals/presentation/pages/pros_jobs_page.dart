import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/config/app_spacing.dart';
import '../../../../core/config/app_colors.dart';
import '../../../../core/constants/specializations.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/error_view.dart';
import '../../../../shared/widgets/shimmer_loading.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';
import '../../../requests/domain/entities/service_request.dart';
import '../../../requests/presentation/widgets/filters_bottom_sheet.dart';
import '../../../requests/presentation/widgets/active_filters_chips.dart';
import '../../domain/entities/offer.dart';
import '../cubit/pros_jobs_cubit.dart';
import '../cubit/my_offers_cubit.dart';
import '../cubit/active_jobs_cubit.dart';
import '../widgets/offer_dialog.dart';

class ProsJobsPage extends StatefulWidget {
  const ProsJobsPage({super.key});

  @override
  State<ProsJobsPage> createState() => _ProsJobsPageState();
}

class _ProsJobsPageState extends State<ProsJobsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);

    // reload data when switching tabs
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        final authState = context.read<AuthCubit>().state;
        if (authState.isAuthenticated && authState.userId != null) {
          final userId = authState.userId!;

          switch (_tabController.index) {
            case 0:
              context.read<ProsJobsCubit>().loadOpenRequests();
              break;
            case 1:
              context.read<MyOffersCubit>().loadMyOffers(userId);
              break;
            case 2:
              context.read<ActiveJobsCubit>().loadActiveJobs(userId);
              break;
            case 3:
              context.read<ActiveJobsCubit>().loadActiveJobs(userId);
              break;
          }
        }
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProsJobsCubit>().loadOpenRequests();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, authState) {
        if (authState.isAuthenticated && authState.isProfessional) {
          final userId = authState.userId;
          if (userId != null) {
            context.read<ProsJobsCubit>().loadOpenRequests();
            context.read<MyOffersCubit>().loadMyOffers(userId);
            context.read<ActiveJobsCubit>().loadActiveJobs(userId);
          }
        }
      },
      child: _ProsJobsView(tabController: _tabController),
    );
  }
}

class _ProsJobsView extends StatelessWidget {
  final TabController tabController;

  const _ProsJobsView({required this.tabController});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الوظائف'),
        bottom: TabBar(
          controller: tabController,
          tabs: const [
            Tab(text: 'متاحة', icon: Icon(Icons.work_outline, size: 20)),
            Tab(text: 'عروضي', icon: Icon(Icons.send_outlined, size: 20)),
            Tab(text: 'نشطة', icon: Icon(Icons.trending_up, size: 20)),
            Tab(
              text: 'مكتملة',
              icon: Icon(Icons.check_circle_outline, size: 20),
            ),
          ],
        ),
        actions: [
          IconButton(
            key: const ValueKey('pro_jobs_refresh_button'),
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<ProsJobsCubit>().loadOpenRequests(),
          ),
        ],
      ),
      body: TabBarView(
        controller: tabController,
        children: const [
          _AvailableJobsTab(),
          _MyOffersTab(),
          _ActiveJobsTab(),
          _CompletedJobsTab(),
        ],
      ),
    );
  }
}

class _AvailableJobsTab extends StatelessWidget {
  const _AvailableJobsTab();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: FilledButton.icon(
            key: const ValueKey('pro_jobs_filter_button'),
            onPressed: () {
              final cubit = context.read<ProsJobsCubit>();
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => FiltersBottomSheet(
                  initialCriteria: cubit.currentCriteria,
                  onApply: (criteria) {
                    cubit.applyFilters(criteria);
                  },
                  onClear: () {
                    cubit.clearAllFilters();
                  },
                ),
              );
            },
            icon: const Icon(Icons.filter_list, size: 20),
            label: const Text('تصفية'),
          ),
        ),
        Expanded(
          child: BlocConsumer<ProsJobsCubit, ProsJobsState>(
            listener: (context, state) {
              if (state.toString().contains('_OfferSubmitted')) {
                final professionalId = context.read<AuthCubit>().state.userId;
                if (professionalId != null) {
                  context.read<MyOffersCubit>().loadMyOffers(professionalId);
                }

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('تم إرسال العرض بنجاح'),
                    backgroundColor: Colors.green,
                  ),
                );
                context.read<ProsJobsCubit>().loadOpenRequests();
              } else if (state.toString().contains('_Error')) {
                final errorState = state as dynamic;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(errorState.message as String),
                    backgroundColor: Theme.of(context).colorScheme.error,
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state.toString().contains('_Loading')) {
                return const ShimmerList(itemCount: 6);
              }

              if (state.toString().contains('_Error')) {
                final errorState = state as dynamic;
                return ErrorView(
                  message: errorState.message as String,
                  onRetry: () =>
                      context.read<ProsJobsCubit>().loadOpenRequests(),
                );
              }

              if (state.toString().contains('_Loaded') ||
                  state.toString().contains('_Submitting')) {
                final loadedState = state as dynamic;
                final requests = loadedState.requests as List;
                final filterCriteria = loadedState.filterCriteria;

                if (requests.isEmpty) {
                  return Column(
                    children: [
                      if (filterCriteria != null)
                        ActiveFiltersChips(
                          criteria: filterCriteria,
                          onClear: () =>
                              context.read<ProsJobsCubit>().clearAllFilters(),
                        ),
                      const Expanded(
                        child: EmptyState(
                          icon: Icons.work_outline,
                          title: 'لا توجد وظائف متاحة',
                          message: 'لا توجد طلبات مفتوحة حالياً',
                        ),
                      ),
                    ],
                  );
                }

                return Column(
                  children: [
                    if (filterCriteria != null)
                      ActiveFiltersChips(
                        criteria: filterCriteria,
                        onClear: () =>
                            context.read<ProsJobsCubit>().clearAllFilters(),
                      ),
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () =>
                            context.read<ProsJobsCubit>().loadOpenRequests(),
                        child: ListView.separated(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          itemCount: requests.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: AppSpacing.md),
                          itemBuilder: (_, index) => _JobCard(
                            request: requests[index],
                            isSubmitting: state.toString().contains(
                              '_Submitting',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }
}

class _MyOffersTab extends StatefulWidget {
  const _MyOffersTab();

  @override
  State<_MyOffersTab> createState() => _MyOffersTabState();
}

class _MyOffersTabState extends State<_MyOffersTab> {
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final professionalId = context.read<AuthCubit>().state.userId;
      if (professionalId != null) {
        context.read<MyOffersCubit>().loadMyOffers(professionalId);

        _refreshTimer = Timer.periodic(const Duration(seconds: 5), (_) {
          if (mounted) {
            context.read<MyOffersCubit>().loadMyOffers(professionalId);
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final professionalId = context.watch<AuthCubit>().state.userId;

    if (professionalId == null) {
      return const Center(
        child: EmptyState(
          icon: Icons.person_off_outlined,
          title: 'غير مصرح',
          message: 'يجب تسجيل الدخول كصنايعي لعرض العروض',
        ),
      );
    }

    return BlocConsumer<MyOffersCubit, MyOffersState>(
      listener: (context, state) {
        if (state is MyOffersWithdrawn) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('تم سحب العرض بنجاح'),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is MyOffersError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is MyOffersLoading) {
          return const ShimmerList(itemCount: 4);
        }

        if (state is MyOffersError) {
          return ErrorView(
            message: state.message,
            onRetry: () =>
                context.read<MyOffersCubit>().loadMyOffers(professionalId),
          );
        }

        if (state is MyOffersLoaded) {
          final offers = state.offers;

          if (offers.isEmpty) {
            return const Center(
              child: EmptyState(
                icon: Icons.send_outlined,
                title: 'لا توجد عروض',
                message: 'لم ترسل أي عروض حتى الآن',
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<MyOffersCubit>().loadMyOffers(professionalId);
            },
            child: ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: offers.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: AppSpacing.md),
              itemBuilder: (_, index) => _OfferCard(
                offer: offers[index],
                onWithdraw: (state is MyOffersWithdrawing)
                    ? null
                    : () {
                        context.read<MyOffersCubit>().withdrawOffer(
                          offerId: offers[index].id,
                          professionalId: professionalId,
                        );
                      },
                onAcceptCounter: (state is MyOffersWithdrawing)
                    ? null
                    : () {
                        context.read<MyOffersCubit>().acceptCounterOffer(
                          offerId: offers[index].id,
                          professionalId: professionalId,
                        );
                      },
              ),
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}

class _ActiveJobsTab extends StatefulWidget {
  const _ActiveJobsTab();

  @override
  State<_ActiveJobsTab> createState() => _ActiveJobsTabState();
}

class _ActiveJobsTabState extends State<_ActiveJobsTab> {
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final professionalId = context.read<AuthCubit>().state.userId;
      if (professionalId != null) {
        context.read<ActiveJobsCubit>().loadActiveJobs(professionalId);

        _refreshTimer = Timer.periodic(const Duration(seconds: 5), (_) {
          if (mounted) {
            context.read<ActiveJobsCubit>().loadActiveJobs(professionalId);
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final professionalId = context.watch<AuthCubit>().state.userId;

    if (professionalId == null) {
      return const Center(
        child: EmptyState(
          icon: Icons.person_off_outlined,
          title: 'غير مصرح',
          message: 'يجب تسجيل الدخول كصنايعي لعرض الوظائف النشطة',
        ),
      );
    }

    return BlocConsumer<ActiveJobsCubit, ActiveJobsState>(
      listener: (context, state) {
        if (state is ActiveJobsMarked) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('تم إعلام العميل بإكمال المهمة'),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is ActiveJobsError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is ActiveJobsLoading) {
          return const ShimmerList(itemCount: 4);
        }

        if (state is ActiveJobsError) {
          return ErrorView(
            message: state.message,
            onRetry: () =>
                context.read<ActiveJobsCubit>().loadActiveJobs(professionalId),
          );
        }

        if (state is ActiveJobsLoaded) {
          final activeJobs = state.jobs
              .where(
                (job) =>
                    job.status == 'assigned' || job.status == 'pending_review',
              )
              .toList();

          if (activeJobs.isEmpty) {
            return const Center(
              child: EmptyState(
                icon: Icons.trending_up,
                title: 'لا توجد وظائف نشطة',
                message: 'لا توجد وظائف جارية حالياً',
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<ActiveJobsCubit>().loadActiveJobs(professionalId);
            },
            child: ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: activeJobs.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: AppSpacing.md),
              itemBuilder: (_, index) => _ActiveJobCard(
                request: activeJobs[index],
                onMarkReady: (state is ActiveJobsMarking)
                    ? null
                    : () {
                        context.read<ActiveJobsCubit>().markJobReady(
                          requestId: activeJobs[index].id,
                          professionalId: professionalId,
                        );
                      },
              ),
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}

class _JobCard extends StatelessWidget {
  final ServiceRequest request;
  final bool isSubmitting;

  const _JobCard({required this.request, required this.isSubmitting});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final professionalId = context.read<AuthCubit>().state.userId;
    final hasOfferForThisRequest =
        professionalId != null &&
        context.select<MyOffersCubit, bool>((cubit) {
          final state = cubit.state;
          if (state is MyOffersLoaded) {
            return state.offers.any(
              (offer) =>
                  offer.requestId == request.id &&
                  offer.status != 'withdrawn' &&
                  offer.status != 'declined',
            );
          }
          return false;
        });

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.surface,
            theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: hasOfferForThisRequest
              ? Colors.green.withValues(alpha: 0.5)
              : theme.colorScheme.outlineVariant,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: hasOfferForThisRequest
                ? Colors.green.withValues(alpha: 0.1)
                : theme.colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      theme.colorScheme.primaryContainer.withValues(alpha: 0.2),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          _getCategoryIcon(request.category),
                          size: 20,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          request.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (hasOfferForThisRequest)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.check_circle_rounded,
                                size: 14,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'تم الإرسال',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),

                  Container(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest
                          .withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      request.description,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.8,
                        ),
                        height: 1.5,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.xs,
                    children: [
                      _InfoChip(
                        icon: Icons.category_outlined,
                        label: _getCategoryLabel(request.category),
                        color: theme.colorScheme.tertiary,
                      ),
                      _InfoChip(
                        icon: Icons.info_outline_rounded,
                        label: _getStatusLabel(request.status),
                        color: _getStatusColor(request.status),
                      ),
                      if (request.location != null &&
                          request.location!.isNotEmpty)
                        _InfoChip(
                          icon: Icons.location_on_outlined,
                          label: _truncateLocation(request.location!),
                          color: theme.colorScheme.secondary,
                        ),
                      _InfoChip(
                        icon: Icons.schedule_rounded,
                        label: _formatDate(request.createdAt),
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.6,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),

                  if (request.budget != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.sm,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.green.shade400,
                            Colors.green.shade600,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.monetization_on_rounded,
                            size: 20,
                            color: Colors.white,
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          Text(
                            'الميزانية: ${request.budget!.toStringAsFixed(0)} ₪',
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: AppSpacing.md),

                  SizedBox(
                    width: double.infinity,
                    child: hasOfferForThisRequest
                        ? OutlinedButton.icon(
                            key: ValueKey('job_card_sent_button_${request.id}'),
                            onPressed: null,
                            icon: const Icon(Icons.check_circle, size: 18),
                            label: const Text('تم إرسال عرض'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.green,
                              side: const BorderSide(
                                color: Colors.green,
                                width: 2,
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: AppSpacing.md,
                              ),
                            ),
                          )
                        : FilledButton.icon(
                            key: ValueKey(
                              'job_card_send_offer_button_${request.id}',
                            ),
                            onPressed: isSubmitting
                                ? null
                                : () => _showOfferDialog(context, request),
                            icon: const Icon(Icons.send_rounded, size: 18),
                            label: const Text('إرسال عرض'),
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                vertical: AppSpacing.md,
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'plumbing':
        return Icons.plumbing_rounded;
      case 'electrical':
        return Icons.electrical_services_rounded;
      case 'carpentry':
        return Icons.construction_rounded;
      case 'painting':
        return Icons.format_paint_rounded;
      case 'cleaning':
        return Icons.cleaning_services_rounded;
      case 'gardening':
        return Icons.yard_rounded;
      case 'moving':
        return Icons.local_shipping_rounded;
      default:
        return Icons.handyman_rounded;
    }
  }

  String _getStatusLabel(String status) {
    switch (status) {
      case 'open':
        return 'مفتوح';
      case 'negotiating':
        return 'قيد التفاوض';
      case 'in_progress':
        return 'قيد التنفيذ';
      case 'completed':
        return 'مكتمل';
      case 'cancelled':
        return 'ملغي';
      default:
        return status;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'open':
        return Colors.blue;
      case 'negotiating':
        return Colors.orange;
      case 'in_progress':
        return Colors.purple;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getCategoryLabel(String category) {
    if (Specializations.all.contains(category)) {
      return category;
    }
    return category;
  }

  String _truncateLocation(String location) {
    final parts = location.split(',');
    if (parts.length > 2) {
      return '${parts[0]}, ${parts[1]}';
    }
    return location.length > 25 ? '${location.substring(0, 25)}...' : location;
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays == 0) {
      if (diff.inHours == 0) {
        return 'منذ ${diff.inMinutes} دقيقة';
      }
      return 'منذ ${diff.inHours} ساعة';
    } else if (diff.inDays == 1) {
      return 'منذ يوم';
    } else if (diff.inDays < 7) {
      return 'منذ ${diff.inDays} أيام';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  void _showOfferDialog(BuildContext context, ServiceRequest request) {
    showDialog(
      context: context,
      builder: (dialogContext) => OfferDialog(
        requestId: request.id,
        requestTitle: request.title,
        onSubmit: (amount, note) {
          Navigator.of(dialogContext).pop();
          context.read<ProsJobsCubit>().submitOffer(
            requestId: request.id,
            amount: amount,
            note: note,
          );
        },
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _OfferCard extends StatelessWidget {
  final Offer offer;
  final VoidCallback? onWithdraw;
  final VoidCallback? onAcceptCounter;

  const _OfferCard({
    required this.offer,
    this.onWithdraw,
    this.onAcceptCounter,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.surface,
            theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _getBorderColor(offer.status, theme),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: _getBorderColor(offer.status, theme).withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      _getBorderColor(
                        offer.status,
                        theme,
                      ).withValues(alpha: 0.15),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _ModernStatusBadge(status: offer.status),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: AppSpacing.sm,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.success.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.success.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.payments_rounded,
                              size: 20,
                              color: AppColors.success,
                            ),
                            const SizedBox(width: AppSpacing.xs),
                            Text(
                              '${offer.amount.toStringAsFixed(0)} ₪',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.success,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),

                  if (offer.note != null && offer.note!.isNotEmpty) ...[
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest
                            .withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.message_outlined,
                            size: 18,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Text(
                              offer.note!,
                              style: theme.textTheme.bodyMedium,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                  ],

                  Row(
                    children: [
                      Icon(
                        Icons.schedule_rounded,
                        size: 18,
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.6,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        _formatDate(offer.createdAt),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.7,
                          ),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                  if (offer.status == 'pending' && onWithdraw != null) ...[
                    const SizedBox(height: AppSpacing.md),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: onWithdraw,
                        icon: const Icon(Icons.cancel_outlined, size: 20),
                        label: const Text('سحب العرض'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: theme.colorScheme.error,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],

                  if (offer.status == 'countered') ...[
                    const SizedBox(height: AppSpacing.md),
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: Colors.orange.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.orange.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 20,
                            color: Colors.orange,
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Text(
                              'قام العميل بإرسال عرض مضاد بمبلغ ${offer.amount.toStringAsFixed(0)} ₪',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.orange.shade800,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: onWithdraw,
                            icon: const Icon(Icons.close, size: 20),
                            label: const Text('رفض'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: theme.colorScheme.error,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: onAcceptCounter,
                            icon: const Icon(Icons.check, size: 20),
                            label: const Text('قبول'),
                            style: FilledButton.styleFrom(
                              backgroundColor: AppColors.success,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getBorderColor(String status, ThemeData theme) {
    switch (status) {
      case 'accepted':
        return AppColors.success;
      case 'declined':
        return theme.colorScheme.error;
      case 'countered':
        return Colors.orange;
      case 'pending':
      default:
        return theme.colorScheme.primary;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return 'منذ ${difference.inDays} يوم';
    } else if (difference.inHours > 0) {
      return 'منذ ${difference.inHours} ساعة';
    } else if (difference.inMinutes > 0) {
      return 'منذ ${difference.inMinutes} دقيقة';
    } else {
      return 'الآن';
    }
  }
}

class _ModernStatusBadge extends StatelessWidget {
  final String status;

  const _ModernStatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusData = _getStatusData(status, theme);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: statusData['color'].withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: statusData['color'].withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(statusData['icon'], size: 18, color: statusData['color']),
          const SizedBox(width: AppSpacing.xs),
          Text(
            statusData['label'],
            style: theme.textTheme.labelLarge?.copyWith(
              color: statusData['color'],
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _getStatusData(String status, ThemeData theme) {
    switch (status) {
      case 'accepted':
        return {
          'label': 'مقبول',
          'color': AppColors.success,
          'icon': Icons.check_circle_rounded,
        };
      case 'declined':
        return {
          'label': 'مرفوض',
          'color': theme.colorScheme.error,
          'icon': Icons.cancel_rounded,
        };
      case 'countered':
        return {
          'label': 'عرض مضاد',
          'color': Colors.orange,
          'icon': Icons.sync_rounded,
        };
      case 'pending':
      default:
        return {
          'label': 'قيد الانتظار',
          'color': theme.colorScheme.primary,
          'icon': Icons.pending_rounded,
        };
    }
  }
}

class _ActiveJobCard extends StatelessWidget {
  final ServiceRequest request;
  final VoidCallback? onMarkReady;

  const _ActiveJobCard({required this.request, this.onMarkReady});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final isPendingReview = request.status == 'pending_review';

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.surface,
            theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isPendingReview
              ? Colors.orange.withValues(alpha: 0.5)
              : theme.colorScheme.primary.withValues(alpha: 0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: isPendingReview
                ? Colors.orange.withValues(alpha: 0.1)
                : theme.colorScheme.primary.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.work_rounded,
                          size: 20,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          request.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isPendingReview)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.pending_rounded,
                                size: 14,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'بانتظار التأكيد',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),

                  Container(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest
                          .withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      request.description,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.8,
                        ),
                        height: 1.5,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.xs,
                    children: [
                      _InfoChip(
                        icon: Icons.category_outlined,
                        label: _getCategoryLabel(request.category),
                        color: theme.colorScheme.tertiary,
                      ),
                      if (request.location != null &&
                          request.location!.isNotEmpty)
                        _InfoChip(
                          icon: Icons.location_on_outlined,
                          label: _truncateLocation(request.location!),
                          color: theme.colorScheme.secondary,
                        ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),

                  if (request.acceptedOfferAmount != null ||
                      request.budget != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.sm,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.green.shade400,
                            Colors.green.shade600,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.monetization_on_rounded,
                            size: 20,
                            color: Colors.white,
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          Text(
                            'المبلغ المتفق عليه: ${(request.acceptedOfferAmount ?? request.budget)!.toStringAsFixed(0)} ₪',
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: AppSpacing.md),

                  if (request.rejectionReason != null &&
                      request.rejectionReason!.isNotEmpty) ...[
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        border: Border.all(
                          color: Colors.red.shade300,
                          width: 2,
                        ),
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
                                size: 24,
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Expanded(
                                child: Text(
                                  'تم رفض الإنجاز من قبل العميل',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    color: Colors.red.shade900,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            'السبب: ${request.rejectionReason}',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.red.shade800,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          // TODO: need to implement admin reporting system
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('سيتم تطوير هذه الميزة فيما بعد'),
                              backgroundColor: Colors.blue,
                            ),
                          );
                        },
                        icon: const Icon(Icons.flag_rounded),
                        label: const Text('تبليغ الادمن'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red.shade700,
                          side: BorderSide(
                            color: Colors.red.shade700,
                            width: 2,
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: AppSpacing.md,
                          ),
                        ),
                      ),
                    ),
                  ] else
                    SizedBox(
                      width: double.infinity,
                      child: isPendingReview
                          ? OutlinedButton.icon(
                              onPressed: null,
                              icon: const Icon(Icons.hourglass_empty_rounded),
                              label: const Text('في انتظار تأكيد العميل'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.orange,
                                side: const BorderSide(
                                  color: Colors.orange,
                                  width: 2,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: AppSpacing.md,
                                ),
                              ),
                            )
                          : FilledButton.icon(
                              onPressed: onMarkReady == null
                                  ? null
                                  : () => _showCompletionDialog(context),
                              icon: const Icon(
                                Icons.task_alt_rounded,
                                size: 20,
                              ),
                              label: const Text('تعليم كمكتمل'),
                              style: FilledButton.styleFrom(
                                backgroundColor: Colors.green,
                                padding: const EdgeInsets.symmetric(
                                  vertical: AppSpacing.md,
                                ),
                              ),
                            ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getCategoryLabel(String category) {
    if (Specializations.all.contains(category)) {
      return category;
    }

    return category;
  }

  String _truncateLocation(String location) {
    final parts = location.split(',');
    if (parts.length > 2) {
      return '${parts[0]}, ${parts[1]}';
    }
    return location.length > 30 ? '${location.substring(0, 30)}...' : location;
  }

  void _showCompletionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => _JobCompletionDialog(
        requestId: request.id,
        requestTitle: request.title,
        onConfirm: () {
          if (onMarkReady != null) {
            onMarkReady!();
          }
        },
      ),
    );
  }
}

class _JobCompletionDialog extends StatefulWidget {
  final String requestId;
  final String requestTitle;
  final VoidCallback onConfirm;

  const _JobCompletionDialog({
    required this.requestId,
    required this.requestTitle,
    required this.onConfirm,
  });

  @override
  State<_JobCompletionDialog> createState() => _JobCompletionDialogState();
}

class _JobCompletionDialogState extends State<_JobCompletionDialog> {
  final List<XFile> _selectedPhotos = [];
  final _notesController = TextEditingController();
  final _imagePicker = ImagePicker();
  bool _isLoading = false;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final pickedFiles = await _imagePicker.pickMultiImage(
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (pickedFiles.isNotEmpty) {
        setState(() {
          _selectedPhotos.addAll(pickedFiles);

          if (_selectedPhotos.length > 5) {
            _selectedPhotos.removeRange(5, _selectedPhotos.length);
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('يمكنك إضافة حد أقصى 5 صور'),
                  duration: Duration(seconds: 2),
                ),
              );
            }
          }
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ في اختيار الصور: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _removePhoto(int index) {
    setState(() {
      _selectedPhotos.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.task_alt_rounded, color: theme.colorScheme.primary),
          const SizedBox(width: AppSpacing.sm),
          const Expanded(child: Text('إكمال المهمة')),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.requestTitle,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            Text(
              'صور المهمة المكتملة',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),

            if (_selectedPhotos.isNotEmpty)
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  for (int i = 0; i < _selectedPhotos.length; i++)
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            File(_selectedPhotos[i].path),
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: -4,
                          right: -4,
                          child: IconButton(
                            icon: const Icon(Icons.cancel, color: Colors.red),
                            iconSize: 20,
                            onPressed: () => _removePhoto(i),
                          ),
                        ),
                      ],
                    ),
                ],
              ),

            const SizedBox(height: AppSpacing.sm),

            OutlinedButton.icon(
              onPressed: _selectedPhotos.length < 5 ? _pickImage : null,
              icon: const Icon(Icons.add_photo_alternate_outlined),
              label: Text(
                _selectedPhotos.isEmpty
                    ? 'إضافة صور من المعرض (اختياري)'
                    : 'إضافة المزيد (${_selectedPhotos.length}/5)',
              ),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 40),
              ),
            ),

            const SizedBox(height: AppSpacing.md),

            Text(
              'ملاحظات (اختياري)',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: _notesController,
              decoration: InputDecoration(
                hintText: 'أضف ملاحظات حول إكمال المهمة...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
              ),
              maxLines: 3,
            ),

            const SizedBox(height: AppSpacing.sm),

            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withValues(
                  alpha: 0.3,
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.primary.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    size: 20,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      'سيتم إعلام العميل بإكمال المهمة وسيتمكن من التأكيد والتقييم',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.7,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('إلغاء'),
        ),
        FilledButton.icon(
          onPressed: _isLoading
              ? null
              : () {
                  setState(() => _isLoading = true);
                  widget.onConfirm();
                  Navigator.of(context).pop();
                },
          icon: _isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.check_circle_rounded),
          label: const Text('تأكيد الإكمال'),
        ),
      ],
    );
  }
}

class _CompletedJobsTab extends StatefulWidget {
  const _CompletedJobsTab();

  @override
  State<_CompletedJobsTab> createState() => _CompletedJobsTabState();
}

class _CompletedJobsTabState extends State<_CompletedJobsTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final professionalId = context.read<AuthCubit>().state.userId;
      if (professionalId != null) {
        context.read<ActiveJobsCubit>().loadActiveJobs(professionalId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final professionalId = context.watch<AuthCubit>().state.userId;

    if (professionalId == null) {
      return const Center(
        child: EmptyState(
          icon: Icons.person_off_outlined,
          title: 'غير مصرح',
          message: 'يجب تسجيل الدخول كصنايعي لعرض المهام المكتملة',
        ),
      );
    }

    return BlocBuilder<ActiveJobsCubit, ActiveJobsState>(
      builder: (context, state) {
        if (state is ActiveJobsLoading) {
          return const ShimmerList(itemCount: 4);
        }

        if (state is ActiveJobsError) {
          return ErrorView(
            message: state.message,
            onRetry: () =>
                context.read<ActiveJobsCubit>().loadActiveJobs(professionalId),
          );
        }

        if (state is ActiveJobsLoaded) {
          final completedJobs = state.jobs
              .where((job) => job.status == 'completed')
              .toList();

          if (completedJobs.isEmpty) {
            return const Center(
              child: EmptyState(
                icon: Icons.check_circle_outline,
                title: 'لا توجد مهام مكتملة',
                message: 'المهام المكتملة ستظهر هنا',
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<ActiveJobsCubit>().loadActiveJobs(professionalId);
            },
            child: ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: completedJobs.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: AppSpacing.md),
              itemBuilder: (_, index) =>
                  _CompletedJobCard(request: completedJobs[index]),
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}

class _CompletedJobCard extends StatelessWidget {
  final ServiceRequest request;

  const _CompletedJobCard({required this.request});

  String _getCategoryLabel(String category) {
    final categoryMap = {
      'plumbing': 'سباكة',
      'electrical': 'كهرباء',
      'carpentry': 'نجارة',
      'painting': 'دهان',
      'cleaning': 'تنظيف',
      'masonry': 'بناء',
      'tiling': 'بلاط',
    };
    return categoryMap[category] ?? category;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.green.withValues(alpha: 0.1),
            theme.colorScheme.surface,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.green.withValues(alpha: 0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Stack(
          children: [
            Positioned(
              top: 12,
              right: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.check_circle,
                      size: 16,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'مكتملة',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 32),
                  Text(
                    request.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.category_outlined,
                          size: 16,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _getCategoryLabel(request.category),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  Text(
                    request.description,
                    style: theme.textTheme.bodyMedium,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.md),

                  if (request.budget != null) ...[
                    Row(
                      children: [
                        Icon(
                          Icons.attach_money,
                          size: 20,
                          color: Colors.green.shade700,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'الميزانية: ${request.budget!.toStringAsFixed(0)} ₪',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.green.shade700,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                  ],

                  if (request.completedAt != null) ...[
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 16,
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.6,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'أكملت في: ${_formatDate(request.completedAt!)}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.6,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'اليوم';
    } else if (difference.inDays == 1) {
      return 'أمس';
    } else if (difference.inDays < 7) {
      return 'منذ ${difference.inDays} أيام';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return 'منذ $weeks ${weeks == 1 ? 'أسبوع' : 'أسابيع'}';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
