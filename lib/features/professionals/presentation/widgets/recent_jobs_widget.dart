import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/injection.dart';
import '../../domain/repositories/professionals_repository.dart';
import '../../../../core/config/app_spacing.dart';
import 'package:intl/intl.dart' as intl;

class RecentJobsWidget extends StatelessWidget {
  final String professionalId;

  const RecentJobsWidget({super.key, required this.professionalId});

  @override
  Widget build(BuildContext context) {
    final professionalRepo = sl<ProfessionalsRepository>();

    return FutureBuilder(
      future: professionalRepo.fetchRecentJobs(professionalId, limit: 5),
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
                'فشل في تحميل الطلبات الأخيرة',
                style: TextStyle(color: Colors.red),
              ),
            ),
          );
        }

        return snapshot.data!.when(
          ok: (jobs) {
            if (jobs.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.md),
                  child: Text('لا يوجد طلبات مكتملة بعد'),
                ),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'الطلبات الأخيرة',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: AppSpacing.md),
                ...jobs.map((job) => _buildJobCard(context, job)),
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

  Widget _buildJobCard(BuildContext context, job) {
    final dateFormatter = intl.DateFormat('dd/MM/yyyy', 'ar');
    final completedDate = job.completedAt != null
        ? dateFormatter.format(job.completedAt!)
        : 'غير محدد';

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: InkWell(
        onTap: () {
          context.push(
            '/requests/${job.requestId}',
            extra: {'isClientView': false},
          );
        },
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundImage:
                    job.clientAvatar != null && job.clientAvatar!.isNotEmpty
                    ? NetworkImage(job.clientAvatar!)
                    : null,
                child: job.clientAvatar == null || job.clientAvatar!.isEmpty
                    ? const Icon(Icons.person)
                    : null,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      job.title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'العميل: ${job.clientName ?? 'غير محدد'}',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          size: 14,
                          color: Colors.green[700],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'مكتمل - $completedDate',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }
}
