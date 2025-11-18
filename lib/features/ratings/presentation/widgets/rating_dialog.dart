import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../../../core/config/app_spacing.dart';
import '../../../../core/constants/app_strings.dart';
import '../../domain/entities/rating.dart';
import '../cubit/rating_cubit.dart';

class RatingDialog extends StatefulWidget {
  const RatingDialog({
    required this.requestId,
    required this.clientId,
    required this.professionalId,
    super.key,
  });

  final String requestId;
  final String clientId;
  final String professionalId;

  @override
  State<RatingDialog> createState() => _RatingDialogState();
}

class _RatingDialogState extends State<RatingDialog> {
  double _selectedRating = 0;
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocConsumer<RatingCubit, RatingState>(
      listenWhen: (previous, current) =>
          previous.submissionSuccess != current.submissionSuccess ||
          previous.errorMessage != current.errorMessage,
      listener: (context, state) {
        if (state.submissionSuccess) {
          Navigator.of(context).pop(true);
        } else if (state.errorMessage != null && !state.isSubmitting) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
        }
      },
      builder: (context, state) {
        final isSubmitting = state.isSubmitting;

        return AlertDialog(
          title: Text(AppStrings.ratingDialogTitle),
          content: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  AppStrings.ratingDialogSubtitle,
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: AppSpacing.md),
                _buildRatingStars(theme),
                const SizedBox(height: AppSpacing.md),
                TextField(
                  controller: _commentController,
                  minLines: 3,
                  maxLines: 5,
                  textInputAction: TextInputAction.newline,
                  decoration: InputDecoration(
                    labelText: AppStrings.ratingCommentLabel,
                    hintText: AppStrings.ratingCommentHint,
                    border: const OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: isSubmitting
                  ? null
                  : () => Navigator.of(context).pop(),
              child: const Text(AppStrings.cancel),
            ),
            FilledButton(
              onPressed: (_selectedRating == 0 || isSubmitting)
                  ? null
                  : () => _onSubmit(context),
              child: isSubmitting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text(AppStrings.ratingSubmitLabel),
            ),
          ],
        );
      },
    );
  }

  Widget _buildRatingStars(ThemeData theme) {
    return Center(
      child: RatingBar.builder(
        initialRating: _selectedRating,
        minRating: 1,
        direction: Axis.horizontal,
        allowHalfRating: false,
        itemCount: 5,
        itemSize: 40,
        itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
        itemBuilder: (context, _) =>
            const Icon(Icons.star, color: Colors.amber),
        onRatingUpdate: (rating) {
          setState(() {
            _selectedRating = rating;
          });
        },
        glow: true,
        glowColor: Colors.amber.withValues(alpha: 0.5),
        unratedColor: theme.colorScheme.outline.withValues(alpha: 0.3),
      ),
    );
  }

  void _onSubmit(BuildContext context) {
    final cubit = context.read<RatingCubit>();
    final comment = _commentController.text.trim().isEmpty
        ? null
        : _commentController.text.trim();

    final rating = Rating(
      id: '',
      requestId: widget.requestId,
      clientId: widget.clientId,
      professionalId: widget.professionalId,
      rating: _selectedRating.toInt(),
      comment: comment,
      createdAt: DateTime.now(),
    );

    cubit.submitRating(rating);
  }
}
