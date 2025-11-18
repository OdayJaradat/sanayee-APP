import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/config/app_spacing.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text_field.dart';

class OfferDialog extends StatefulWidget {
  final String requestId;
  final String requestTitle;
  final Function(double amount, String? note) onSubmit;

  const OfferDialog({
    required this.requestId,
    required this.requestTitle,
    required this.onSubmit,
    super.key,
  });

  @override
  State<OfferDialog> createState() => _OfferDialogState();
}

class _OfferDialogState extends State<OfferDialog> {
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  String? _amountError;

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  bool _validate() {
    if (_amountController.text.trim().isEmpty) {
      setState(() => _amountError = AppStrings.amountRequired);
      return false;
    }

    final amount = double.tryParse(_amountController.text.trim());
    if (amount == null || amount <= 0) {
      setState(() => _amountError = AppStrings.budgetInvalid);
      return false;
    }

    setState(() => _amountError = null);
    return true;
  }

  void _submit() {
    if (!_validate()) return;

    final amount = double.parse(_amountController.text.trim());
    final note = _noteController.text.trim().isEmpty
        ? null
        : _noteController.text.trim();

    widget.onSubmit(amount, note);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              AppStrings.sendOffer,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              widget.requestTitle,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppSpacing.lg),

            AppTextField(
              key: const ValueKey('offer_dialog_amount_field'),
              controller: _amountController,
              label: AppStrings.amountLabel,
              hint: AppStrings.amountHint,
              errorText: _amountError,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
              suffixText: AppStrings.currency,
              onChanged: (_) {
                if (_amountError != null) {
                  setState(() => _amountError = null);
                }
              },
            ),
            const SizedBox(height: AppSpacing.md),

            AppTextField(
              key: const ValueKey('offer_dialog_note_field'),
              controller: _noteController,
              label: AppStrings.noteLabel,
              hint: AppStrings.noteHint,
              maxLines: 3,
              minLines: 2,
            ),
            const SizedBox(height: AppSpacing.xl),

            Row(
              children: [
                Expanded(
                  child: AppButton(
                    label: AppStrings.cancel,
                    onPressed: () => Navigator.of(context).pop(),
                    variant: AppButtonVariant.outlined,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: AppButton(
                    key: const ValueKey('offer_dialog_submit_button'),
                    label: AppStrings.sendOffer,
                    onPressed: _submit,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
