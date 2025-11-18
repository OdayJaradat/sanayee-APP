import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/injection.dart';
import '../../../../core/config/app_spacing.dart';
import '../cubit/quick_request_cubit.dart';

class QuickRequestPage extends StatelessWidget {
  const QuickRequestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<QuickRequestCubit>(),
      child: const _QuickRequestView(),
    );
  }
}

class _QuickRequestView extends StatelessWidget {
  const _QuickRequestView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('طلب سريع ⚡')),
      body: BlocConsumer<QuickRequestCubit, QuickRequestState>(
        listener: (context, state) {
          if (state is QuickRequestSuccess) {
            context.go('/chats/${state.conversationId}');

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'تم إرسال الطلب السريع لـ ${state.professionalName} ✅',
                ),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 3),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is QuickRequestLoading) {
            return const _LoadingView();
          }

          if (state is QuickRequestError) {
            return _ErrorView(
              message: state.message,
              onRetry: () {
                context.read<QuickRequestCubit>().submitQuickRequest();
              },
            );
          }

          return const _InitialView();
        },
      ),
    );
  }
}

class _InitialView extends StatelessWidget {
  const _InitialView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Icon(Icons.flash_on, size: 100, color: theme.colorScheme.primary),
          const SizedBox(height: AppSpacing.lg),

          Text(
            'طلب سريع',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.md),

          Text(
            'سيتم تحديد موقعك تلقائياً والبحث عن أقرب صنايعي متاح وربطك به مباشرة عبر المحادثة',
            style: theme.textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xl),

          _FeatureItem(
            icon: Icons.location_on,
            title: 'تحديد الموقع',
            description: 'نستخدم GPS لتحديد موقعك الحالي',
          ),
          const SizedBox(height: AppSpacing.md),
          _FeatureItem(
            icon: Icons.search,
            title: 'البحث التلقائي',
            description: 'نبحث عن أقرب صنايعي متاح في منطقتك',
          ),
          const SizedBox(height: AppSpacing.md),
          _FeatureItem(
            icon: Icons.chat,
            title: 'الربط المباشر',
            description: 'نفتح لك المحادثة مباشرة مع الصنايعي',
          ),
          const SizedBox(height: AppSpacing.xxl),

          FilledButton.icon(
            onPressed: () {
              context.read<QuickRequestCubit>().submitQuickRequest();
            },
            icon: const Icon(Icons.flash_on),
            label: const Text('إرسال طلب سريع'),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
              textStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: theme.colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: theme.colorScheme.onSecondaryContainer,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    'ستحتاج إلى السماح بالوصول للموقع لاستخدام هذه الميزة',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSecondaryContainer,
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
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: theme.colorScheme.primary),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                description,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: AppSpacing.lg),
          Text('جارٍ معالجة طلبك...', style: theme.textTheme.titleLarge),
          const SizedBox(height: AppSpacing.md),
          Text(
            'نقوم بتحديد موقعك والبحث عن أقرب صنايعي',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPermissionError =
        message.contains('إذن') ||
        message.contains('الموقع') ||
        message.contains('خدمات');

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isPermissionError ? Icons.location_off : Icons.error_outline,
            size: 80,
            color: theme.colorScheme.error,
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'حدث خطأ',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            message,
            style: theme.textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xl),

          if (isPermissionError) ...[
            FilledButton.icon(
              onPressed: () async {
                final cubit = context.read<QuickRequestCubit>();
                final opened = await cubit.openAppSettings();
                if (context.mounted && !opened) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('تعذر فتح الإعدادات')),
                  );
                }
              },
              icon: const Icon(Icons.settings),
              label: const Text('فتح الإعدادات'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
          ],

          OutlinedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('إعادة المحاولة'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          TextButton(onPressed: () => context.pop(), child: const Text('رجوع')),
        ],
      ),
    );
  }
}
