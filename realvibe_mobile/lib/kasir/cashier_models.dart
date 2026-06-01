class CashierUser {
  const CashierUser({
    required this.id,
    required this.name,
    required this.username,
    required this.role,
  });

  final int id;
  final String name;
  final String username;
  final String role;

  factory CashierUser.fromJson(Map<String, dynamic> json) {
    return CashierUser(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      name: (json['nama'] ?? json['name'] ?? '').toString(),
      username: (json['username'] ?? '').toString(),
      role: (json['role'] ?? '').toString(),
    );
  }
}

class CashierSessionEntry {
  const CashierSessionEntry({
    required this.id,
    required this.cashierSessionId,
    required this.entryType,
    required this.title,
    required this.amount,
    this.notes,
    required this.happenedAt,
  });

  final int id;
  final int cashierSessionId;
  final String entryType;
  final String title;
  final double amount;
  final String? notes;
  final DateTime happenedAt;

  factory CashierSessionEntry.fromJson(Map<String, dynamic> json) {
    return CashierSessionEntry(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      cashierSessionId: json['cashier_session_id'] is int
          ? json['cashier_session_id']
          : int.parse(json['cashier_session_id'].toString()),
      entryType: (json['entry_type'] ?? 'in').toString(),
      title: (json['title'] ?? '').toString(),
      amount: (json['amount'] is num)
          ? (json['amount'] as num).toDouble()
          : double.tryParse(json['amount']?.toString() ?? '0') ?? 0,
      notes: json['notes']?.toString(),
      happenedAt: DateTime.tryParse((json['happened_at'] ?? '').toString()) ??
          DateTime.now(),
    );
  }
}

class CashierSession {
  const CashierSession({
    required this.id,
    required this.userId,
    required this.sessionCode,
    required this.businessDate,
    required this.openedAt,
    this.closedAt,
    required this.status,
    required this.openingBalance,
    required this.totalCashIn,
    required this.totalCashOut,
    required this.totalCashPayment,
    required this.totalNonCashPayment,
    required this.subtotal,
    required this.entries,
  });

  final int id;
  final int userId;
  final String sessionCode;
  final DateTime businessDate;
  final DateTime openedAt;
  final DateTime? closedAt;
  final String status;
  final double openingBalance;
  final double totalCashIn;
  final double totalCashOut;
  final double totalCashPayment;
  final double totalNonCashPayment;
  final double subtotal;
  final List<CashierSessionEntry> entries;

  factory CashierSession.fromJson(Map<String, dynamic> json) {
    final rawEntries = json['entries'];
    return CashierSession(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      userId: json['user_id'] is int
          ? json['user_id']
          : int.parse(json['user_id'].toString()),
      sessionCode: (json['session_code'] ?? '').toString(),
      businessDate: DateTime.tryParse((json['business_date'] ?? '').toString()) ??
          DateTime.now(),
      openedAt: DateTime.tryParse((json['opened_at'] ?? '').toString()) ??
          DateTime.now(),
      closedAt: DateTime.tryParse((json['closed_at'] ?? '').toString()),
      status: (json['status'] ?? 'open').toString(),
      openingBalance: (json['opening_balance'] is num)
          ? (json['opening_balance'] as num).toDouble()
          : double.tryParse(json['opening_balance']?.toString() ?? '0') ?? 0,
      totalCashIn: (json['total_cash_in'] is num)
          ? (json['total_cash_in'] as num).toDouble()
          : double.tryParse(json['total_cash_in']?.toString() ?? '0') ?? 0,
      totalCashOut: (json['total_cash_out'] is num)
          ? (json['total_cash_out'] as num).toDouble()
          : double.tryParse(json['total_cash_out']?.toString() ?? '0') ?? 0,
      totalCashPayment: (json['total_cash_payment'] is num)
          ? (json['total_cash_payment'] as num).toDouble()
          : double.tryParse(json['total_cash_payment']?.toString() ?? '0') ?? 0,
      totalNonCashPayment: (json['total_non_cash_payment'] is num)
          ? (json['total_non_cash_payment'] as num).toDouble()
          : double.tryParse(json['total_non_cash_payment']?.toString() ?? '0') ?? 0,
      subtotal: (json['subtotal'] is num)
          ? (json['subtotal'] as num).toDouble()
          : double.tryParse(json['subtotal']?.toString() ?? '0') ?? 0,
      entries: rawEntries is List
          ? rawEntries
                .map((e) => CashierSessionEntry.fromJson(e as Map<String, dynamic>))
                .toList()
          : const [],
    );
  }
}
