import 'payment_details.dart';

enum PaymentMode { offline, card, upi, netbanking }

class Transaction {
  final String id;
  final String userId;
  final String schemeId;
  final double amount;
  final DateTime date;
  final PaymentMode paymentMode;
  final PaymentDetails? paymentDetails;
  final double interest;
  final String? remarks;
  final String? receiptNumber;

  Transaction({
    required this.id,
    required this.userId,
    required this.schemeId,
    required this.amount,
    required this.date,
    required this.paymentMode,
    this.paymentDetails,
    required this.interest,
    this.remarks,
    this.receiptNumber,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      schemeId: json['schemeId'] ?? '',
      amount: (json['amount'] ?? 0.0).toDouble(),
      date: DateTime.parse(json['date']),
      paymentMode: _parsePaymentMode(json['paymentMode']),
      paymentDetails: json['paymentDetails'] != null
          ? PaymentDetails.fromJson(json['paymentDetails'])
          : null,
      interest: (json['interest'] ?? 0.0).toDouble(),
      remarks: json['remarks'],
      receiptNumber: json['receiptNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'schemeId': schemeId,
      'amount': amount,
      'date': date.toIso8601String(),
      'paymentMode': paymentMode.toString().split('.').last,
      'paymentDetails': paymentDetails?.toJson(),
      'interest': interest,
      'remarks': remarks,
      'receiptNumber': receiptNumber,
    };
  }

  Transaction copyWith({
    String? id,
    String? userId,
    String? schemeId,
    double? amount,
    DateTime? date,
    PaymentMode? paymentMode,
    PaymentDetails? paymentDetails,
    double? interest,
    String? remarks,
    String? receiptNumber,
  }) {
    return Transaction(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      schemeId: schemeId ?? this.schemeId,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      paymentMode: paymentMode ?? this.paymentMode,
      paymentDetails: paymentDetails ?? this.paymentDetails,
      interest: interest ?? this.interest,
      remarks: remarks ?? this.remarks,
      receiptNumber: receiptNumber ?? this.receiptNumber,
    );
  }

  static PaymentMode _parsePaymentMode(dynamic paymentMode) {
    if (paymentMode == null) return PaymentMode.offline;

    if (paymentMode is PaymentMode) {
      return paymentMode;
    }

    if (paymentMode is String) {
      try {
        return PaymentMode.values.firstWhere(
          (e) => e.toString().split('.').last == paymentMode,
          orElse: () => PaymentMode.offline,
        );
      } catch (e) {
        return PaymentMode.offline;
      }
    }

    return PaymentMode.offline;
  }
}
