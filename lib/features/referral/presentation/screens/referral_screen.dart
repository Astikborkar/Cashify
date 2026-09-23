import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/badge_pill.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../providers/referral_provider.dart';

class ReferralScreen extends ConsumerWidget {
  const ReferralScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final referralData = ref.watch(referralNotifierProvider);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Refer & Earn'),
      body: SingleChildScrollView(
        padding: AppSpacing.screenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Referral Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.secondaryDark, AppColors.secondary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(AppSpacing.cardRadiusLg),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.secondary.withAlpha(76),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Icon(Icons.card_giftcard_rounded, size: 48, color: AppColors.neutral900),
                  const SizedBox(height: AppSpacing.sm),
                  const Text(
                    'Earn ₹500 For Every Friend!',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: AppColors.neutral900,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'When your friend sells their old smartphone or books a repair on Cashify, you get ₹500 in your wallet instantly.',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.neutral800,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Referral Code Container
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.neutral300),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'YOUR REFERRAL CODE',
                              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.neutral500),
                            ),
                            Text(
                              referralData.referralCode,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.2,
                                color: AppColors.neutral900,
                              ),
                            ),
                          ],
                        ),
                        TextButton.icon(
                          style: TextButton.styleFrom(
                            backgroundColor: AppColors.primaryLight,
                            foregroundColor: AppColors.primaryDark,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          icon: const Icon(Icons.copy_rounded, size: 16),
                          label: const Text('COPY', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12)),
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: referralData.referralCode));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Referral code copied to clipboard!'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppSpacing.md),

                  AppButton(
                    text: 'Share Invite Link via WhatsApp',
                    icon: Icons.share_rounded,
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Sharing invite link: ${referralData.referralLink}'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            // Performance Metrics Cards
            Row(
              children: [
                Expanded(
                  child: AppCard(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Total Cash Earned', style: TextStyle(fontSize: 11, color: AppColors.neutral500)),
                        const SizedBox(height: 4),
                        Text(
                          CurrencyFormatter.format(referralData.totalCashEarned),
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.success),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: AppCard(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Completed Sales', style: TextStyle(fontSize: 11, color: AppColors.neutral500)),
                        const SizedBox(height: 4),
                        Text(
                          '${referralData.completedSales} Friends',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.primary),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: AppCard(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('City Rank', style: TextStyle(fontSize: 11, color: AppColors.neutral500)),
                        const SizedBox(height: 4),
                        Text(
                          '#${referralData.leaderboardRank}',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.secondaryDark),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.lg),

            // How It Works Steps
            const Text('How It Works', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
            const SizedBox(height: AppSpacing.sm),
            AppCard(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                children: [
                  _StepTile(
                    number: '1',
                    title: 'Invite Friends',
                    description: 'Share your code or link with friends planning to upgrade devices.',
                  ),
                  const Divider(height: 24),
                  _StepTile(
                    number: '2',
                    title: 'Friend Sells Old Phone',
                    description: 'Your friend finishes free doorstep diagnostics and accepts the price quote.',
                  ),
                  const Divider(height: 24),
                  _StepTile(
                    number: '3',
                    title: 'Get ₹500 in Wallet',
                    description: 'Both of you get rewarded instantly upon successful pickup and verification.',
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            // Invited Friends Activity List
            const Text('Your Referrals', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
            const SizedBox(height: AppSpacing.sm),

            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: referralData.friendsList.length,
              separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.xs),
              itemBuilder: (context, index) {
                final friend = referralData.friendsList[index];
                return AppCard(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: AppColors.primaryLight,
                        child: Text(
                          friend.name[0],
                          style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.primaryDark),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(friend.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                            const SizedBox(height: 2),
                            Text(
                              '${friend.deviceSold} • ${friend.date}',
                              style: const TextStyle(fontSize: 12, color: AppColors.neutral500),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '+${CurrencyFormatter.format(friend.bonusEarned)}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: friend.isCompleted ? AppColors.success : AppColors.neutral500,
                            ),
                          ),
                          const SizedBox(height: 2),
                          BadgePill(
                            text: friend.isCompleted ? 'Credited' : 'Pending',
                            type: friend.isCompleted ? BadgeType.success : BadgeType.warning,
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

class _StepTile extends StatelessWidget {
  final String number;
  final String title;
  final String description;

  const _StepTile({
    required this.number,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 14,
          backgroundColor: AppColors.primary,
          child: Text(
            number,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Colors.white),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
              const SizedBox(height: 2),
              Text(description, style: const TextStyle(fontSize: 12, color: AppColors.neutral600)),
            ],
          ),
        ),
      ],
    );
  }
}
