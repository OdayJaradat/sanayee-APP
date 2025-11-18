import 'package:flutter/material.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/specializations.dart';

class CategoryDropdown extends StatelessWidget {
  final String? value;
  final ValueChanged<String?> onChanged;
  final String? errorText;

  const CategoryDropdown({
    required this.value,
    required this.onChanged,
    this.errorText,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      decoration: InputDecoration(
        labelText: AppStrings.category,
        hintText: AppStrings.categoryHint,
        errorText: errorText,
      ),
      items: Specializations.all
          .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
          .toList(),
      onChanged: onChanged,
    );
  }
}
