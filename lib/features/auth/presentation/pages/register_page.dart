import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:numberpicker/numberpicker.dart';
import '../../../../core/config/app_spacing.dart';
import '../../../../core/constants/specializations.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/location_selector.dart';
import '../../../profile/domain/entities/user_role.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _pageController = PageController();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _bioController = TextEditingController();
  final _certificationsController = TextEditingController();

  UserRole _selectedRole = UserRole.client;
  DateTime? _dateOfBirth;
  String? _selectedSpecialization;
  String? _selectedGovernorate;
  String? _selectedLocality;
  int _currentPage = 0;
  int _yearsOfExperience = 0;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _fullNameController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    _certificationsController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('إنشاء حساب جديد'),
        actions: [
          if (_currentPage > 0)
            IconButton(
              icon: const Icon(Icons.arrow_forward),
              onPressed: () {
                _pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
            ),
        ],
      ),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          state.maybeWhen(
            authenticated: (user) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم إنشاء الحساب بنجاح!'),
                  backgroundColor: Colors.green,
                ),
              );

              if (user.role.isClient) {
                context.go('/client/requests');
              } else {
                context.go('/pro/jobs');
              }
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

          return Column(
            children: [
              LinearProgressIndicator(
                value: (_currentPage + 1) / 3,
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
              ),

              Expanded(
                child: Form(
                  key: _formKey,
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: (page) {
                      setState(() => _currentPage = page);
                    },
                    children: [
                      _buildStep1Account(),
                      _buildStep2BasicInfo(),
                      _buildStep3RoleSpecific(),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Row(
                  children: [
                    if (_currentPage > 0)
                      Expanded(
                        child: OutlinedButton(
                          onPressed: isLoading
                              ? null
                              : () {
                                  _pageController.previousPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                },
                          child: const Text('السابق'),
                        ),
                      ),
                    if (_currentPage > 0) const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: FilledButton(
                        onPressed: isLoading ? null : _handleNext,
                        child: isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                _currentPage == 2 ? 'إنشاء الحساب' : 'التالي',
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStep1Account() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'الخطوة 1: بيانات الحساب',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: AppSpacing.md),

          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'البريد الإلكتروني',
                    prefixIcon: Icon(Icons.email),
                    hintText: 'example@email.com',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'الرجاء إدخال البريد الإلكتروني';
                    }
                    if (!value.contains('@') || !value.contains('.')) {
                      return 'البريد الإلكتروني غير صالح';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.md),

                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'كلمة المرور',
                    prefixIcon: Icon(Icons.lock),
                    helperText: 'على الأقل 6 أحرف',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'الرجاء إدخال كلمة المرور';
                    }
                    if (value.length < 6) {
                      return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.md),

                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'تأكيد كلمة المرور',
                    prefixIcon: Icon(Icons.lock_outline),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'الرجاء تأكيد كلمة المرور';
                    }
                    if (value != _passwordController.text) {
                      return 'كلمات المرور غير متطابقة';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'اختر نوع الحساب',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.sm),
                SegmentedButton<UserRole>(
                  segments: const [
                    ButtonSegment(
                      value: UserRole.client,
                      label: Text('عميل'),
                      icon: Icon(Icons.person, size: 16),
                    ),
                    ButtonSegment(
                      value: UserRole.professional,
                      label: Text('صنايعي'),
                      icon: Icon(Icons.work, size: 16),
                    ),
                  ],
                  selected: {_selectedRole},
                  onSelectionChanged: (Set<UserRole> selection) {
                    setState(() {
                      _selectedRole = selection.first;
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep2BasicInfo() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'الخطوة 2: المعلومات الأساسية',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: AppSpacing.md),

          AppCard(
            child: Column(
              children: [
                TextFormField(
                  controller: _fullNameController,
                  decoration: const InputDecoration(
                    labelText: 'الاسم الكامل *',
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'الرجاء إدخال الاسم الكامل';
                    }
                    if (value.length < 2) {
                      return 'الاسم قصير جداً';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.md),

                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'رقم الهاتف *',
                    prefixIcon: Icon(Icons.phone),
                    hintText: '+970599123456',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'الرجاء إدخال رقم الهاتف';
                    }
                    if (!value.startsWith('+') || value.length < 10) {
                      return 'رقم الهاتف غير صالح (استخدم صيغة +970...)';
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

                InkWell(
                  onTap: () => _selectDateOfBirth(context),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'تاريخ الميلاد',
                      prefixIcon: Icon(Icons.calendar_today),
                      helperText: 'اختياري - يجب أن تكون 18+',
                    ),
                    child: Text(
                      _dateOfBirth != null
                          ? DateFormat('yyyy-MM-dd').format(_dateOfBirth!)
                          : 'اضغط للاختيار',
                      style: TextStyle(
                        color: _dateOfBirth != null
                            ? null
                            : Theme.of(context).hintColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),

                TextFormField(
                  controller: _bioController,
                  maxLines: 3,
                  maxLength: 160,
                  decoration: const InputDecoration(
                    labelText: 'نبذة تعريفية',
                    prefixIcon: Icon(Icons.info_outline),
                    hintText: 'أخبرنا عن نفسك...',
                    helperText: 'اختياري - حتى 160 حرف',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep3RoleSpecific() {
    if (_selectedRole == UserRole.client) {
      return _buildClientStep3();
    } else {
      return _buildProfessionalStep3();
    }
  }

  Widget _buildClientStep3() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'الخطوة 3: مراجعة',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: AppSpacing.md),

          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.check_circle, size: 64, color: Colors.green),
                const SizedBox(height: AppSpacing.md),

                Text(
                  'جاهز للبدء!',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: AppSpacing.sm),

                Text(
                  'بصفتك عميل، يمكنك الآن:',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: AppSpacing.sm),

                const _BulletPoint('نشر طلبات الخدمات'),
                const _BulletPoint('تصفح العروض من الصنايعية'),
                const _BulletPoint('التواصل مع مقدمي الخدمات'),
                const _BulletPoint('تقييم الخدمات المكتملة'),

                const SizedBox(height: AppSpacing.md),
                const Divider(),
                const SizedBox(height: AppSpacing.sm),

                _buildReviewItem('البريد الإلكتروني', _emailController.text),
                _buildReviewItem('الاسم الكامل', _fullNameController.text),
                _buildReviewItem('رقم الهاتف', _phoneController.text),
                if (_selectedGovernorate != null)
                  _buildReviewItem('المحافظة', _selectedGovernorate!),
                if (_selectedLocality != null)
                  _buildReviewItem('البلدة', _selectedLocality!),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfessionalStep3() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'الخطوة 3: معلومات الصنايعي',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: AppSpacing.md),

          AppCard(
            child: Column(
              children: [
                InkWell(
                  onTap: () => _showYearsPickerDialog(context),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'سنوات الخبرة *',
                      prefixIcon: Icon(Icons.work_history),
                      helperText: '0-60 سنة',
                      border: OutlineInputBorder(),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '$_yearsOfExperience سنة',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const Icon(Icons.arrow_drop_down),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),

                DropdownButtonFormField<String>(
                  isExpanded: true,
                  initialValue: _selectedSpecialization,
                  decoration: const InputDecoration(
                    labelText: 'التخصص *',
                    prefixIcon: Icon(Icons.category),
                  ),
                  items: Specializations.all.map((spec) {
                    return DropdownMenuItem(value: spec, child: Text(spec));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedSpecialization = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'الرجاء اختيار التخصص';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.md),

                TextFormField(
                  controller: _certificationsController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'الشهادات والدورات',
                    prefixIcon: Icon(Icons.card_membership),
                    hintText: 'أدخل الشهادات مفصولة بفاصلة',
                    helperText: 'اختياري',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value.isEmpty ? '-' : value)),
        ],
      ),
    );
  }

  Future<void> _selectDateOfBirth(BuildContext context) async {
    final now = DateTime.now();
    final eighteenYearsAgo = DateTime(now.year - 18, now.month, now.day);

    final picked = await showDatePicker(
      context: context,
      initialDate: _dateOfBirth ?? eighteenYearsAgo,
      firstDate: DateTime(1940),
      lastDate: eighteenYearsAgo,
      helpText: 'اختر تاريخ الميلاد',
    );

    if (picked != null) {
      setState(() {
        _dateOfBirth = picked;
      });
    }
  }

  void _handleNext() {
    if (_currentPage < 2) {
      if (!_formKey.currentState!.validate()) {
        return;
      }

      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _handleSubmit();
    }
  }

  void _showYearsPickerDialog(BuildContext context) {
    int tempYears = _yearsOfExperience;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('اختر سنوات الخبرة'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return NumberPicker(
                value: tempYears,
                minValue: 0,
                maxValue: 60,
                step: 1,
                axis: Axis.vertical,
                onChanged: (value) => setState(() => tempYears = value),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.black26),
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _yearsOfExperience = tempYears;
                });
                Navigator.of(context).pop();
              },
              child: const Text('تأكيد'),
            ),
          ],
        );
      },
    );
  }

  void _handleSubmit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    try {
      final certifications = _certificationsController.text.isEmpty
          ? <String>[]
          : _certificationsController.text
                .split(',')
                .map((e) => e.trim())
                .where((e) => e.isNotEmpty)
                .toList();

      final fullName = _fullNameController.text.trim();
      if (fullName.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('الرجاء إدخال الاسم الكامل'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      context.read<AuthCubit>().signUpWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        role: _selectedRole,
        fullName: fullName,
        phone: _phoneController.text.trim().isEmpty
            ? null
            : _phoneController.text.trim(),
        governorate: _selectedGovernorate,
        locality: _selectedLocality,
        dateOfBirth: _dateOfBirth,
        bio: _bioController.text.trim().isEmpty
            ? null
            : _bioController.text.trim(),
        yearsExperience: _yearsOfExperience,
        certifications: certifications,
        specialization: _selectedSpecialization,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('خطأ: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

class _BulletPoint extends StatelessWidget {
  final String text;

  const _BulletPoint(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 18)),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
