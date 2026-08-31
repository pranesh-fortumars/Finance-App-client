enum Frequency { daily, weekly, monthly, lumpsum }

class SchemeType {
  final String id;
  final String name;
  final String description;
  final double interestRate;
  final double amount;
  final int duration; // in days
  final Frequency frequency;

  SchemeType({
    required this.id,
    required this.name,
    required this.description,
    required this.interestRate,
    required this.amount,
    required this.duration,
    required this.frequency,
  });

  factory SchemeType.fromJson(Map<String, dynamic> json) {
    return SchemeType(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      interestRate: (json['interestRate'] ?? 0.0).toDouble(),
      amount: (json['amount'] ?? 0.0).toDouble(),
      duration: json['duration'] ?? 0,
      frequency: Frequency.values.firstWhere(
        (e) => e.toString().split('.').last == json['frequency'],
        orElse: () => Frequency.daily,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'interestRate': interestRate,
      'amount': amount,
      'duration': duration,
      'frequency': frequency.toString().split('.').last,
    };
  }

  SchemeType copyWith({
    String? id,
    String? name,
    String? description,
    double? interestRate,
    double? amount,
    int? duration,
    Frequency? frequency,
  }) {
    return SchemeType(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      interestRate: interestRate ?? this.interestRate,
      amount: amount ?? this.amount,
      duration: duration ?? this.duration,
      frequency: frequency ?? this.frequency,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SchemeType && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
