import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/app_spacing.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/error_view.dart';
import '../../../../shared/widgets/shimmer_loading.dart';
import '../../domain/entities/service_request.dart';
import '../cubit/requests_cubit.dart';
import '../widgets/request_card.dart';

class RequestsListPage extends StatefulWidget {
  const RequestsListPage({super.key});

  @override
  State<RequestsListPage> createState() => _RequestsListPageState();
}

class _RequestsListPageState extends State<RequestsListPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _scheduleInitialLoad();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _scheduleInitialLoad() {
    // wait for widget tree to finish building before calling cubit
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<RequestsCubit>().loadRequests();
    });
  }

  @override
  Widget build(BuildContext context) {
    return _RequestsListView(
      tabController: _tabController,
      onReload: _scheduleInitialLoad,
    );
  }
}

class _RequestsListView extends StatelessWidget {
  const _RequestsListView({
    required this.tabController,
    required this.onReload,
  });

  final TabController tabController;
  final VoidCallback onReload;

  void _reloadRequests(BuildContext context) {
    context.read<RequestsCubit>().loadRequests();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.requestsTitle),
        actions: [
          IconButton(
            key: const ValueKey('client_requests_refresh_button'),
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<RequestsCubit>().refreshRequests(),
          ),
        ],
        bottom: TabBar(
          controller: tabController,
          tabs: const [
            Tab(text: AppStrings.activeRequests),
            Tab(text: AppStrings.completedRequests),
            Tab(text: AppStrings.closedRequests),
          ],
          labelColor: theme.colorScheme.primary,
          labelStyle: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelColor: theme.colorScheme.onSurface.withValues(
            alpha: 0.6,
          ),
          unselectedLabelStyle: theme.textTheme.titleSmall,
          indicatorColor: theme.colorScheme.primary,
        ),
      ),
      body: BlocBuilder<RequestsCubit, RequestsState>(
        builder: (context, state) {
          Widget visibleChild;

          if (state.isLoading) {
            visibleChild = const ShimmerList(itemCount: 6);
          } else if (state.hasError) {
            visibleChild = ErrorView(
              message: state.errorMessage ?? AppStrings.loadErrorMessage,
              onRetry: () => context.read<RequestsCubit>().loadRequests(),
            );
          } else if (state.dataOrNull != null) {
            visibleChild = _buildLoadedRequests(context, state.dataOrNull!);
          } else {
            visibleChild = const SizedBox.shrink();
          }

          // smooth transition between states
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            switchInCurve: Curves.easeOut,
            switchOutCurve: Curves.easeIn,
            child: KeyedSubtree(
              key: ValueKey(state.runtimeType),
              child: visibleChild,
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        key: const ValueKey('client_requests_add_fab'),
        onPressed: () async {
          final result = await context.push('/requests/create');
          if (result == true && context.mounted) {
            context.read<RequestsCubit>().loadRequests();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildLoadedRequests(
    BuildContext context,
    List<ServiceRequest> allRequests,
  ) {
    // separate requests by status for each tab
    final cubit = context.read<RequestsCubit>();
    final activeRequests = cubit.getActiveRequests(allRequests);
    final completedRequests = cubit.getCompletedRequests(allRequests);
    final closedRequests = cubit.getClosedRequests(allRequests);

    return TabBarView(
      controller: tabController,
      children: [
        _buildRequestsList(
          context,
          activeRequests,
          AppStrings.noActiveRequestsTitle,
          AppStrings.noActiveRequestsMessage,
        ),
        _buildRequestsList(
          context,
          completedRequests,
          AppStrings.noCompletedRequestsTitle,
          AppStrings.noCompletedRequestsMessage,
        ),
        _buildRequestsList(
          context,
          closedRequests,
          AppStrings.noClosedRequestsTitle,
          AppStrings.noClosedRequestsMessage,
        ),
      ],
    );
  }

  Widget _buildRequestsList(
    BuildContext context,
    List<ServiceRequest> requests,
    String emptyTitle,
    String emptyMessage,
  ) {
    if (requests.isEmpty) {
      return EmptyState(
        icon: Icons.inbox_outlined,
        title: emptyTitle,
        message: emptyMessage,
      );
    }

    final theme = Theme.of(context);

    return RefreshIndicator(
      onRefresh: () => context.read<RequestsCubit>().refreshRequests(),
      child: ListView.separated(
        padding: const EdgeInsetsDirectional.only(
          start: AppSpacing.md,
          end: AppSpacing.md,
          top: AppSpacing.md,
          bottom: AppSpacing.lg,
        ),
        itemCount: requests.length + 1,
        physics: const BouncingScrollPhysics(),
        separatorBuilder: (_, index) => index == 0
            ? const SizedBox(height: AppSpacing.sm)
            : const SizedBox(height: AppSpacing.md),
        itemBuilder: (_, index) {
          if (index == 0) {
            // simple counter showing number of requests
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
              child: Text(
                AppStrings.requestsCountLabel(requests.length),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          }

          final request = requests[index - 1];
          final isClosed =
              request.status == 'closed' || request.status == 'completed';

          return RequestCard(
            key: ValueKey('request_card_${request.id}'),
            request: request,
            onTap: () async {
              await context.push('/requests/${request.id}');
              if (context.mounted) {
                _reloadRequests(context);
              }
            },
            onDelete: isClosed
                ? null
                : () {
                    _showCloseDialog(context, request.id);
                  },
          );
        },
      ),
    );
  }

  void _showCloseDialog(BuildContext context, String requestId) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text(AppStrings.closeRequest),
        content: const Text(AppStrings.closeRequestMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text(AppStrings.cancel),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<RequestsCubit>().closeRequest(requestId);
            },
            child: const Text(AppStrings.closeRequest),
          ),
        ],
      ),
    );
  }
}
