import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../routes/route_paths.dart';
import '../providers/auth_provider.dart';

/// Comprehensive Login Screen supporting Phone OTP, Email/Password, Social Sign-In, and Guest Mode.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _phoneFormKey = GlobalKey<FormState>();
  final _emailFormKey = GlobalKey<FormState>();

  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handlePhoneOtp() async {
    if (_phoneFormKey.currentState?.validate() ?? false) {
      final phone = _phoneController.text.trim();
      final success = await ref.read(authNotifierProvider.notifier).requestOtp(phone);
      if (!mounted) return;

      if (success) {
        context.push('${RoutePaths.otp}?phone=$phone');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to send OTP. Please try again.')),
        );
      }
    }
  }

  Future<void> _handleEmailLogin() async {
    if (_emailFormKey.currentState?.validate() ?? false) {
      final success = await ref.read(authNotifierProvider.notifier).loginWithEmail(
        _emailController.text.trim(),
        _passwordController.text,
      );
      if (!mounted) return;

      if (success) {
        context.go(RoutePaths.home);
      } else {
        final error = ref.read(authNotifierProvider).errorMessage ?? 'Login failed';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error), backgroundColor: AppColors.error),
        );
      }
    }
  }

  Future<void> _handleGoogleSignIn() async {
    final success = await ref.read(authNotifierProvider.notifier).signInWithGoogle();
    if (mounted && success) {
      context.go(RoutePaths.home);
    }
  }

  Future<void> _handleAppleSignIn() async {
    final success = await ref.read(authNotifierProvider.notifier).signInWithApple();
    if (mounted && success) {
      context.go(RoutePaths.home);
    }
  }

  void _handleGuestMode() {
    ref.read(authNotifierProvider.notifier).continueAsGuest();
    context.go(RoutePaths.home);
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.md),
              // App Brand Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: AppSpacing.roundedSm,
                    ),
                    child: const Icon(Icons.flash_on_rounded, color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  const Text(
                    'Cashify',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: AppColors.neutral900,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              const Text(
                'Welcome Back',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 4),
              const Text(
                'Sign in to manage your orders, sell requests, and instant payouts.',
                style: TextStyle(fontSize: 14, color: AppColors.neutral700),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Tab Bar (Mobile OTP vs Email)
              Container(
                decoration: BoxDecoration(
                  color: AppColors.neutral100,
                  borderRadius: AppSpacing.roundedMd,
                ),
                child: TabBar(
                  controller: _tabController,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: AppSpacing.roundedMd,
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: AppColors.neutral700,
                  labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                  tabs: const [
                    Tab(text: 'Mobile OTP'),
                    Tab(text: 'Email & Password'),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              // Tab Views
              SizedBox(
                height: 230,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // Tab 1: Phone OTP
                    Form(
                      key: _phoneFormKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppTextField(
                            label: 'Mobile Number',
                            hint: '98765 43210',
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            prefix: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              child: Center(
                                widthFactor: 1.0,
                                child: Text(
                                  '+91 | ',
                                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.neutral700),
                                ),
                              ),
                            ),
                            validator: Validators.validatePhone,
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          AppButton(
                            text: 'Get 6-Digit OTP',
                            isLoading: authState.isLoading,
                            onPressed: _handlePhoneOtp,
                          ),
                        ],
                      ),
                    ),

                    // Tab 2: Email & Password
                    Form(
                      key: _emailFormKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppTextField(
                            label: 'Email',
                            hint: 'rahul@example.com',
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            prefix: const Icon(Icons.email_outlined, size: 20, color: AppColors.neutral500),
                            validator: Validators.validateEmail,
                          ),
                          const SizedBox(height: AppSpacing.sm),
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
                            validator: (v) => (v == null || v.isEmpty) ? 'Password is required' : null,
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () => context.push(RoutePaths.forgotPassword),
                              child: const Text('Forgot Password?', style: TextStyle(fontSize: 12)),
                            ),
                          ),
                          AppButton(
                            text: 'Log In',
                            isLoading: authState.isLoading,
                            onPressed: _handleEmailLogin,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.md),

              // Social Sign-In Divider
              const Row(
                children: [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('OR CONNECT WITH', style: TextStyle(color: AppColors.neutral500, fontSize: 11, fontWeight: FontWeight.w700)),
                  ),
                  Expanded(child: Divider()),
                ],
              ),

              const SizedBox(height: AppSpacing.md),

              // Social Buttons Row
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.g_mobiledata_rounded, size: 28, color: Color(0xFFEA4335)),
                      label: const Text('Google', style: TextStyle(color: AppColors.neutral900, fontWeight: FontWeight.w600)),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.borderLight),
                        shape: RoundedRectangleBorder(borderRadius: AppSpacing.roundedMd),
                      ),
                      onPressed: _handleGoogleSignIn,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.apple_rounded, size: 22, color: Colors.black),
                      label: const Text('Apple', style: TextStyle(color: AppColors.neutral900, fontWeight: FontWeight.w600)),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.borderLight),
                        shape: RoundedRectangleBorder(borderRadius: AppSpacing.roundedMd),
                      ),
                      onPressed: _handleAppleSignIn,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.md),

              // Guest Explore Button
              AppButton(
                text: 'Continue as Guest',
                variant: ButtonVariant.ghost,
                onPressed: _handleGuestMode,
              ),

              const SizedBox(height: AppSpacing.lg),

              // Register Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Don\'t have an account? ', style: TextStyle(color: AppColors.neutral700)),
                  GestureDetector(
                    onTap: () => context.push(RoutePaths.register),
                    child: const Text(
                      'Sign Up',
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
    );
  }
}
