import 'package:flutter/material.dart';
import '../../../../core/config/app_spacing.dart';
import '../../domain/entities/filter_criteria.dart';

class ActiveFiltersChips extends StatelessWidget {
  final FilterCriteria criteria;
  final VoidCallback onClear;

  const ActiveFiltersChips({
    required this.criteria,
    required this.onClear,
    super.key,
  });

  bool get _hasActiveFilters {
    return criteria.categories.isNotEmpty ||
        criteria.budgetMin != null ||
        criteria.budgetMax != null ||
        criteria.distanceKm != null;
  }

  List<Widget> _buildChips(BuildContext context) {
    final chips = <Widget>[];

    for (final category in criteria.categories) {
      final label = _getCategoryLabel(category);
      chips.add(
        Chip(
          label: Text(label, style: const TextStyle(fontSize: 12)),
          deleteIcon: const Icon(Icons.close, size: 16),
          onDeleted: () {}, 
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      );
    }

    if (criteria.budgetMin != null || criteria.budgetMax != null) {
      final budgetText = _getBudgetText();
      chips.add(
        Chip(
          label: Text(budgetText, style: const TextStyle(fontSize: 12)),
          deleteIcon: const Icon(Icons.close, size: 16),
          onDeleted: () {},
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      );
    }

    if (criteria.distanceKm != null) {
      chips.add(
        Chip(
          label: Text(
            'مسافة ≤ ${criteria.distanceKm!.toInt()} كم',
            style: const TextStyle(fontSize: 12),
          ),
          deleteIcon: const Icon(Icons.close, size: 16),
          onDeleted: () {},
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      );
    }

    if (chips.isNotEmpty) {
      chips.add(
        ActionChip(
          label: const Text('مسح الكل', style: TextStyle(fontSize: 12)),
          onPressed: onClear,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      );
    }

    return chips;
  }

  String _getCategoryLabel(String category) {
    const categories = {
      'plumbing': 'سباكة',
      'electrical': 'كهرباء',
      'painting': 'دهان',
      'carpentry': 'نجارة',
      'hvac': 'تكييف وتبريد',
      'other': 'أخرى',
    };
    return categories[category] ?? category;
  }

  String _getBudgetText() {
    if (criteria.budgetMin != null && criteria.budgetMax != null) {
      return 'ميزانية ${criteria.budgetMin!.toInt()}-${criteria.budgetMax!.toInt()}';
    } else if (criteria.budgetMin != null) {
      return 'ميزانية ≥ ${criteria.budgetMin!.toInt()}';
    } else if (criteria.budgetMax != null) {
      return 'ميزانية ≤ ${criteria.budgetMax!.toInt()}';
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasActiveFilters) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Wrap(
        spacing: AppSpacing.sm,
        runSpacing: AppSpacing.sm,
        children: _buildChips(context),
      ),
    );
  }
}
