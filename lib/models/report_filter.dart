enum ReportPeriod { daily, weekly, monthly, yearly }

class ReportFilter {
  final DateTime? startDate;
  final DateTime? endDate;
  final String? userId;
  final String? schemeType;
  final String? paymentMode;
  final ReportPeriod period;

  ReportFilter({
    this.startDate,
    this.endDate,
    this.userId,
    this.schemeType,
    this.paymentMode,
    required this.period,
  });

  factory ReportFilter.fromJson(Map<String, dynamic> json) {
    return ReportFilter(
      startDate: json['startDate'] != null
          ? DateTime.parse(json['startDate'])
          : null,
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      userId: json['userId'],
      schemeType: json['schemeType'],
      paymentMode: json['paymentMode'],
      period: ReportPeriod.values.firstWhere(
        (e) => e.toString().split('.').last == json['period'],
        orElse: () => ReportPeriod.monthly,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'userId': userId,
      'schemeType': schemeType,
      'paymentMode': paymentMode,
      'period': period.toString().split('.').last,
    };
  }

  ReportFilter copyWith({
    DateTime? startDate,
    DateTime? endDate,
    String? userId,
    String? schemeType,
    String? paymentMode,
    ReportPeriod? period,
  }) {
    return ReportFilter(
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      userId: userId ?? this.userId,
      schemeType: schemeType ?? this.schemeType,
      paymentMode: paymentMode ?? this.paymentMode,
      period: period ?? this.period,
    );
  }
}
