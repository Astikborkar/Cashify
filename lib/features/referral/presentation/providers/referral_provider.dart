import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/referral_model.dart';

class ReferralNotifier extends StateNotifier<ReferralData> {
  ReferralNotifier()
      : super(
          const ReferralData(
            referralCode: 'RAHUL500',
            referralLink: 'https://cashify.page.link/RAHUL500',
            totalCashEarned: 2500.0,
            totalFriendsInvited: 8,
            completedSales: 5,
            leaderboardRank: 42,
            friendsList: [
              ReferredFriend(
                name: 'Priya Sharma',
                deviceSold: 'iPhone 12 (128GB)',
                bonusEarned: 500.0,
                date: '20 Sep 2026',
                isCompleted: true,
              ),
              ReferredFriend(
                name: 'Arjun Verma',
                deviceSold: 'OnePlus 9 Pro',
                bonusEarned: 500.0,
                date: '15 Sep 2026',
                isCompleted: true,
              ),
              ReferredFriend(
                name: 'Rohit Gupta',
                deviceSold: 'Samsung S21 FE',
                bonusEarned: 500.0,
                date: '02 Sep 2026',
                isCompleted: true,
              ),
              ReferredFriend(
                name: 'Sneha Patel',
                deviceSold: 'Diagnostic in progress',
                bonusEarned: 500.0,
                date: 'Yesterday',
                isCompleted: false,
              ),
            ],
          ),
        );
}

final referralNotifierProvider = StateNotifierProvider<ReferralNotifier, ReferralData>((ref) {
  return ReferralNotifier();
});
