import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/badge_pill.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../domain/models/wallet_transaction_model.dart';
import '../providers/wallet_provider.dart';

class WalletScreen extends ConsumerStatefulWidget {
  const WalletScreen({super.key});

  @override
  ConsumerState<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends ConsumerState<WalletScreen> {
  int _selectedFilterIndex = 0;
  final _filterOptions = ['All Transactions', 'Credits', 'Withdrawals'];

  void _showWithdrawalBottomSheet(BuildContext context, double maxBalance) {
    int selectedWithdrawType = 0; // 0: UPI, 1: Bank
    final upiController = TextEditingController(text: 'rahul@okaxis');
    final amountController = TextEditingController(text: maxBalance.toInt().toString());
    final accountController = TextEditingController(text: '50100481920194');
    final ifscController = TextEditingController(text: 'HDFC0001292');
    bool isProcessing = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.cardRadiusLg)),
      ),
      builder: (bottomSheetContext) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: AppSpacing.md,
                right: AppSpacing.md,
                top: AppSpacing.lg,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + AppSpacing.xl,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Instant Payout Withdrawal',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(bottomSheetContext),
                      ),
                    ],
                  ),
                  const Text(
                    'Direct IMPS credit to your account within 60 seconds.',
                    style: TextStyle(fontSize: 13, color: AppColors.neutral600),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Method Toggle
                  Row(
                    children: [
                      Expanded(
                        child: ChoiceChip(
                          label: const Center(child: Text('UPI ID (Instant)')),
                          selected: selectedWithdrawType == 0,
                          selectedColor: AppColors.primaryLight,
                          labelStyle: TextStyle(
                            color: selectedWithdrawType == 0 ? AppColors.primaryDark : AppColors.neutral700,
                            fontWeight: FontWeight.w700,
                          ),
                          onSelected: (_) => setModalState(() => selectedWithdrawType = 0),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: ChoiceChip(
                          label: const Center(child: Text('Bank Transfer (IMPS)')),
                          selected: selectedWithdrawType == 1,
                          selectedColor: AppColors.primaryLight,
                          labelStyle: TextStyle(
                            color: selectedWithdrawType == 1 ? AppColors.primaryDark : AppColors.neutral700,
                            fontWeight: FontWeight.w700,
                          ),
                          onSelected: (_) => setModalState(() => selectedWithdrawType = 1),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.md),

                  AppTextField(
                    label: 'Withdrawal Amount',
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    prefixIcon: const Icon(Icons.currency_rupee_rounded, size: 20),
                    helperText: 'Available to withdraw: ${CurrencyFormatter.format(maxBalance)}',
                  ),

                  const SizedBox(height: AppSpacing.sm),

                  if (selectedWithdrawType == 0) ...[
                    AppTextField(
                      label: 'UPI ID / VPA',
                      controller: upiController,
                      prefixIcon: const Icon(Icons.qr_code_rounded, size: 20),
                      helperText: 'e.g., yourname@okhdfcbank, mobile@paytm',
                    ),
                  ] else ...[
                    AppTextField(
                      label: 'Bank Account Number',
                      controller: accountController,
                      keyboardType: TextInputType.number,
                      prefixIcon: const Icon(Icons.account_balance_outlined, size: 20),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    AppTextField(
                      label: 'IFSC Code',
                      controller: ifscController,
                      textCapitalization: TextCapitalization.characters,
                      prefixIcon: const Icon(Icons.pin_outlined, size: 20),
                    ),
                  ],

                  const SizedBox(height: AppSpacing.lg),

                  AppButton(
                    text: 'Confirm & Transfer Now',
                    isLoading: isProcessing,
                    onPressed: () async {
                      final enteredAmount = double.tryParse(amountController.text) ?? 0;
                      if (enteredAmount <= 0 || enteredAmount > maxBalance) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please enter a valid amount within available balance.')),
                        );
                        return;
                      }

                      setModalState(() => isProcessing = true);
                      bool ok = false;
                      if (selectedWithdrawType == 0) {
                        ok = await ref.read(walletNotifierProvider.notifier).withdrawToUpi(
                              amount: enteredAmount,
                              upiId: upiController.text.trim(),
                            );
                      } else {
                        ok = await ref.read(walletNotifierProvider.notifier).withdrawToBank(
                              amount: enteredAmount,
                              accountNo: accountController.text.trim(),
                              ifsc: ifscController.text.trim(),
                            );
                      }

                      if (mounted) {
                        Navigator.pop(bottomSheetContext);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: ok ? AppColors.success : AppColors.error,
                            content: Text(ok
                                ? '₹${enteredAmount.toStringAsFixed(0)} IMPS payout initiated successfully!'
                                : 'Failed to process withdrawal.'),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final walletState = ref.watch(walletNotifierProvider);
    final data = walletState.data;

    final filteredTxns = data.transactions.where((t) {
      if (_selectedFilterIndex == 1) return t.isCredit;
      if (_selectedFilterIndex == 2) return !t.isCredit;
      return true;
    }).toList();

    return Scaffold(
      appBar: const CustomAppBar(title: 'Cashify Wallet & Payouts'),
      body: SingleChildScrollView(
        padding: AppSpacing.screenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Main Balance Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primaryDark, AppColors.primary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(AppSpacing.cardRadiusLg),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withAlpha(76),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Balance',
                        style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w500),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.bolt_rounded, size: 14, color: AppColors.secondary),
                            SizedBox(width: 4),
                            Text(
                              'Instant IMPS Active',
                              style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    CurrencyFormatter.format(data.totalBalance),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  const Divider(color: Colors.white24, height: 1),
                  const SizedBox(height: AppSpacing.sm),

                  // Balance Subdivisions
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Cashback Balance', style: TextStyle(color: Colors.white70, fontSize: 11)),
                            const SizedBox(height: 2),
                            Text(
                              CurrencyFormatter.format(data.cashbackBalance),
                              style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Referral Rewards', style: TextStyle(color: Colors.white70, fontSize: 11)),
                            const SizedBox(height: 2),
                            Text(
                              CurrencyFormatter.format(data.referralBalance),
                              style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Withdraw Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondary,
                        foregroundColor: AppColors.neutral900,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      icon: const Icon(Icons.arrow_upward_rounded, size: 18),
                      label: const Text(
                        'Withdraw to Bank / UPI',
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                      ),
                      onPressed: () => _showWithdrawalBottomSheet(context, data.totalBalance),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.xl),

            // Passbook & Filter Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Transaction History',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                ),
                Text(
                  '${data.transactions.length} entries',
                  style: const TextStyle(fontSize: 12, color: AppColors.neutral500),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),

            // Filter Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(_filterOptions.length, (idx) {
                  final isSelected = _selectedFilterIndex == idx;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(_filterOptions[idx]),
                      selected: isSelected,
                      selectedColor: AppColors.primaryLight,
                      labelStyle: TextStyle(
                        fontSize: 12,
                        color: isSelected ? AppColors.primaryDark : AppColors.neutral700,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      ),
                      onSelected: (_) => setState(() => _selectedFilterIndex = idx),
                    ),
                  );
                }),
              ),
            ),

            const SizedBox(height: AppSpacing.md),

            // Transactions List
            if (filteredTxns.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Center(
                  child: Text('No transactions found in this category.'),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredTxns.length,
                separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
                itemBuilder: (context, index) {
                  final t = filteredTxns[index];
                  return AppCard(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: t.isCredit ? AppColors.success.withAlpha(25) : AppColors.error.withAlpha(25),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            t.isCredit ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
                            color: t.isCredit ? AppColors.success : AppColors.error,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                t.title,
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                t.description,
                                style: const TextStyle(fontSize: 12, color: AppColors.neutral600),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Ref: ${t.referenceId}',
                                style: const TextStyle(fontSize: 10, color: AppColors.neutral500),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${t.isCredit ? '+' : '-'}${CurrencyFormatter.format(t.amount)}',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: t.isCredit ? AppColors.success : AppColors.error,
                              ),
                            ),
                            const SizedBox(height: 4),
                            BadgePill(
                              text: t.status == TransactionStatus.success ? 'Success' : 'Pending',
                              type: t.status == TransactionStatus.success ? BadgeType.success : BadgeType.warning,
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),

            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }
}
