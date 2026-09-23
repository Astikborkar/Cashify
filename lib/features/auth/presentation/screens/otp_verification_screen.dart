import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../routes/route_paths.dart';
import '../providers/auth_provider.dart';

/// 6-digit OTP verification screen with countdown timer and auto-fill.
class OtpVerificationScreen extends ConsumerStatefulWidget {
  final String phone;

  const OtpVerificationScreen({
    super.key,
    required this.phone,
  });

  @override
  ConsumerState<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends ConsumerState<OtpVerificationScreen> {
  static const int _initialTimer = 30;
  int _secondsRemaining = _initialTimer;
  Timer? _timer;

  final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _secondsRemaining = _initialTimer);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        timer.cancel();
      }
    });
  }

  String get _enteredOtp => _controllers.map((c) => c.text).join();

  Future<void> _verifyOtp() async {
    final otp = _enteredOtp;
    if (otp.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter all 6 digits of the OTP')),
      );
      return;
    }

    final success = await ref.read(authNotifierProvider.notifier).verifyOtp(widget.phone, otp);
    if (!mounted) return;

    if (success) {
      context.go(RoutePaths.home);
    } else {
      final error = ref.read(authNotifierProvider).errorMessage ?? 'Verification failed';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: AppColors.error),
      );
    }
  }

  Future<void> _resendOtp() async {
    if (_secondsRemaining == 0) {
      final success = await ref.read(authNotifierProvider.notifier).requestOtp(widget.phone);
      if (success) {
        _startTimer();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('A new OTP has been sent to your mobile number.')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Verify Mobile Number'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: AppSpacing.lg),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.mark_email_read_rounded, color: AppColors.primaryDark, size: 36),
              ),
              const SizedBox(height: AppSpacing.lg),
              const Text(
                'Enter Verification Code',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: const TextStyle(fontSize: 14, color: AppColors.neutral700),
                  children: [
                    const TextSpan(text: 'We have sent a 6-digit code to\n'),
                    TextSpan(
                      text: '+91 ${widget.phone} ',
                      style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.neutral900),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () => context.pop(),
                child: const Text('Edit Phone Number', style: TextStyle(fontWeight: FontWeight.w600)),
              ),
              const SizedBox(height: AppSpacing.xl),

              // 6-digit OTP Box Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (index) {
                  return SizedBox(
                    width: 48,
                    height: 56,
                    child: TextField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        counterText: '',
                        contentPadding: EdgeInsets.zero,
                        filled: true,
                        fillColor: _controllers[index].text.isNotEmpty
                            ? AppColors.primaryLight
                            : AppColors.neutral50,
                        border: OutlineInputBorder(
                          borderRadius: AppSpacing.roundedMd,
                          borderSide: const BorderSide(color: AppColors.borderLight),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: AppSpacing.roundedMd,
                          borderSide: const BorderSide(color: AppColors.primary, width: 2),
                        ),
                      ),
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          if (index < 5) {
                            _focusNodes[index + 1].requestFocus();
                          } else {
                            _focusNodes[index].unfocus();
                            _verifyOtp();
                          }
                        } else {
                          if (index > 0) {
                            _focusNodes[index - 1].requestFocus();
                          }
                        }
                      },
                    ),
                  );
                }),
              ),

              const SizedBox(height: AppSpacing.xl),

              // Resend Timer Row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Didn\'t receive code? ', style: TextStyle(color: AppColors.neutral700)),
                  if (_secondsRemaining > 0)
                    Text(
                      'Resend in ${_secondsRemaining}s',
                      style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.neutral900),
                    )
                  else
                    GestureDetector(
                      onTap: _resendOtp,
                      child: const Text(
                        'Resend OTP',
                        style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.primaryDark),
                      ),
                    ),
                ],
              ),

              const SizedBox(height: AppSpacing.xl),

              // Submit Button
              AppButton(
                text: 'Verify & Login',
                isLoading: authState.isLoading,
                onPressed: _verifyOtp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
