import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/custom_app_bar.dart';

/// Password recovery screen requesting registered email to send reset instructions.
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _linkSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);
      await Future.delayed(const Duration(milliseconds: 700));
      if (mounted) {
        setState(() {
          _isLoading = false;
          _linkSent = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Reset Password'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.screenPadding,
          child: _linkSent ? _buildSuccessView() : _buildFormView(),
        ),
      ),
    );
  }

  Widget _buildFormView() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.lg),
          const Text(
            'Forgot Password?',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 4),
          const Text(
            'Enter your registered email address and we will send you a password reset link.',
            style: TextStyle(fontSize: 14, color: AppColors.neutral700),
          ),
          const SizedBox(height: AppSpacing.xl),

          AppTextField(
            label: 'Registered Email',
            hint: 'rahul@example.com',
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            prefix: const Icon(Icons.email_outlined, size: 20, color: AppColors.neutral500),
            validator: Validators.validateEmail,
          ),

          const SizedBox(height: AppSpacing.xl),

          AppButton(
            text: 'Send Reset Link',
            isLoading: _isLoading,
            onPressed: _handleSubmit,
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessView() {
    return Column(
      children: [
        const SizedBox(height: AppSpacing.xxl),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check_circle_rounded, color: AppColors.primaryDark, size: 48),
        ),
        const SizedBox(height: AppSpacing.lg),
        const Text(
          'Reset Link Sent!',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        Text(
          'We have sent password reset instructions to ${_emailController.text.trim()}. Please check your inbox.',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 14, color: AppColors.neutral700),
        ),
        const SizedBox(height: AppSpacing.xl),
        AppButton(
          text: 'Back to Login',
          onPressed: () => context.pop(),
        ),
      ],
    );
  }
}
