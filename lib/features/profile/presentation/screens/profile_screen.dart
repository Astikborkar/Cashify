import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../routes/route_paths.dart';
import '../../../notifications/presentation/providers/notifications_provider.dart';
import '../../../referral/presentation/providers/referral_provider.dart';
import '../../../wallet/presentation/providers/wallet_provider.dart';

/// Upgraded User Profile Screen: KYC status, live wallet, orders, addresses, referrals, and Agent 6 support.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final walletState = ref.watch(walletNotifierProvider);
    final referralData = ref.watch(referralNotifierProvider);
    final unreadCount = ref.watch(unreadNotificationsCountProvider);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'My Account',
        showBackButton: false,
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined, color: AppColors.neutral900),
                onPressed: () => context.push(RoutePaths.notifications),
              ),
              if (unreadCount > 0)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                    child: Text(
                      '$unreadCount',
                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w800),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: AppSpacing.screenPadding,
        child: Column(
          children: [
            // User Info Header Card with KYC Verified Badge
            AppCard(
              child: Row(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: AppColors.primaryLight,
                        child: const Icon(Icons.person_rounded, size: 32, color: AppColors.primaryDark),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.verified_rounded, size: 18, color: AppColors.success),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: AppSpacing.md),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Rahul Sharma',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                        SizedBox(height: 2),
                        Text(
                          '+91 98765 43210 • Verified KYC',
                          style: TextStyle(fontSize: 12, color: AppColors.neutral500),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, color: AppColors.neutral700, size: 20),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Edit Profile details.')),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.md),

            // Live Wallet & Referral Teasers
            Row(
              children: [
                Expanded(
                  child: AppCard(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    onTap: () => context.push(RoutePaths.wallet),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.account_balance_wallet_rounded, color: AppColors.primary, size: 22),
                            Icon(Icons.arrow_forward_ios_rounded, size: 12, color: AppColors.neutral400),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        const Text('Cashify Wallet', style: TextStyle(fontSize: 12, color: AppColors.neutral500)),
                        const SizedBox(height: 2),
                        Text(
                          CurrencyFormatter.format(walletState.data.totalBalance),
                          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: AppCard(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    onTap: () => context.push(RoutePaths.referral),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.card_giftcard_rounded, color: AppColors.secondary, size: 22),
                            Icon(Icons.arrow_forward_ios_rounded, size: 12, color: AppColors.neutral400),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        const Text('Refer & Earn', style: TextStyle(fontSize: 12, color: AppColors.neutral500)),
                        const SizedBox(height: 2),
                        Text(
                          CurrencyFormatter.format(referralData.totalCashEarned),
                          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: AppColors.secondaryDark),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.lg),

            // Profile Options Menu
            AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _ProfileTile(
                    icon: Icons.history_rounded,
                    title: 'Orders & Sell History',
                    subtitle: 'Sell, repair, and buy order tracker',
                    onTap: () => context.push(RoutePaths.orders),
                  ),
                  const Divider(height: 1),
                  _ProfileTile(
                    icon: Icons.location_on_outlined,
                    title: 'Saved Addresses',
                    subtitle: 'Manage pickup & delivery locations',
                    onTap: () => context.push(RoutePaths.addresses),
                  ),
                  const Divider(height: 1),
                  _ProfileTile(
                    icon: Icons.account_balance_outlined,
                    title: 'Bank & UPI Accounts',
                    subtitle: 'Manage instant IMPS payout destinations',
                    onTap: () => context.push(RoutePaths.wallet),
                  ),
                  const Divider(height: 1),
                  _ProfileTile(
                    icon: Icons.headset_mic_outlined,
                    title: '24/7 AI Customer Support',
                    subtitle: 'Agent 6 assistant & live specialist chat',
                    onTap: () => context.push(RoutePaths.supportChat),
                  ),
                  const Divider(height: 1),
                  _ProfileTile(
                    icon: Icons.notifications_none_rounded,
                    title: 'Notification Center',
                    subtitle: 'Price drops, technician alerts & promo codes',
                    onTap: () => context.push(RoutePaths.notifications),
                  ),
                  const Divider(height: 1),
                  _ProfileTile(
                    icon: Icons.security_outlined,
                    title: 'Device Diagnostic Health Reports',
                    subtitle: '16 hardware test logs and QC certificates',
                    onTap: () => context.push(RoutePaths.sellDiagnostics),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            // Logout Button
            OutlinedButton.icon(
              icon: const Icon(Icons.logout_rounded, size: 18, color: AppColors.error),
              label: const Text('Log Out', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.w700)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.error),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () => context.go(RoutePaths.login),
            ),

            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ProfileTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: AppColors.primaryLight.withAlpha(128),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: AppColors.primaryDark, size: 20),
      ),
      title: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.neutral500)),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.neutral400),
      onTap: onTap,
    );
  }
}
