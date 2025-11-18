import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../app/injection.dart';
import '../../../../core/config/app_spacing.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/specializations.dart';
import '../../../../shared/widgets/location_selector.dart';
import '../cubit/create_request_cubit.dart';

class CreateRequestPage extends StatelessWidget {
  const CreateRequestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<CreateRequestCubit>(),
      child: const _CreateRequestView(),
    );
  }
}

class _CreateRequestView extends StatefulWidget {
  const _CreateRequestView();

  @override
  State<_CreateRequestView> createState() => _CreateRequestViewState();
}

class _CreateRequestViewState extends State<_CreateRequestView> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _budgetController = TextEditingController();
  final _streetController = TextEditingController();
  final _imagePicker = ImagePicker();

  String _selectedCategory = 'طوبرجي';
  String? _selectedGovernorate;
  String? _selectedLocality;
  final List<XFile> _selectedPhotos = [];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _budgetController.dispose();
    _streetController.dispose();
    super.dispose();
  }

  Future<void> _pickPhotos() async {
    try {
      final pickedFiles = await _imagePicker.pickMultiImage(
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (pickedFiles.isNotEmpty) {
        setState(() {
          _selectedPhotos.addAll(pickedFiles);
          if (_selectedPhotos.length > 5) {
            _selectedPhotos.removeRange(5, _selectedPhotos.length);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('يمكنك إضافة حد أقصى 5 صور'),
                duration: Duration(seconds: 2),
              ),
            );
          }
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ في اختيار الصور: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _removePhoto(int index) {
    setState(() {
      _selectedPhotos.removeAt(index);
    });
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState?.validate() ?? false) {
      final budget = _budgetController.text.trim().isEmpty
          ? null
          : double.tryParse(_budgetController.text.trim());

      String? fullLocation;
      if (_selectedGovernorate != null) {
        final parts = <String>[
          _selectedGovernorate!,
          if (_selectedLocality != null) _selectedLocality!,
          if (_streetController.text.trim().isNotEmpty)
            _streetController.text.trim(),
        ];
        fullLocation = parts.join(', ');
      }

      await context.read<CreateRequestCubit>().createRequest(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        category: _selectedCategory,
        budget: budget,
        location: fullLocation,
        photoFiles: _selectedPhotos,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.createRequestTitle)),
      body: BlocConsumer<CreateRequestCubit, CreateRequestState>(
        listener: (context, state) {
          state.maybeWhen(
            success: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(AppStrings.requestPublishedSuccess),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.of(context).pop(true);
            },
            error: (message) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(message), backgroundColor: Colors.red),
              );
            },
            orElse: () {},
          );
        },
        builder: (context, state) {
          final isLoading = state.maybeWhen(
            loading: () => true,
            orElse: () => false,
          );

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    key: const ValueKey('create_request_title_field'),
                    controller: _titleController,
                    textDirection: TextDirection.rtl,
                    decoration: const InputDecoration(
                      labelText: 'عنوان الخدمة *',
                      hintText: 'مثال: إصلاح تسرب المياه',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'عنوان الخدمة مطلوب';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),

                  TextFormField(
                    key: const ValueKey('create_request_description_field'),
                    controller: _descriptionController,
                    textDirection: TextDirection.rtl,
                    decoration: const InputDecoration(
                      labelText: 'الوصف *',
                      hintText: 'اشرح التفاصيل والمتطلبات',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 5,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'وصف الخدمة مطلوب';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),

                  DropdownButtonFormField<String>(
                    isExpanded: true,
                    key: const ValueKey('create_request_category_field'),
                    initialValue: _selectedCategory,
                    decoration: const InputDecoration(
                      labelText: 'الفئة *',
                      border: OutlineInputBorder(),
                    ),
                    items: Specializations.all.map((spec) {
                      return DropdownMenuItem(value: spec, child: Text(spec));
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedCategory = value;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),

                  TextFormField(
                    key: const ValueKey('create_request_budget_field'),
                    controller: _budgetController,
                    decoration: const InputDecoration(
                      labelText: 'الميزانية (اختياري)',
                      hintText: 'مثال: 150',
                      border: OutlineInputBorder(),
                      suffixText: 'شيكل',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value != null && value.trim().isNotEmpty) {
                        final budget = double.tryParse(value.trim());
                        if (budget == null || budget <= 0) {
                          return 'الميزانية يجب أن تكون رقماً أكبر من صفر';
                        }
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),

                  LocationSelector(
                    initialGovernorate: _selectedGovernorate,
                    initialLocality: _selectedLocality,
                    onGovernorateChanged: (value) {
                      setState(() => _selectedGovernorate = value);
                    },
                    onLocalityChanged: (value) {
                      setState(() => _selectedLocality = value);
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),

                  TextFormField(
                    key: const ValueKey('create_request_street_field'),
                    controller: _streetController,
                    enabled: !isLoading,
                    decoration: InputDecoration(
                      labelText: 'الشارع / العنوان التفصيلي (اختياري)',
                      hintText: 'أدخل اسم الشارع أو معلومات إضافية',
                      prefixIcon: const Icon(Icons.signpost_rounded),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: AppSpacing.md),

                  OutlinedButton.icon(
                    key: const ValueKey('create_request_photos_button'),
                    onPressed: isLoading ? null : _pickPhotos,
                    icon: const Icon(Icons.add_photo_alternate),
                    label: Text(
                      _selectedPhotos.isEmpty
                          ? 'إضافة صور من المعرض'
                          : 'تم اختيار ${_selectedPhotos.length} صورة',
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      alignment: Alignment.centerRight,
                    ),
                  ),

                  if (_selectedPhotos.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.md),
                    SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _selectedPhotos.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(left: AppSpacing.sm),
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(
                                    File(_selectedPhotos[index].path),
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  top: 4,
                                  right: 4,
                                  child: GestureDetector(
                                    onTap: () => _removePhoto(index),
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle,
                                      ),
                                      padding: const EdgeInsets.all(4),
                                      child: const Icon(
                                        Icons.close,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],

                  const SizedBox(height: AppSpacing.lg),

                  FilledButton(
                    key: const ValueKey('create_request_submit_button'),
                    onPressed: isLoading ? null : _handleSubmit,
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.all(AppSpacing.md),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text('نشر الطلب'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
