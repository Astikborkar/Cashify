class ReferredFriend {
  final String name;
  final String deviceSold;
  final double bonusEarned;
  final String date;
  final bool isCompleted;

  const ReferredFriend({
    required this.name,
    required this.deviceSold,
    required this.bonusEarned,
    required this.date,
    required this.isCompleted,
  });
}

class ReferralData {
  final String referralCode;
  final String referralLink;
  final double totalCashEarned;
  final int totalFriendsInvited;
  final int completedSales;
  final int leaderboardRank;
  final List<ReferredFriend> friendsList;

  const ReferralData({
    required this.referralCode,
    required this.referralLink,
    required this.totalCashEarned,
    required this.totalFriendsInvited,
    required this.completedSales,
    required this.leaderboardRank,
    required this.friendsList,
  });
}
