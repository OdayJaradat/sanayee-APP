import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/config/app_spacing.dart';


class LocationSelector extends StatefulWidget {
  final String? initialGovernorate;
  final String? initialLocality;
  final ValueChanged<String?>? onGovernorateChanged;
  final ValueChanged<String?>? onLocalityChanged;
  final String? governorateError;
  final String? localityError;

  const LocationSelector({
    super.key,
    this.initialGovernorate,
    this.initialLocality,
    this.onGovernorateChanged,
    this.onLocalityChanged,
    this.governorateError,
    this.localityError,
  });

  @override
  State<LocationSelector> createState() => _LocationSelectorState();
}

class _LocationSelectorState extends State<LocationSelector> {
  Map<String, List<String>> _localities = {};
  bool _isLoading = true;
  String? _selectedGovernorate;
  String? _selectedLocality;

  @override
  void initState() {
    super.initState();
    _selectedGovernorate = widget.initialGovernorate;
    _selectedLocality = widget.initialLocality;
    _loadLocalities();
  }

  Future<void> _loadLocalities() async {
    try {
      final String jsonString = await rootBundle.loadString(
        'assets/data/west_bank_localities_ar.json',
      );
      final Map<String, dynamic> jsonData = json.decode(jsonString);

      setState(() {
        _localities = jsonData.map(
          (key, value) => MapEntry(key, List<String>.from(value)),
        );
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final governorates = _localities.keys.toList()..sort();
    final localities = _selectedGovernorate != null
        ? _localities[_selectedGovernorate!] ?? []
        : <String>[];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<String>(
          initialValue: _selectedGovernorate,
          decoration: InputDecoration(
            labelText: 'المحافظة',
            prefixIcon: const Icon(Icons.location_city_rounded),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
            errorText: widget.governorateError,
            filled: true,
            fillColor: theme.colorScheme.surfaceContainerHighest.withValues(
              alpha: 0.3,
            ),
          ),
          hint: const Text('اختر المحافظة'),
          isExpanded: true,
          items: governorates.map((governorate) {
            return DropdownMenuItem<String>(
              value: governorate,
              child: Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 20,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(governorate),
                ],
              ),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedGovernorate = value;
              _selectedLocality =
                  null; 
            });
            widget.onGovernorateChanged?.call(value);
            widget.onLocalityChanged?.call(null);
          },
        ),
        const SizedBox(height: AppSpacing.md),

        if (_selectedGovernorate != null) ...[
          DropdownButtonFormField<String>(
            initialValue: _selectedLocality,
            decoration: InputDecoration(
              labelText: 'المنطقة/البلدة',
              prefixIcon: const Icon(Icons.place_rounded),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              errorText: widget.localityError,
              filled: true,
              fillColor: theme.colorScheme.surfaceContainerHighest.withValues(
                alpha: 0.3,
              ),
            ),
            hint: const Text('اختر المنطقة'),
            isExpanded: true,
            items: localities.map((locality) {
              return DropdownMenuItem<String>(
                value: locality,
                child: Row(
                  children: [
                    Icon(
                      Icons.home_work_rounded,
                      size: 18,
                      color: theme.colorScheme.secondary,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(locality),
                  ],
                ),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedLocality = value;
              });
              widget.onLocalityChanged?.call(value);
            },
          ),
        ],
      ],
    );
  }
}
