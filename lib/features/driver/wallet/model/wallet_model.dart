class WalletModel {
  final double pendingBalance;
  final double availableBalance;
  final double totalEarned;
  final double totalWithdrawn;
  final String currency;
  final double commissionPercentage;

  WalletModel({
    required this.pendingBalance,
    required this.availableBalance,
    required this.totalEarned,
    required this.totalWithdrawn,
    required this.currency,
    required this.commissionPercentage,
  });

  static double _toDouble(dynamic v) =>
      v == null ? 0.0 : double.tryParse(v.toString()) ?? 0.0;

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return WalletModel(
      pendingBalance: _toDouble(data['pending_balance']),
      availableBalance: _toDouble(data['available_balance']),
      totalEarned: _toDouble(data['total_earned']),
      totalWithdrawn: _toDouble(data['total_withdrawn']),
      currency: data['currency']?.toString() ?? '',
      commissionPercentage: _toDouble(data['commission_percentage']),
    );
  }
}

class WalletTransaction {
  final String? id;
  final String type;
  final double amount;
  final double balanceAfter;
  final String description;
  final String? createdAt;

  WalletTransaction({
    this.id,
    required this.type,
    required this.amount,
    required this.balanceAfter,
    required this.description,
    this.createdAt,
  });

  factory WalletTransaction.fromJson(Map<String, dynamic> json) {
    return WalletTransaction(
      id: json['_id']?.toString(),
      type: json['type']?.toString() ?? '',
      amount: WalletModel._toDouble(json['amount']),
      balanceAfter: WalletModel._toDouble(json['balance_after']),
      description: json['description']?.toString() ?? '',
      createdAt: json['created_at']?.toString(),
    );
  }
}
