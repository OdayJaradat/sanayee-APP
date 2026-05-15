import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../app/admin_router.dart';
import '../../../../core/config/app_colors.dart';
import '../../../../core/config/app_spacing.dart';

/// Admin login page with email/password authentication
class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({super.key});

  @override
  State<AdminLoginPage> createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final supabase = Supabase.instance.client;
      
      // Sign in with email/password
      final response = await supabase.auth.signInWithPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (response.user == null) {
        throw Exception('فشل تسجيل الدخول');
      }

      // Small delay to ensure auth token is properly set
      await Future.delayed(const Duration(milliseconds: 300));

      // Fetch user role from profiles table
      String? role;
      try {
        final profileResponse = await supabase
            .from('profiles')
            .select('role')
            .eq('id', response.user!.id);

        if (profileResponse.isEmpty) {
          // No profile found - sign out and show error
          await supabase.auth.signOut();
          AdminRoleCache.clear();
          if (mounted) {
            setState(() {
              _errorMessage = 'لم يتم العثور على ملف تعريف المستخدم. تأكد من إنشاء profile في قاعدة البيانات.';
              _isLoading = false;
            });
          }
          return;
        }

        role = profileResponse.first['role'] as String?;
      } catch (profileError) {
        // Profile fetch failed - might be RLS issue
        await supabase.auth.signOut();
        AdminRoleCache.clear();
        if (mounted) {
          setState(() {
            _errorMessage = 'فشل في جلب بيانات الملف الشخصي: ${profileError.toString()}';
            _isLoading = false;
          });
        }
        return;
      }

      if (role != 'admin') {
        // Not an admin - sign out and redirect to access denied
        await supabase.auth.signOut();
        AdminRoleCache.clear();
        if (mounted) {
          context.go('/admin/access-denied');
        }
        return;
      }

      // Cache the role
      AdminRoleCache.role = role;

      // Successfully logged in as admin - redirect to dashboard
      if (mounted) {
        context.go('/admin/dashboard');
      }
    } on AuthException catch (e) {
      setState(() {
        _errorMessage = _getAuthErrorMessage(e);
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'حدث خطأ غير متوقع: ${e.toString()}';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String _getAuthErrorMessage(AuthException e) {
    switch (e.message) {
      case 'Invalid login credentials':
        return 'بيانات الدخول غير صحيحة';
      case 'Email not confirmed':
        return 'البريد الإلكتروني غير مؤكد';
      case 'Too many requests':
        return 'محاولات كثيرة، يرجى الانتظار';
      default:
        return e.message;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo/Icon
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppColors.primaryPurple.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.admin_panel_settings_rounded,
                    size: 56,
                    color: AppColors.primaryPurple,
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),

                // Title
                Text(
                  'لوحة إدارة صنايعي',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.neutral900,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'تسجيل دخول المسؤولين',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: AppColors.neutral600,
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),

                // Login Form
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Email Field
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        textDirection: TextDirection.ltr,
                        decoration: InputDecoration(
                          labelText: 'البريد الإلكتروني',
                          hintText: 'admin@example.com',
                          prefixIcon: const Icon(Icons.email_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'البريد الإلكتروني مطلوب';
                          }
                          if (!value.contains('@')) {
                            return 'البريد الإلكتروني غير صالح';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSpacing.md),

                      // Password Field
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        textDirection: TextDirection.ltr,
                        decoration: InputDecoration(
                          labelText: 'كلمة المرور',
                          prefixIcon: const Icon(Icons.lock_outlined),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'كلمة المرور مطلوبة';
                          }
                          if (value.length < 6) {
                            return 'كلمة المرور قصيرة جداً';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSpacing.lg),

                      // Error Message
                      if (_errorMessage != null)
                        Container(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          margin: const EdgeInsets.only(bottom: AppSpacing.md),
                          decoration: BoxDecoration(
                            color: AppColors.error.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                            border: Border.all(
                              color: AppColors.error.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.error_outline,
                                color: AppColors.error,
                                size: 20,
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Expanded(
                                child: Text(
                                  _errorMessage!,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: AppColors.error,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                      // Login Button
                      SizedBox(
                        height: 50,
                        child: FilledButton(
                          onPressed: _isLoading ? null : _handleLogin,
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.primaryPurple,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                            ),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : const Text(
                                  'تسجيل الدخول',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),

                // Footer hint
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.info.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.info_outline,
                        color: AppColors.info,
                        size: 20,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          'هذه اللوحة مخصصة للمسؤولين فقط',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.info,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
