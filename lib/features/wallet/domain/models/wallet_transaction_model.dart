enum TransactionType {
  sellPayout,
  referralBonus,
  cashback,
  withdrawalBank,
  withdrawalUpi,
}

enum TransactionStatus {
  success,
  pending,
  failed,
}

class WalletTransaction {
  final String id;
  final String title;
  final String description;
  final double amount;
  final bool isCredit;
  final DateTime timestamp;
  final TransactionType type;
  final TransactionStatus status;
  final String referenceId;

  const WalletTransaction({
    required this.id,
    required this.title,
    required this.description,
    required this.amount,
    required this.isCredit,
    required this.timestamp,
    required this.type,
    required this.status,
    required this.referenceId,
  });
}

class WalletData {
  final double totalBalance;
  final double cashbackBalance;
  final double referralBalance;
  final double pendingPayout;
  final List<WalletTransaction> transactions;

  const WalletData({
    required this.totalBalance,
    required this.cashbackBalance,
    required this.referralBalance,
    required this.pendingPayout,
    required this.transactions,
  });
}
