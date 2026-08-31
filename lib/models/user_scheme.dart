import 'scheme_type.dart';

enum SchemeStatus { active, completed, paused }

class UserScheme {
  final String id;
  final String userId;
  final SchemeType schemeType;
  final DateTime startDate;
  final int duration; // in days
  final double? dailyAmount;
  final double totalAmount;
  final double interestRate;
  final double currentBalance;
  final SchemeStatus status;

  UserScheme({
    required this.id,
    required this.userId,
    required this.schemeType,
    required this.startDate,
    required this.duration,
    this.dailyAmount,
    required this.totalAmount,
    required this.interestRate,
    required this.currentBalance,
    required this.status,
  });

  factory UserScheme.fromJson(Map<String, dynamic> json) {
    return UserScheme(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      schemeType: SchemeType.fromJson(json['schemeType'] ?? {}),
      startDate: DateTime.parse(json['startDate']),
      duration: json['duration'] ?? 0,
      dailyAmount: json['dailyAmount']?.toDouble(),
      totalAmount: (json['totalAmount'] ?? 0.0).toDouble(),
      interestRate: (json['interestRate'] ?? 0.0).toDouble(),
      currentBalance: (json['currentBalance'] ?? 0.0).toDouble(),
      status: SchemeStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => SchemeStatus.active,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'schemeType': schemeType.toJson(),
      'startDate': startDate.toIso8601String(),
      'duration': duration,
      'dailyAmount': dailyAmount,
      'totalAmount': totalAmount,
      'interestRate': interestRate,
      'currentBalance': currentBalance,
      'status': status.toString().split('.').last,
    };
  }

  UserScheme copyWith({
    String? id,
    String? userId,
    SchemeType? schemeType,
    DateTime? startDate,
    int? duration,
    double? dailyAmount,
    double? totalAmount,
    double? interestRate,
    double? currentBalance,
    SchemeStatus? status,
  }) {
    return UserScheme(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      schemeType: schemeType ?? this.schemeType,
      startDate: startDate ?? this.startDate,
      duration: duration ?? this.duration,
      dailyAmount: dailyAmount ?? this.dailyAmount,
      totalAmount: totalAmount ?? this.totalAmount,
      interestRate: interestRate ?? this.interestRate,
      currentBalance: currentBalance ?? this.currentBalance,
      status: status ?? this.status,
    );
  }
}
