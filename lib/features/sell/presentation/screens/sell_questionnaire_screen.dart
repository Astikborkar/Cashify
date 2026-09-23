import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../routes/route_paths.dart';
import '../../domain/models/condition_assessment.dart';
import '../providers/sell_flow_provider.dart';

/// Screen 4 of Sell Flow: Multi-point cosmetic and functional wear questionnaire.
class SellQuestionnaireScreen extends ConsumerStatefulWidget {
  const SellQuestionnaireScreen({super.key});

  @override
  ConsumerState<SellQuestionnaireScreen> createState() => _SellQuestionnaireScreenState();
}

class _SellQuestionnaireScreenState extends ConsumerState<SellQuestionnaireScreen> {
  ScreenCondition _screenCondition = ScreenCondition.minorScratches;
  BodyCondition _bodyCondition = BodyCondition.flawless;
  final Set<String> _selectedIssues = {};

  void _proceedToDiagnostics() {
    final current = ref.read(sellFlowNotifierProvider).assessment;
    ref.read(sellFlowNotifierProvider.notifier).updateAssessment(
      current.copyWith(
        screen: _screenCondition,
        body: _bodyCondition,
        functionalIssues: _selectedIssues,
      ),
    );
    context.push(RoutePaths.sellDiagnostics);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Condition Assessment'),
      body: SingleChildScrollView(
        padding: AppSpacing.screenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Screen Condition
            const Text(
              '1. What is your screen condition?',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: AppSpacing.sm),
            _buildSelectableCard(
              title: 'Flawless',
              subtitle: 'Zero visible scratches or hairline marks',
              isSelected: _screenCondition == ScreenCondition.flawless,
              onTap: () => setState(() => _screenCondition = ScreenCondition.flawless),
            ),
            const SizedBox(height: AppSpacing.xs),
            _buildSelectableCard(
              title: 'Minor Scratches',
              subtitle: '1-2 faint scratches visible under light, no deep marks',
              isSelected: _screenCondition == ScreenCondition.minorScratches,
              onTap: () => setState(() => _screenCondition = ScreenCondition.minorScratches),
            ),
            const SizedBox(height: AppSpacing.xs),
            _buildSelectableCard(
              title: 'Heavy Scratches',
              subtitle: 'Multiple prominent scratches or rough glass surface',
              isSelected: _screenCondition == ScreenCondition.heavyScratches,
              onTap: () => setState(() => _screenCondition = ScreenCondition.heavyScratches),
            ),
            const SizedBox(height: AppSpacing.xs),
            _buildSelectableCard(
              title: 'Cracked Glass or Display Lines',
              subtitle: 'Front glass broken, dead lines or touch unresponsive',
              isSelected: _screenCondition == ScreenCondition.crackedGlass,
              onTap: () => setState(() => _screenCondition = ScreenCondition.crackedGlass),
            ),

            const SizedBox(height: AppSpacing.lg),

            // Body Condition
            const Text(
              '2. What is your body & chassis condition?',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: AppSpacing.sm),
            _buildSelectableCard(
              title: 'Flawless / Like New',
              subtitle: 'Zero dents, paint chips, or scuffs on frame',
              isSelected: _bodyCondition == BodyCondition.flawless,
              onTap: () => setState(() => _bodyCondition = BodyCondition.flawless),
            ),
            const SizedBox(height: AppSpacing.xs),
            _buildSelectableCard(
              title: 'Minor Scratches',
              subtitle: 'Hairline pocket wear around edges or charging port',
              isSelected: _bodyCondition == BodyCondition.minorScratches,
              onTap: () => setState(() => _bodyCondition = BodyCondition.minorScratches),
            ),
            const SizedBox(height: AppSpacing.xs),
            _buildSelectableCard(
              title: 'Multiple Dents / Scuffs',
              subtitle: 'Visible drop impact dents on corners',
              isSelected: _bodyCondition == BodyCondition.heavyDents,
              onTap: () => setState(() => _bodyCondition = BodyCondition.heavyDents),
            ),

            const SizedBox(height: AppSpacing.lg),

            // Functional Faults
            const Text(
              '3. Do any of these functional issues apply?',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: AppSpacing.sm),
            _buildIssueCheckbox('battery_degraded', 'Battery Health degraded (<80%)', Icons.battery_alert_rounded),
            _buildIssueCheckbox('camera_faulty', 'Front or Rear Camera malfunctioning', Icons.no_photography_rounded),
            _buildIssueCheckbox('speaker_mic_issue', 'Earpiece / Loudspeaker / Mic defective', Icons.volume_off_rounded),
            _buildIssueCheckbox('biometrics_failing', 'Face ID / Fingerprint sensor failing', Icons.fingerprint_rounded),

            const SizedBox(height: AppSpacing.xl),

            AppButton(
              text: 'Run Hardware Diagnostics →',
              onPressed: _proceedToDiagnostics,
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectableCard({
    required String title,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return AppCard(
      isSelected: isSelected,
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: isSelected ? AppColors.primaryDark : AppColors.neutral900,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 12, color: AppColors.neutral500),
                ),
              ],
            ),
          ),
          Icon(
            isSelected ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
            color: isSelected ? AppColors.primary : AppColors.neutral300,
            size: 22,
          ),
        ],
      ),
    );
  }

  Widget _buildIssueCheckbox(String key, String title, IconData icon) {
    final isChecked = _selectedIssues.contains(key);
    return CheckboxListTile(
      value: isChecked,
      activeColor: AppColors.primary,
      secondary: Icon(icon, color: isChecked ? AppColors.error : AppColors.neutral500, size: 22),
      title: Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
      contentPadding: EdgeInsets.zero,
      onChanged: (val) {
        setState(() {
          if (val ?? false) {
            _selectedIssues.add(key);
          } else {
            _selectedIssues.remove(key);
          }
        });
      },
    );
  }
}
