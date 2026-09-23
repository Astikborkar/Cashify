import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../routes/route_paths.dart';
import '../providers/auth_provider.dart';

/// Screen allowing new customers to register with email, phone, and password.
class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (_formKey.currentState?.validate() ?? false) {
      final success = await ref.read(authNotifierProvider.notifier).registerWithEmail(
        fullName: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        password: _passwordController.text,
      );

      if (!mounted) return;

      if (success) {
        context.go(RoutePaths.home);
      } else {
        final error = ref.read(authNotifierProvider).errorMessage ?? 'Registration failed';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error), backgroundColor: AppColors.error),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Create Account'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.screenPadding,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.md),
                const Text(
                  'Join Cashify',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Sign up to sell electronics, buy certified refurbished devices, and earn cashback.',
                  style: TextStyle(fontSize: 14, color: AppColors.neutral700),
                ),
                const SizedBox(height: AppSpacing.xl),

                // Full Name
                AppTextField(
                  label: 'Full Name',
                  hint: 'Rahul Sharma',
                  controller: _nameController,
                  prefix: const Icon(Icons.person_outline_rounded, size: 20, color: AppColors.neutral500),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Please enter your full name' : null,
                ),
                const SizedBox(height: AppSpacing.md),

                // Email
                AppTextField(
                  label: 'Email Address',
                  hint: 'rahul@example.com',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  prefix: const Icon(Icons.email_outlined, size: 20, color: AppColors.neutral500),
                  validator: Validators.validateEmail,
                ),
                const SizedBox(height: AppSpacing.md),

                // Phone
                AppTextField(
                  label: 'Mobile Number',
                  hint: '98765 43210',
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  prefix: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Center(
                      widthFactor: 1.0,
                      child: Text('+91 | ', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.neutral700)),
                    ),
                  ),
                  validator: Validators.validatePhone,
                ),
                const SizedBox(height: AppSpacing.md),

                // Password
                AppTextField(
                  label: 'Password',
                  hint: '••••••••',
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  prefix: const Icon(Icons.lock_outline_rounded, size: 20, color: AppColors.neutral500),
                  suffix: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                      size: 20,
                      color: AppColors.neutral500,
                    ),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  validator: (v) {
                    if (v == null || v.length < 6) {
                      return 'Password must be at least 6 characters long';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: AppSpacing.xl),

                AppButton(
                  text: 'Create Account',
                  isLoading: authState.isLoading,
                  onPressed: _handleRegister,
                ),

                const SizedBox(height: AppSpacing.lg),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have an account? ', style: TextStyle(color: AppColors.neutral700)),
                    GestureDetector(
                      onTap: () => context.pop(),
                      child: const Text(
                        'Log In',
                        style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.primaryDark),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.xl),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
