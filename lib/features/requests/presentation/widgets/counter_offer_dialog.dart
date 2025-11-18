import 'package:flutter/material.dart';
import '../../../../core/constants/app_strings.dart';

class CounterOfferDialog extends StatefulWidget {
  final double currentAmount;
  final Function(double newAmount, String? note) onSubmit;

  const CounterOfferDialog({
    super.key,
    required this.currentAmount,
    required this.onSubmit,
  });

  @override
  State<CounterOfferDialog> createState() => _CounterOfferDialogState();
}

class _CounterOfferDialogState extends State<CounterOfferDialog> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _amountController.text = widget.currentAmount.toString();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      final newAmount = double.tryParse(_amountController.text);
      if (newAmount != null && newAmount > 0) {
        Navigator.of(context).pop();
        final note = _noteController.text.trim();
        widget.onSubmit(newAmount, note.isEmpty ? null : note);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(AppStrings.counterOfferTitle),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              key: const ValueKey('fld_counter_amount'),
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: AppStrings.newAmount,
                hintText: AppStrings.newAmountHint,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppStrings.newAmountRequired;
                }
                final amount = double.tryParse(value);
                if (amount == null || amount <= 0) {
                  return AppStrings.newAmountInvalid;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _noteController,
              keyboardType: TextInputType.text,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: AppStrings.counterOfferNote,
                hintText: AppStrings.counterOfferNoteHint,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(AppStrings.cancel),
        ),
        FilledButton(
          key: const ValueKey('btn_submit_counter'),
          onPressed: _handleSubmit,
          child: const Text(AppStrings.sendCounter),
        ),
      ],
    );
  }
}
