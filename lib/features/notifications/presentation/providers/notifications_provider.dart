import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/app_notification_model.dart';

class NotificationsNotifier extends StateNotifier<List<AppNotificationItem>> {
  NotificationsNotifier()
      : super([
          AppNotificationItem(
            id: 'NOTIF-1',
            title: 'Technician Assigned! 🛵',
            message: 'Rajesh Kumar has been assigned for doorstep repair order #REP-84920. Expected ETA: 25 mins.',
            timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
            category: NotificationCategory.orders,
            isRead: false,
            actionRoute: '/repair/tracking/REP-84920',
          ),
          AppNotificationItem(
            id: 'NOTIF-2',
            title: '₹27,400 Credited to Wallet! 💰',
            message: 'Your sell order #SO-77491 valuation payout is ready in your Cashify Wallet. Tap to withdraw.',
            timestamp: DateTime.now().subtract(const Duration(hours: 3)),
            category: NotificationCategory.wallet,
            isRead: false,
            actionRoute: '/wallet',
          ),
          AppNotificationItem(
            id: 'NOTIF-3',
            title: 'Flash Sale: iPhone 14 Pro ₹44,999 🔥',
            message: 'Superb condition certified refurbished iPhone 14 Pro units back in stock with 1-year warranty.',
            timestamp: DateTime.now().subtract(const Duration(hours: 8)),
            category: NotificationCategory.promos,
            isRead: true,
            actionRoute: '/buy',
          ),
          AppNotificationItem(
            id: 'NOTIF-4',
            title: 'Referral Reward Unlocked! 🎁',
            message: 'Your friend Priya completed their phone sell! ₹500 bonus added to your referral balance.',
            timestamp: DateTime.now().subtract(const Duration(days: 1)),
            category: NotificationCategory.wallet,
            isRead: true,
            actionRoute: '/referral',
          ),
          AppNotificationItem(
            id: 'NOTIF-5',
            title: 'Upcoming Diagnostic Tip 💡',
            message: 'Ensure your smartphone screen is free of thick screen guards before running the automated touch test.',
            timestamp: DateTime.now().subtract(const Duration(days: 2)),
            category: NotificationCategory.orders,
            isRead: true,
            actionRoute: null,
          ),
        ]);

  void markAsRead(String id) {
    state = state.map((item) {
      if (item.id == id) {
        return item.copyWith(isRead: true);
      }
      return item;
    }).toList();
  }

  void markAllAsRead() {
    state = state.map((item) => item.copyWith(isRead: true)).toList();
  }

  void clearNotification(String id) {
    state = state.where((item) => item.id != id).toList();
  }
}

final notificationsNotifierProvider =
    StateNotifierProvider<NotificationsNotifier, List<AppNotificationItem>>((ref) {
  return NotificationsNotifier();
});

final unreadNotificationsCountProvider = Provider<int>((ref) {
  final notifs = ref.watch(notificationsNotifierProvider);
  return notifs.where((n) => !n.isRead).length;
});
