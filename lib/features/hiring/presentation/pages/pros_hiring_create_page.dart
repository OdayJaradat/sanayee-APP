import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/injection.dart';
import '../../../../core/config/app_spacing.dart';
import '../../../auth/domain/usecases/get_current_user.dart';
import '../../domain/entities/job_type.dart';
import '../../domain/entities/service_category.dart';
import '../../domain/entities/pay_type.dart';
import '../../data/repositories/localities_repository.dart';
import '../cubit/hiring_posts_cubit.dart';
import '../cubit/hiring_posts_state.dart';

class ProsHiringCreatePage extends StatelessWidget {
  const ProsHiringCreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<HiringPostsCubit>(),
      child: const _ProsHiringCreateView(),
    );
  }
}

class _ProsHiringCreateView extends StatefulWidget {
  const _ProsHiringCreateView();

  @override
  State<_ProsHiringCreateView> createState() => _ProsHiringCreateViewState();
}

class _ProsHiringCreateViewState extends State<_ProsHiringCreateView> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _addressController = TextEditingController();
  final _fixedAmountController = TextEditingController();
  final _rangeMinController = TextEditingController();
  final _rangeMaxController = TextEditingController();

  ServiceCategory? _selectedCategory;
  String? _selectedGovernorate;
  String? _selectedLocality;
  PayType _selectedPayType = PayType.perTask;

  List<String> _governorates = [];
  List<String> _localities = [];
  bool _isLoadingLocalities = false;

  int _descriptionLength = 0;

  @override
  void initState() {
    super.initState();
    _loadGovernorates();
    _descriptionController.addListener(() {
      setState(() {
        _descriptionLength = _descriptionController.text.length;
      });
    });
  }

  Future<void> _loadGovernorates() async {
    final repo = sl<LocalitiesRepository>();
    final govs = await repo.getGovernorates();
    setState(() {
      _governorates = govs;
    });
  }

  Future<void> _loadLocalitiesFor(String governorate) async {
    setState(() {
      _isLoadingLocalities = true;
      _selectedLocality = null; 
      _localities = []; 
    });

    final repo = sl<LocalitiesRepository>();
    final locs = await repo.getLocalitiesFor(governorate);

    setState(() {
      _localities = locs;
      _isLoadingLocalities = false;
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    _fixedAmountController.dispose();
    _rangeMinController.dispose();
    _rangeMaxController.dispose();
    super.dispose();
  }

  String? _getValidationError() {
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();

    if (title.length < 6) return 'عنوان المهمة يجب أن يكون 6 أحرف على الأقل';
    if (description.length < 20) return 'الوصف يجب أن يكون 20 حرف على الأقل';
    if (description.length > 400) return 'الوصف يجب ألا يتجاوز 400 حرف';
    if (_selectedCategory == null) return 'يرجى اختيار التصنيف';
    if (_selectedGovernorate == null) return 'يرجى اختيار المحافظة';
    if (_selectedLocality == null) return 'يرجى اختيار البلدة/المدينة';

    if (_selectedPayType.isFixed) {
      final amount = double.tryParse(_fixedAmountController.text);
      if (amount == null || amount <= 0) {
        return 'يرجى إدخال مبلغ صحيح أكبر من صفر';
      }
    } else {
      final min = double.tryParse(_rangeMinController.text);
      final max = double.tryParse(_rangeMaxController.text);
      if (min == null || min <= 0) {
        return 'يرجى إدخال حد أدنى صحيح للمبلغ';
      }
      if (max == null || max < min) {
        return 'الحد الأقصى يجب أن يكون أكبر من أو يساوي الحد الأدنى';
      }
    }

    return null;
  }

  void _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يرجى ملء جميع الحقول المطلوبة بشكل صحيح'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final validationError = _getValidationError();
    if (validationError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(validationError),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final getCurrentUser = sl<GetCurrentUser>();
    final userResult = await getCurrentUser();

    userResult.fold(
      (failure) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('خطأ في المصادقة: ${failure.message}')),
          );
        }
      },
      (user) {
        if (user == null) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('يجب تسجيل الدخول أولاً')),
            );
          }
          return;
        }

        if (!user.role.isProfessional) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('يجب تسجيل الدخول كصنايعي')),
            );
          }
          return;
        }

        double? fixedAmount;
        double? rangeMin;
        double? rangeMax;

        if (_selectedPayType.isFixed) {
          fixedAmount = double.tryParse(_fixedAmountController.text);
        } else {
          rangeMin = double.tryParse(_rangeMinController.text);
          rangeMax = double.tryParse(_rangeMaxController.text);
        }

        context.read<HiringPostsCubit>().createPost(
          professionalId: user.id,
          title: _titleController.text,
          description: _descriptionController.text,
          jobType: JobType.gig, 
          category: _selectedCategory,
          governorate: _selectedGovernorate,
          locality: _selectedLocality,
          address: _addressController.text.trim().isNotEmpty
              ? _addressController.text
              : null,
          payType: _selectedPayType,
          fixedAmount: fixedAmount,
          rangeMin: rangeMin,
          rangeMax: rangeMax,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('إنشاء طلب مساعد بناء/إصلاح')),
      body: BlocConsumer<HiringPostsCubit, HiringPostsState>(
        listener: (context, state) {
          if (state is HiringPostOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 2),
              ),
            );
            context.pop(true);
          } else if (state is HiringPostOperationError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is HiringPostOperationLoading;

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Form(
                    key: _formKey,
                    onChanged: () => setState(() {}),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          '1. المهمة',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),

                        TextFormField(
                          controller: _titleController,
                          decoration: const InputDecoration(
                            labelText: 'عنوان المهمة *',
                            hintText: 'مثال: إصلاح سباكة المطبخ',
                            border: OutlineInputBorder(),
                          ),
                          enabled: !isLoading,
                          validator: (value) {
                            if (value == null || value.trim().length < 6) {
                              return 'العنوان يجب أن يكون 6 أحرف على الأقل';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),

                        DropdownButtonFormField<ServiceCategory>(
                          isExpanded: true,
                          initialValue: _selectedCategory,
                          decoration: const InputDecoration(
                            labelText: 'التصنيف *',
                            border: OutlineInputBorder(),
                          ),
                          items: ServiceCategory.all
                              .map(
                                (cat) => DropdownMenuItem(
                                  value: cat,
                                  child: Text(cat.displayName),
                                ),
                              )
                              .toList(),
                          onChanged: isLoading
                              ? null
                              : (value) {
                                  setState(() {
                                    _selectedCategory = value;
                                  });
                                },
                          validator: (value) {
                            if (value == null) {
                              return 'التصنيف مطلوب';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),

                        TextFormField(
                          controller: _descriptionController,
                          decoration: InputDecoration(
                            labelText: 'الوصف *',
                            hintText: 'اذكر التفاصيل...',
                            border: const OutlineInputBorder(),
                            helperText: '$_descriptionLength / 400 حرف',
                            helperStyle: TextStyle(
                              color: _descriptionLength < 20
                                  ? theme.colorScheme.error
                                  : _descriptionLength > 400
                                  ? theme.colorScheme.error
                                  : theme.colorScheme.onSurface.withValues(
                                      alpha: 0.6,
                                    ),
                            ),
                          ),
                          maxLines: 4,
                          maxLength: 400,
                          enabled: !isLoading,
                          validator: (value) {
                            if (value == null || value.trim().length < 20) {
                              return 'الوصف يجب أن يكون 20 حرف على الأقل';
                            }
                            if (value.trim().length > 400) {
                              return 'الوصف يجب ألا يتجاوز 400 حرف';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        Text(
                          '2. المكان',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),

                        DropdownButtonFormField<String>(
                          isExpanded: true,
                          initialValue:
                              _governorates.contains(_selectedGovernorate)
                              ? _selectedGovernorate
                              : null,
                          decoration: const InputDecoration(
                            labelText: 'المحافظة *',
                            border: OutlineInputBorder(),
                          ),
                          items: _governorates
                              .map(
                                (gov) => DropdownMenuItem(
                                  value: gov,
                                  child: Text(gov),
                                ),
                              )
                              .toList(),
                          onChanged: isLoading
                              ? null
                              : (value) {
                                  setState(() {
                                    _selectedGovernorate = value;
                                  });
                                  if (value != null) {
                                    _loadLocalitiesFor(value);
                                  }
                                },
                          validator: (value) {
                            if (value == null) {
                              return 'المحافظة مطلوبة';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),

                        if (_selectedGovernorate != null)
                          _isLoadingLocalities
                              ? const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(16),
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                              : DropdownButtonFormField<String>(
                                  isExpanded: true,
                                  key: ValueKey(
                                    '${_selectedGovernorate}_locality',
                                  ),
                                  initialValue:
                                      _localities.contains(_selectedLocality)
                                      ? _selectedLocality
                                      : null,
                                  decoration: const InputDecoration(
                                    labelText: 'البلدة/المدينة *',
                                    border: OutlineInputBorder(),
                                  ),
                                  items: _localities
                                      .map(
                                        (loc) => DropdownMenuItem(
                                          value: loc,
                                          child: Text(loc),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: isLoading
                                      ? null
                                      : (value) {
                                          setState(() {
                                            _selectedLocality = value;
                                          });
                                        },
                                  validator: (value) {
                                    if (value == null) {
                                      return 'البلدة/المدينة مطلوبة';
                                    }
                                    return null;
                                  },
                                ),
                        if (_selectedGovernorate != null)
                          const SizedBox(height: 12),

                        TextFormField(
                          controller: _addressController,
                          decoration: const InputDecoration(
                            labelText: 'العنوان (اختياري)',
                            hintText: 'مثال: شارع الجامعة، بناية رقم 5',
                            border: OutlineInputBorder(),
                          ),
                          enabled: !isLoading,
                        ),
                        const SizedBox(height: 16),

                        Text(
                          '3. الدفع',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),

                        DropdownButtonFormField<PayType>(
                          initialValue: _selectedPayType,
                          decoration: const InputDecoration(
                            labelText: 'نوع الدفع *',
                            border: OutlineInputBorder(),
                          ),
                          items: PayType.values
                              .map(
                                (type) => DropdownMenuItem(
                                  value: type,
                                  child: Text(type.displayName),
                                ),
                              )
                              .toList(),
                          onChanged: isLoading
                              ? null
                              : (value) {
                                  setState(() {
                                    _selectedPayType = value!;
                                  });
                                },
                        ),
                        const SizedBox(height: 12),

                        if (_selectedPayType.isFixed)
                          TextFormField(
                            controller: _fixedAmountController,
                            decoration: const InputDecoration(
                              labelText: 'المبلغ *',
                              hintText: '0',
                              suffixText: 'شيكل',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            enabled: !isLoading,
                            validator: (value) {
                              final amount = double.tryParse(value ?? '');
                              if (amount == null || amount <= 0) {
                                return 'المبلغ يجب أن يكون أكبر من صفر';
                              }
                              return null;
                            },
                          )
                        else
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _rangeMinController,
                                  decoration: const InputDecoration(
                                    labelText: 'من *',
                                    hintText: '0',
                                    suffixText: '₪',
                                    border: OutlineInputBorder(),
                                  ),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  enabled: !isLoading,
                                  validator: (value) {
                                    final min = double.tryParse(value ?? '');
                                    if (min == null || min <= 0) {
                                      return 'يجب أن يكون > 0';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: TextFormField(
                                  controller: _rangeMaxController,
                                  decoration: const InputDecoration(
                                    labelText: 'إلى *',
                                    hintText: '0',
                                    suffixText: '₪',
                                    border: OutlineInputBorder(),
                                  ),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  enabled: !isLoading,
                                  validator: (value) {
                                    final max = double.tryParse(value ?? '');
                                    final min = double.tryParse(
                                      _rangeMinController.text,
                                    );
                                    if (max == null) {
                                      return 'مطلوب';
                                    }
                                    if (min != null && max < min) {
                                      return '>= من';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                        const SizedBox(height: 80), 
                      ],
                    ),
                  ),
                ),
              ),

              Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 4,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(AppSpacing.md),
                child: FilledButton(
                  onPressed: isLoading ? null : _handleSubmit,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
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
              ),
            ],
          );
        },
      ),
    );
  }
}
