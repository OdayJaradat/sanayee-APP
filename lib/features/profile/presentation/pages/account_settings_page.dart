import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:numberpicker/numberpicker.dart';
import '../../../../app/injection.dart';
import '../../../../core/config/app_spacing.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/location_selector.dart';
import '../../../auth/domain/repositories/user_repository.dart';
import '../../domain/entities/profile.dart';
import '../../domain/repositories/profile_repository.dart';

class AccountSettingsPage extends StatefulWidget {
  const AccountSettingsPage({super.key});

  @override
  State<AccountSettingsPage> createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettingsPage> {
  final _formKey = GlobalKey<FormState>();
  final _profileRepo = sl<ProfileRepository>();
  final _userRepo = sl<UserRepository>();
  final _storageService = sl<StorageService>();
  final _imagePicker = ImagePicker();

  late TextEditingController _fullNameController;
  late TextEditingController _phoneController;
  late TextEditingController _cityController;
  late TextEditingController _bioController;
  late TextEditingController _specializationController;
  late TextEditingController _certificationsController;

  String? _selectedGovernorate;
  String? _selectedLocality;

  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  DateTime? _dateOfBirth;
  int _yearsExperience = 0;
  bool _isLoading = false;
  bool _isChangingPassword = false;
  Profile? _currentProfile;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController();
    _phoneController = TextEditingController();
    _cityController = TextEditingController();
    _bioController = TextEditingController();
    _specializationController = TextEditingController();
    _certificationsController = TextEditingController();
    _loadProfile();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
    _bioController.dispose();
    _specializationController.dispose();
    _certificationsController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    setState(() => _isLoading = true);

    final result = await _profileRepo.getMyProfile();
    result.fold(
      (failure) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('فشل في تحميل البيانات: ${failure.message}'),
            ),
          );
        }
      },
      (profile) {
        setState(() {
          _currentProfile = profile;
          _fullNameController.text = profile.fullName;
          _phoneController.text = profile.phone ?? '';
          _cityController.text = profile.city ?? '';
          _selectedGovernorate = profile.governorate;
          _selectedLocality = profile.locality;
          _bioController.text = profile.bio ?? '';
          _dateOfBirth = profile.dateOfBirth;
          _yearsExperience = profile.yearsExperience;
          _specializationController.text = profile.specialization ?? '';
          _certificationsController.text = profile.certifications.join(', ');
        });
      },
    );

    setState(() => _isLoading = false);
  }

  Future<void> _uploadProfilePhoto() async {
    try {
      final pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );

      if (pickedFile == null) return;

      setState(() => _isLoading = true);

      final bytes = await pickedFile.readAsBytes();

      final userId = _currentProfile?.id ?? 'unknown';
      final path = 'avatars/$userId.png';

      final uploadResult = await _storageService.uploadImage(
        bytes: bytes,
        path: path,
      );

      await uploadResult.fold(
        (failure) async {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('فشل في رفع الصورة: ${failure.message}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        (imageUrl) async {
          final result = await _profileRepo.updateProfile(avatarUrl: imageUrl);

          result.fold(
            (failure) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('فشل في حفظ الصورة: ${failure.message}'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            (profile) {
              if (mounted) {
                setState(() => _currentProfile = profile);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('تم تحديث الصورة بنجاح'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
          );
        },
      );

      setState(() => _isLoading = false);
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final certifications = _certificationsController.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    final result = await _profileRepo.updateProfile(
      fullName: _fullNameController.text,
      phone: _phoneController.text.isNotEmpty ? _phoneController.text : null,
      governorate: _selectedGovernorate,
      locality: _selectedLocality,
      dateOfBirth: _dateOfBirth,
      bio: _bioController.text.isNotEmpty ? _bioController.text : null,
      yearsExperience: _currentProfile?.isProfessional == true
          ? _yearsExperience
          : null,
      specialization:
          _currentProfile?.isProfessional == true &&
              _specializationController.text.isNotEmpty
          ? _specializationController.text
          : null,
      certifications:
          _currentProfile?.isProfessional == true && certifications.isNotEmpty
          ? certifications
          : null,
    );

    setState(() => _isLoading = false);

    if (mounted) {
      result.fold(
        (failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('فشل في حفظ التعديلات: ${failure.message}'),
              backgroundColor: Colors.red,
            ),
          );
        },
        (profile) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('تم حفظ التعديلات بنجاح'),
              backgroundColor: Colors.green,
            ),
          );
          setState(() => _currentProfile = profile);
        },
      );
    }
  }

  Future<void> _changePassword() async {
    if (_currentPasswordController.text.isEmpty ||
        _newPasswordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى ملء جميع حقول كلمة السر')),
      );
      return;
    }

    if (_newPasswordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('كلمة السر الجديدة وتأكيدها غير متطابقين'),
        ),
      );
      return;
    }

    if (_newPasswordController.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('كلمة السر يجب أن تكون 6 أحرف على الأقل')),
      );
      return;
    }

    setState(() => _isChangingPassword = true);

    final result = await _userRepo.changePassword(
      currentPassword: _currentPasswordController.text,
      newPassword: _newPasswordController.text,
    );

    setState(() => _isChangingPassword = false);

    if (mounted) {
      result.fold(
        (failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(failure.message),
              backgroundColor: Colors.red,
            ),
          );
        },
        (_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('تم تغيير كلمة السر بنجاح'),
              backgroundColor: Colors.green,
            ),
          );
          _currentPasswordController.clear();
          _newPasswordController.clear();
          _confirmPasswordController.clear();
        },
      );
    }
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate:
          _dateOfBirth ??
          DateTime.now().subtract(const Duration(days: 365 * 25)),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      locale: const Locale('ar'),
    );

    if (picked != null) {
      setState(() => _dateOfBirth = picked);
    }
  }

  Future<void> _showYearsPickerDialog() async {
    await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        int tempValue = _yearsExperience;
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('سنوات الخبرة'),
              content: NumberPicker(
                value: tempValue,
                minValue: 0,
                maxValue: 50,
                onChanged: (value) => setDialogState(() => tempValue = value),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('إلغاء'),
                ),
                TextButton(
                  onPressed: () {
                    setState(() => _yearsExperience = tempValue);
                    Navigator.of(context).pop();
                  },
                  child: const Text('تأكيد'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isLoading && _currentProfile == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('معلومات الحساب')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('معلومات الحساب')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: _currentProfile?.avatarUrl != null
                        ? NetworkImage(_currentProfile!.avatarUrl!)
                        : null,
                    backgroundColor: theme.colorScheme.primary.withValues(
                      alpha: 0.1,
                    ),
                    child: _currentProfile?.avatarUrl == null
                        ? Icon(
                            Icons.person,
                            size: 60,
                            color: theme.colorScheme.primary,
                          )
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: theme.colorScheme.surface,
                          width: 2,
                        ),
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.camera_alt,
                          size: 20,
                          color: Colors.white,
                        ),
                        onPressed: _uploadProfilePhoto,
                        padding: const EdgeInsets.all(8),
                        constraints: const BoxConstraints(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            AppCard(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.person, color: theme.colorScheme.primary),
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          'المعلومات الشخصية',
                          style: theme.textTheme.titleMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),

                    TextFormField(
                      initialValue: _currentProfile?.email,
                      decoration: const InputDecoration(
                        labelText: 'البريد الإلكتروني',
                        prefixIcon: Icon(Icons.email),
                        enabled: false,
                      ),
                      readOnly: true,
                    ),
                    const SizedBox(height: AppSpacing.md),

                    TextFormField(
                      controller: _fullNameController,
                      decoration: const InputDecoration(
                        labelText: 'الاسم الكامل *',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'يرجى إدخال الاسم الكامل';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSpacing.md),

                    TextFormField(
                      controller: _phoneController,
                      decoration: const InputDecoration(
                        labelText: 'رقم الهاتف',
                        prefixIcon: Icon(Icons.phone),
                      ),
                      keyboardType: TextInputType.phone,
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
                      onTap: _selectDate,
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'تاريخ الميلاد',
                          prefixIcon: Icon(Icons.calendar_today),
                        ),
                        child: Text(
                          _dateOfBirth != null
                              ? DateFormat('yyyy-MM-dd').format(_dateOfBirth!)
                              : 'اختر التاريخ',
                          style: theme.textTheme.bodyLarge,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),

                    TextFormField(
                      controller: _bioController,
                      decoration: InputDecoration(
                        labelText: 'النبذة التعريفية',
                        prefixIcon: const Icon(Icons.info_outline),
                        helperText: '${_bioController.text.length}/500',
                      ),
                      maxLines: 3,
                      maxLength: 500,
                      buildCounter:
                          (
                            context, {
                            required currentLength,
                            required isFocused,
                            maxLength,
                          }) {
                            return null;
                          },
                      onChanged: (value) => setState(() {}),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            if (_currentProfile?.isProfessional == true) ...[
              AppCard(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.work, color: theme.colorScheme.primary),
                          const SizedBox(width: AppSpacing.sm),
                          Text(
                            'معلومات الصنايعي',
                            style: theme.textTheme.titleMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),

                      InkWell(
                        onTap: _showYearsPickerDialog,
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'سنوات الخبرة',
                            prefixIcon: Icon(Icons.trending_up),
                          ),
                          child: Text(
                            '$_yearsExperience سنة',
                            style: theme.textTheme.bodyLarge,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),

                      TextFormField(
                        controller: _specializationController,
                        decoration: const InputDecoration(
                          labelText: 'التخصص',
                          prefixIcon: Icon(Icons.category),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),

                      TextFormField(
                        controller: _certificationsController,
                        decoration: const InputDecoration(
                          labelText: 'الشهادات (مفصولة بفاصلة)',
                          prefixIcon: Icon(Icons.card_membership),
                          hintText: 'شهادة 1, شهادة 2, شهادة 3',
                        ),
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
            ],

            AppCard(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.lock, color: theme.colorScheme.primary),
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          'تغيير كلمة السر',
                          style: theme.textTheme.titleMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),

                    TextFormField(
                      controller: _currentPasswordController,
                      decoration: const InputDecoration(
                        labelText: 'كلمة السر الحالية',
                        prefixIcon: Icon(Icons.lock_outline),
                      ),
                      obscureText: true,
                    ),
                    const SizedBox(height: AppSpacing.md),

                    TextFormField(
                      controller: _newPasswordController,
                      decoration: const InputDecoration(
                        labelText: 'كلمة السر الجديدة',
                        prefixIcon: Icon(Icons.lock),
                        helperText: 'على الأقل 6 أحرف',
                      ),
                      obscureText: true,
                    ),
                    const SizedBox(height: AppSpacing.md),

                    TextFormField(
                      controller: _confirmPasswordController,
                      decoration: const InputDecoration(
                        labelText: 'تأكيد كلمة السر الجديدة',
                        prefixIcon: Icon(Icons.lock),
                      ),
                      obscureText: true,
                    ),
                    const SizedBox(height: AppSpacing.md),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isChangingPassword ? null : _changePassword,
                        child: _isChangingPassword
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('تغيير كلمة السر'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _saveProfile,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'حفظ التعديلات',
                        style: TextStyle(fontSize: 16),
                      ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
          ],
        ),
      ),
    );
  }
}
