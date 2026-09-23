import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../routes/route_paths.dart';
import '../../domain/models/diagnostic_test_item.dart';
import '../providers/sell_flow_provider.dart';

/// Screen 5 of Sell Flow: Automated & interactive hardware diagnostic test runner.
class SellDiagnosticsScreen extends ConsumerStatefulWidget {
  const SellDiagnosticsScreen({super.key});

  @override
  ConsumerState<SellDiagnosticsScreen> createState() => _SellDiagnosticsScreenState();
}

class _SellDiagnosticsScreenState extends ConsumerState<SellDiagnosticsScreen> {
  bool _isRunningAll = false;

  Future<void> _runAllTests() async {
    setState(() => _isRunningAll = true);
    final notifier = ref.read(sellFlowNotifierProvider.notifier);
    final tests = ref.read(sellFlowNotifierProvider).diagnosticTests;

    for (final test in tests) {
      notifier.updateDiagnosticResult(test.key, DiagnosticStatus.running);
      await Future.delayed(const Duration(milliseconds: 350));
      notifier.updateDiagnosticResult(test.key, DiagnosticStatus.passed);
    }

    if (mounted) {
      setState(() => _isRunningAll = false);
    }
  }

  void _openTouchGridModal() {
    showDialog(
      context: context,
      builder: (ctx) => const _TouchTestDialog(),
    ).then((passed) {
      if (passed == true) {
        ref.read(sellFlowNotifierProvider.notifier).updateDiagnosticResult('touch_matrix', DiagnosticStatus.passed);
      }
    });
  }

  void _openColorBurnModal() {
    showDialog(
      context: context,
      builder: (ctx) => const _ColorBurnTestDialog(),
    ).then((passed) {
      if (passed == true) {
        ref.read(sellFlowNotifierProvider.notifier).updateDiagnosticResult('dead_pixels', DiagnosticStatus.passed);
      }
    });
  }

  Future<void> _calculateQuote() async {
    final notifier = ref.read(sellFlowNotifierProvider.notifier);
    await notifier.computeAiQuote();
    if (mounted) {
      context.push(RoutePaths.sellQuoteResult);
    }
  }

  @override
  Widget build(BuildContext context) {
    final sellState = ref.watch(sellFlowNotifierProvider);
    final tests = sellState.diagnosticTests;

    final passedCount = tests.where((t) => t.status == DiagnosticStatus.passed).length;
    final totalCount = tests.length;
    final healthScore = totalCount > 0 ? ((passedCount / totalCount) * 100).round() : 0;

    return Scaffold(
      appBar: const CustomAppBar(title: 'Hardware Diagnostics'),
      body: SingleChildScrollView(
        padding: AppSpacing.screenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Diagnostics Summary Card with Health Score
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0039CB), Color(0xFF2962FF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: AppSpacing.roundedLg,
              ),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '$healthScore%',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppColors.secondaryDark,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Device Health Score',
                          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                        Text(
                          '$passedCount of $totalCount tests passed successfully',
                          style: const TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.md),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Diagnostic Checklist',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                TextButton.icon(
                  icon: const Icon(Icons.play_arrow_rounded, size: 18),
                  label: const Text('Auto Run All'),
                  onPressed: _isRunningAll ? null : _runAllTests,
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.xs),

            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: tests.length,
              separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.xs),
              itemBuilder: (context, index) {
                final test = tests[index];
                return AppCard(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  onTap: () {
                    if (test.key == 'touch_matrix') {
                      _openTouchGridModal();
                    } else if (test.key == 'dead_pixels') {
                      _openColorBurnModal();
                    } else {
                      ref.read(sellFlowNotifierProvider.notifier).updateDiagnosticResult(
                        test.key,
                        test.status == DiagnosticStatus.passed ? DiagnosticStatus.pending : DiagnosticStatus.passed,
                      );
                    }
                  },
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: test.status == DiagnosticStatus.passed
                              ? AppColors.primaryLight
                              : AppColors.neutral100,
                          borderRadius: AppSpacing.roundedSm,
                        ),
                        child: Icon(
                          test.icon,
                          color: test.status == DiagnosticStatus.passed
                              ? AppColors.primaryDark
                              : AppColors.neutral700,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              test.name,
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                            ),
                            Text(
                              test.description,
                              style: const TextStyle(fontSize: 11, color: AppColors.neutral500),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      _buildStatusIndicator(test.status),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: AppSpacing.xl),

            AppButton(
              text: 'Calculate AI Instant Quote →',
              isLoading: sellState.isCalculating,
              onPressed: _calculateQuote,
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIndicator(DiagnosticStatus status) {
    switch (status) {
      case DiagnosticStatus.passed:
        return const Row(
          children: [
            Icon(Icons.check_circle_rounded, color: AppColors.primaryDark, size: 20),
            SizedBox(width: 4),
            Text('Passed', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primaryDark)),
          ],
        );
      case DiagnosticStatus.failed:
        return const Row(
          children: [
            Icon(Icons.cancel_rounded, color: AppColors.error, size: 20),
            SizedBox(width: 4),
            Text('Failed', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.error)),
          ],
        );
      case DiagnosticStatus.running:
        return const SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
        );
      case DiagnosticStatus.pending:
      case DiagnosticStatus.skipped:
        return const Text('Tap to test', style: TextStyle(fontSize: 12, color: AppColors.secondary, fontWeight: FontWeight.w600));
    }
  }
}

/// Interactive Touch Matrix Test: user touches/swipes tiles to turn them green.
class _TouchTestDialog extends StatefulWidget {
  const _TouchTestDialog();

  @override
  State<_TouchTestDialog> createState() => _TouchTestDialogState();
}

class _TouchTestDialogState extends State<_TouchTestDialog> {
  final Set<int> _touchedTiles = {};
  static const int totalTiles = 24;

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Touch Test: Swipe all tiles', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                  IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context, false)),
                ],
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(AppSpacing.md),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: totalTiles,
                itemBuilder: (context, index) {
                  final isTouched = _touchedTiles.contains(index);
                  return GestureDetector(
                    onPanDown: (_) {
                      setState(() => _touchedTiles.add(index));
                      if (_touchedTiles.length == totalTiles) {
                        Navigator.pop(context, true);
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isTouched ? AppColors.primary : AppColors.neutral100,
                        borderRadius: AppSpacing.roundedSm,
                        border: Border.all(color: isTouched ? AppColors.primaryDark : AppColors.borderLight),
                      ),
                      child: Center(
                        child: Icon(
                          isTouched ? Icons.check : Icons.touch_app_rounded,
                          color: isTouched ? Colors.white : AppColors.neutral500,
                          size: 20,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Screen burn and dead pixel test cycling RGB primary colors.
class _ColorBurnTestDialog extends StatefulWidget {
  const _ColorBurnTestDialog();

  @override
  State<_ColorBurnTestDialog> createState() => _ColorBurnTestDialogState();
}

class _ColorBurnTestDialogState extends State<_ColorBurnTestDialog> {
  int _colorIndex = 0;
  static const colors = [Colors.red, Colors.green, Colors.blue, Colors.white, Colors.black];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_colorIndex < colors.length - 1) {
          setState(() => _colorIndex++);
        } else {
          Navigator.pop(context, true);
        }
      },
      child: Container(
        color: colors[_colorIndex],
        child: const Center(
          child: Text(
            'Tap screen to cycle colors\n(Check for stuck or dead pixels)',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
