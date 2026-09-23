import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/wallet_transaction_model.dart';

class WalletState {
  final bool isLoading;
  final WalletData data;
  final String? error;

  const WalletState({
    this.isLoading = false,
    required this.data,
    this.error,
  });

  WalletState copyWith({
    bool? isLoading,
    WalletData? data,
    String? error,
  }) {
    return WalletState(
      isLoading: isLoading ?? this.isLoading,
      data: data ?? this.data,
      error: error,
    );
  }
}

class WalletNotifier extends StateNotifier<WalletState> {
  WalletNotifier()
      : super(
          WalletState(
            data: WalletData(
              totalBalance: 3250.0,
              cashbackBalance: 1250.0,
              referralBalance: 2000.0,
              pendingPayout: 0.0,
              transactions: [
                WalletTransaction(
                  id: 'TXN-90812',
                  title: 'iPhone 13 Resale Payout',
                  description: 'Credited directly from Sell Order #SO-77491',
                  amount: 27400.0,
                  isCredit: true,
                  timestamp: DateTime.now().subtract(const Duration(days: 2)),
                  type: TransactionType.sellPayout,
                  status: TransactionStatus.success,
                  referenceId: 'IMPS/934810294/CASHIFY',
                ),
                WalletTransaction(
                  id: 'TXN-88412',
                  title: 'Withdrawal to HDFC Bank (****4910)',
                  description: 'Instant IMPS transfer to primary savings account',
                  amount: 27400.0,
                  isCredit: false,
                  timestamp: DateTime.now().subtract(const Duration(days: 2, hours: 1)),
                  type: TransactionType.withdrawalBank,
                  status: TransactionStatus.success,
                  referenceId: 'UTR-HDFC000129-9941',
                ),
                WalletTransaction(
                  id: 'TXN-76192',
                  title: 'Referral Bonus (Priya M.)',
                  description: 'Friend successfully completed first smartphone sale',
                  amount: 500.0,
                  isCredit: true,
                  timestamp: DateTime.now().subtract(const Duration(days: 5)),
                  type: TransactionType.referralBonus,
                  status: TransactionStatus.success,
                  referenceId: 'REF-BONUS-99182',
                ),
                WalletTransaction(
                  id: 'TXN-65120',
                  title: 'Refurbished Purchase Cashback',
                  description: '5% instant cashback on order #BO-91823',
                  amount: 750.0,
                  isCredit: true,
                  timestamp: DateTime.now().subtract(const Duration(days: 12)),
                  type: TransactionType.cashback,
                  status: TransactionStatus.success,
                  referenceId: 'CB-PROMO-SPRING',
                ),
                WalletTransaction(
                  id: 'TXN-54109',
                  title: 'Referral Bonus (Arjun K.)',
                  description: 'Friend completed sale of OnePlus 9 Pro',
                  amount: 500.0,
                  isCredit: true,
                  timestamp: DateTime.now().subtract(const Duration(days: 18)),
                  type: TransactionType.referralBonus,
                  status: TransactionStatus.success,
                  referenceId: 'REF-BONUS-87112',
                ),
              ],
            ),
          ),
        );

  Future<bool> withdrawToBank({
    required double amount,
    required String accountNo,
    required String ifsc,
  }) async {
    if (amount > state.data.totalBalance || amount <= 0) return false;
    state = state.copyWith(isLoading: true);
    await Future.delayed(const Duration(milliseconds: 1000));

    final newTxn = WalletTransaction(
      id: 'TXN-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      title: 'Withdrawal to Bank (****${accountNo.length >= 4 ? accountNo.substring(accountNo.length - 4) : 'XXXX'})',
      description: 'Instant IMPS transfer to $accountNo',
      amount: amount,
      isCredit: false,
      timestamp: DateTime.now(),
      type: TransactionType.withdrawalBank,
      status: TransactionStatus.success,
      referenceId: 'UTR-${DateTime.now().millisecondsSinceEpoch}',
    );

    final updatedTxns = [newTxn, ...state.data.transactions];
    final updatedData = WalletData(
      totalBalance: state.data.totalBalance - amount,
      cashbackBalance: state.data.cashbackBalance,
      referralBalance: (state.data.referralBalance - amount).clamp(0, double.infinity),
      pendingPayout: 0.0,
      transactions: updatedTxns,
    );

    state = state.copyWith(isLoading: false, data: updatedData);
    return true;
  }

  Future<bool> withdrawToUpi({
    required double amount,
    required String upiId,
  }) async {
    if (amount > state.data.totalBalance || amount <= 0) return false;
    state = state.copyWith(isLoading: true);
    await Future.delayed(const Duration(milliseconds: 1000));

    final newTxn = WalletTransaction(
      id: 'TXN-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      title: 'Withdrawal to UPI ($upiId)',
      description: 'Instant IMPS UPI payout',
      amount: amount,
      isCredit: false,
      timestamp: DateTime.now(),
      type: TransactionType.withdrawalUpi,
      status: TransactionStatus.success,
      referenceId: 'UPI-${DateTime.now().millisecondsSinceEpoch}',
    );

    final updatedTxns = [newTxn, ...state.data.transactions];
    final updatedData = WalletData(
      totalBalance: state.data.totalBalance - amount,
      cashbackBalance: state.data.cashbackBalance,
      referralBalance: (state.data.referralBalance - amount).clamp(0, double.infinity),
      pendingPayout: 0.0,
      transactions: updatedTxns,
    );

    state = state.copyWith(isLoading: false, data: updatedData);
    return true;
  }
}

final walletNotifierProvider = StateNotifierProvider<WalletNotifier, WalletState>((ref) {
  return WalletNotifier();
});
