import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/app_colors.dart';
import '../config/app_spacing.dart';

/// Dialog for submitting a report to admin
class ReportDialog extends StatefulWidget {
  final String targetType; // 'request', 'professional', 'client', 'offer'
  final String targetId;
  final String? targetLabel; // Optional label for display (e.g., "الطلب #123")

  const ReportDialog({
    super.key,
    required this.targetType,
    required this.targetId,
    this.targetLabel,
  });

  /// Check if the current user has already reported this target
  /// Returns true if a report exists, false otherwise
  static Future<bool> hasUserReported({
    required String targetType,
    required String targetId,
  }) async {
    try {
      final supabase = Supabase.instance.client;
      final currentUser = supabase.auth.currentUser;

      if (currentUser == null) return false;

      final response = await supabase
          .from('reports')
          .select('id')
          .eq('target_type', targetType)
          .eq('target_id', targetId)
          .eq('created_by', currentUser.id)
          .limit(1)
          .maybeSingle();

      return response != null;
    } catch (e) {
      // If reports table doesn't exist or other error, assume not reported
      return false;
    }
  }

  /// Show the report dialog and return true if report was submitted successfully
  static Future<bool> show(
    BuildContext context, {
    required String targetType,
    required String targetId,
    String? targetLabel,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => ReportDialog(
        targetType: targetType,
        targetId: targetId,
        targetLabel: targetLabel,
      ),
    );
    return result ?? false;
  }

  @override
  State<ReportDialog> createState() => _ReportDialogState();
}

class _ReportDialogState extends State<ReportDialog> {
  final _formKey = GlobalKey<FormState>();
  final _reasonController = TextEditingController();
  final _detailsController = TextEditingController();
  bool _isSubmitting = false;
  String? _errorMessage;

  @override
  void dispose() {
    _reasonController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  String get _targetTypeLabel {
    switch (widget.targetType) {
      case 'request':
        return 'طلب';
      case 'professional':
        return 'صنايعي';
      case 'client':
        return 'عميل';
      case 'offer':
        return 'عرض';
      default:
        return widget.targetType;
    }
  }

  Future<void> _submitReport() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    try {
      final supabase = Supabase.instance.client;
      final currentUser = supabase.auth.currentUser;

      if (currentUser == null) {
        throw Exception('يجب تسجيل الدخول أولاً');
      }

      await supabase.from('reports').insert({
        'target_type': widget.targetType,
        'target_id': widget.targetId,
        'reason': _reasonController.text.trim(),
        'details': _detailsController.text.trim().isEmpty
            ? null
            : _detailsController.text.trim(),
        'created_by': currentUser.id,
        'status': 'open',
        'created_at': DateTime.now().toIso8601String(),
      });

      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } on PostgrestException catch (e) {
      setState(() {
        _errorMessage = 'فشل في إرسال البلاغ: ${e.message}';
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'حدث خطأ: ${e.toString()}';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.flag_rounded, color: Colors.red.shade700),
          const SizedBox(width: AppSpacing.sm),
          Text(
            'تبليغ الإدارة',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.4,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Info text
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue.shade700, size: 20),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        'تبليغ عن ${widget.targetLabel ?? _targetTypeLabel}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Reason field
              TextFormField(
                controller: _reasonController,
                decoration: InputDecoration(
                  labelText: 'سبب البلاغ *',
                  hintText: 'اكتب سبب البلاغ بشكل مختصر',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                ),
                maxLength: 100,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'الرجاء إدخال سبب البلاغ';
                  }
                  if (value.trim().length < 5) {
                    return 'السبب قصير جداً';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.md),

              // Details field
              TextFormField(
                controller: _detailsController,
                decoration: InputDecoration(
                  labelText: 'التفاصيل (اختياري)',
                  hintText: 'أضف تفاصيل إضافية إذا لزم الأمر',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                  alignLabelWithHint: true,
                ),
                maxLines: 4,
                maxLength: 500,
              ),

              // Error message
              if (_errorMessage != null) ...[
                const SizedBox(height: AppSpacing.md),
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: AppColors.error, size: 20),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppColors.error,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(false),
          child: const Text('إلغاء'),
        ),
        FilledButton.icon(
          onPressed: _isSubmitting ? null : _submitReport,
          icon: _isSubmitting
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : const Icon(Icons.send_rounded, size: 18),
          label: Text(_isSubmitting ? 'جاري الإرسال...' : 'إرسال البلاغ'),
          style: FilledButton.styleFrom(
            backgroundColor: Colors.red.shade700,
          ),
        ),
      ],
    );
  }
}
