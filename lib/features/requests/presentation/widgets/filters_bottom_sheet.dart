import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../core/config/app_spacing.dart';
import '../../../../core/constants/specializations.dart';
import '../../domain/entities/filter_criteria.dart';
import '../../domain/entities/sort_by.dart';

class FiltersBottomSheet extends StatefulWidget {
  final FilterCriteria initialCriteria;
  final Function(FilterCriteria) onApply;
  final VoidCallback onClear;

  const FiltersBottomSheet({
    required this.initialCriteria,
    required this.onApply,
    required this.onClear,
    super.key,
  });

  @override
  State<FiltersBottomSheet> createState() => _FiltersBottomSheetState();
}

class _FiltersBottomSheetState extends State<FiltersBottomSheet> {
  late List<String> _selectedCategories;
  late TextEditingController _budgetMinController;
  late TextEditingController _budgetMaxController;
  late double? _distanceKm;
  late bool _useDistance;
  late SortBy _sortBy;
  bool _isLoadingLocation = false;

  @override
  void initState() {
    super.initState();
    _selectedCategories = List.from(widget.initialCriteria.categories);
    _budgetMinController = TextEditingController(
      text: widget.initialCriteria.budgetMin?.toString() ?? '',
    );
    _budgetMaxController = TextEditingController(
      text: widget.initialCriteria.budgetMax?.toString() ?? '',
    );
    _distanceKm = widget.initialCriteria.distanceKm;
    _useDistance = widget.initialCriteria.distanceKm != null;
    _sortBy = widget.initialCriteria.sortBy;
  }

  @override
  void dispose() {
    _budgetMinController.dispose();
    _budgetMaxController.dispose();
    super.dispose();
  }

  Future<void> _requestLocationPermission() async {
    setState(() => _isLoadingLocation = true);

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('خدمات الموقع غير مفعلة'),
              backgroundColor: Colors.orange,
            ),
          );
          setState(() {
            _useDistance = false;
            _isLoadingLocation = false;
          });
        }
        return;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('تم رفض إذن الوصول للموقع'),
                backgroundColor: Colors.red,
              ),
            );
            setState(() {
              _useDistance = false;
              _isLoadingLocation = false;
            });
          }
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('تم رفض إذن الوصول للموقع بشكل دائم'),
              backgroundColor: Colors.red,
            ),
          );
          setState(() {
            _useDistance = false;
            _isLoadingLocation = false;
          });
        }
        return;
      }

      setState(() => _isLoadingLocation = false);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ في طلب إذن الموقع: $e'),
            backgroundColor: Colors.red,
          ),
        );
        setState(() {
          _useDistance = false;
          _isLoadingLocation = false;
        });
      }
    }
  }

  void _handleApply() {
    final budgetMin = _budgetMinController.text.trim().isEmpty
        ? null
        : double.tryParse(_budgetMinController.text.trim());

    final budgetMax = _budgetMaxController.text.trim().isEmpty
        ? null
        : double.tryParse(_budgetMaxController.text.trim());

    final criteria = FilterCriteria(
      categories: _selectedCategories,
      budgetMin: budgetMin,
      budgetMax: budgetMax,
      distanceKm: _useDistance ? _distanceKm : null,
      sortBy: _sortBy,
    );

    widget.onApply(criteria);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: AppSpacing.sm),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Text('فلترة النتائج', style: theme.textTheme.titleLarge),
              ),

              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                  ),
                  children: [
                    Text('الفئات', style: theme.textTheme.titleMedium),
                    const SizedBox(height: AppSpacing.sm),
                    Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.sm,
                      children: Specializations.all.map((spec) {
                        final isSelected = _selectedCategories.contains(spec);
                        return FilterChip(
                          key: ValueKey('filters_category_$spec'),
                          label: Text(spec),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                _selectedCategories.add(spec);
                              } else {
                                _selectedCategories.remove(spec);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    Text(
                      'الميزانية (شيكل)',
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            key: const ValueKey('filters_budget_min_field'),
                            controller: _budgetMinController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'من',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: TextField(
                            key: const ValueKey('filters_budget_max_field'),
                            controller: _budgetMaxController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'إلى',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    Row(
                      children: [
                        Text('المسافة', style: theme.textTheme.titleMedium),
                        const Spacer(),
                        if (_isLoadingLocation)
                          const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        else
                          Switch(
                            value: _useDistance,
                            onChanged: (value) async {
                              if (value) {
                                await _requestLocationPermission();
                                if (_useDistance) {
                                  setState(() {
                                    _distanceKm = 10.0; 
                                  });
                                }
                              } else {
                                setState(() {
                                  _useDistance = false;
                                  _distanceKm = null;
                                });
                              }
                            },
                          ),
                      ],
                    ),
                    if (_useDistance && _distanceKm != null) ...[
                      const SizedBox(height: AppSpacing.sm),
                      Row(
                        children: [
                          Expanded(
                            child: Slider(
                              value: _distanceKm!,
                              min: 5,
                              max: 50,
                              divisions: 9,
                              label: '${_distanceKm!.toInt()} كم',
                              onChanged: (value) {
                                setState(() {
                                  _distanceKm = value;
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            width: 60,
                            child: Text(
                              '${_distanceKm!.toInt()} كم',
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                    ],

                    const SizedBox(height: AppSpacing.lg),

                    Text('الترتيب', style: theme.textTheme.titleMedium),
                    const SizedBox(height: AppSpacing.sm),
                    RadioGroup<SortBy>(
                      groupValue: _sortBy,
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _sortBy = value;
                          });
                        }
                      },
                      child: Column(
                        children: [
                          ...SortBy.values.map((sort) {
                            return RadioListTile<SortBy>(
                              title: Text(sort.displayName),
                              value: sort,
                            );
                          }),
                        ],
                      ),
                    ),

                    const SizedBox(height: AppSpacing.xl),
                  ],
                ),
              ),

              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: theme.scaffoldBackgroundColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          widget.onClear();
                          Navigator.of(context).pop();
                        },
                        child: const Text('إعادة تعيين'),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('إلغاء'),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      flex: 2,
                      child: FilledButton(
                        key: const ValueKey('filters_apply_button'),
                        onPressed: _handleApply,
                        child: const Text('تطبيق'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
