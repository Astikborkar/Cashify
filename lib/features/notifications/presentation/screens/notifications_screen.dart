import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../domain/models/app_notification_model.dart';
import '../providers/notifications_provider.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  NotificationCategory _selectedCategory = NotificationCategory.all;

  @override
  Widget build(BuildContext context) {
    final notifications = ref.watch(notificationsNotifierProvider);

    final filteredList = notifications.where((n) {
      if (_selectedCategory == NotificationCategory.all) return true;
      return n.category == _selectedCategory;
    }).toList();

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Notifications',
        actions: [
          TextButton(
            onPressed: () {
              ref.read(notificationsNotifierProvider.notifier).markAllAsRead();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All notifications marked as read')),
              );
            },
            child: const Text(
              'Mark all read',
              style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 13),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Tabs
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
            child: Row(
              children: [
                _CategoryFilterChip(
                  label: 'All',
                  isSelected: _selectedCategory == NotificationCategory.all,
                  onSelected: () => setState(() => _selectedCategory = NotificationCategory.all),
                ),
                const SizedBox(width: 8),
                _CategoryFilterChip(
                  label: 'Orders',
                  isSelected: _selectedCategory == NotificationCategory.orders,
                  onSelected: () => setState(() => _selectedCategory = NotificationCategory.orders),
                ),
                const SizedBox(width: 8),
                _CategoryFilterChip(
                  label: 'Offers & Promos',
                  isSelected: _selectedCategory == NotificationCategory.promos,
                  onSelected: () => setState(() => _selectedCategory = NotificationCategory.promos),
                ),
                const SizedBox(width: 8),
                _CategoryFilterChip(
                  label: 'Wallet & Payouts',
                  isSelected: _selectedCategory == NotificationCategory.wallet,
                  onSelected: () => setState(() => _selectedCategory = NotificationCategory.wallet),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          Expanded(
            child: filteredList.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.notifications_off_outlined, size: 56, color: AppColors.neutral400),
                        SizedBox(height: AppSpacing.md),
                        Text('No notifications found', style: TextStyle(color: AppColors.neutral600, fontSize: 15)),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: AppSpacing.screenPadding,
                    itemCount: filteredList.length,
                    separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
                    itemBuilder: (context, index) {
                      final item = filteredList[index];
                      return Dismissible(
                        key: Key(item.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          decoration: BoxDecoration(
                            color: AppColors.error,
                            borderRadius: BorderRadius.circular(AppSpacing.cardRadiusSm),
                          ),
                          child: const Icon(Icons.delete_outline_rounded, color: Colors.white),
                        ),
                        onDismissed: (_) {
                          ref.read(notificationsNotifierProvider.notifier).clearNotification(item.id);
                        },
                        child: AppCard(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          onTap: () {
                            ref.read(notificationsNotifierProvider.notifier).markAsRead(item.id);
                            if (item.actionRoute != null && item.actionRoute!.isNotEmpty) {
                              context.push(item.actionRoute!);
                            }
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Notification Category Icon
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: _getCategoryColor(item.category).withAlpha(25),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  _getCategoryIcon(item.category),
                                  color: _getCategoryColor(item.category),
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: AppSpacing.md),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            item.title,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: item.isRead ? FontWeight.w600 : FontWeight.w800,
                                              color: AppColors.neutral900,
                                            ),
                                          ),
                                        ),
                                        if (!item.isRead)
                                          Container(
                                            width: 8,
                                            height: 8,
                                            margin: const EdgeInsets.only(left: 6),
                                            decoration: const BoxDecoration(
                                              color: AppColors.primary,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      item.message,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: item.isRead ? AppColors.neutral600 : AppColors.neutral800,
                                        height: 1.4,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      _formatTimeAgo(item.timestamp),
                                      style: const TextStyle(fontSize: 10, color: AppColors.neutral400),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(NotificationCategory category) {
    switch (category) {
      case NotificationCategory.orders:
        return Icons.local_shipping_outlined;
      case NotificationCategory.promos:
        return Icons.local_offer_outlined;
      case NotificationCategory.wallet:
        return Icons.account_balance_wallet_outlined;
      case NotificationCategory.all:
        return Icons.notifications_none_outlined;
    }
  }

  Color _getCategoryColor(NotificationCategory category) {
    switch (category) {
      case NotificationCategory.orders:
        return AppColors.primary;
      case NotificationCategory.promos:
        return AppColors.secondaryDark;
      case NotificationCategory.wallet:
        return AppColors.success;
      case NotificationCategory.all:
        return AppColors.neutral700;
    }
  }

  String _formatTimeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}

class _CategoryFilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onSelected;

  const _CategoryFilterChip({
    required this.label,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: AppColors.primaryLight,
      labelStyle: TextStyle(
        fontSize: 12,
        color: isSelected ? AppColors.primaryDark : AppColors.neutral700,
        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
      ),
      onSelected: (_) => onSelected(),
    );
  }
}
