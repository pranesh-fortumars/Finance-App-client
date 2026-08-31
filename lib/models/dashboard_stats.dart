class DashboardStats {
  final int totalCustomers;
  final int activeSchemes;
  final double totalInvestment;
  final double pendingDues;
  final int completedCycles;
  final double todayCollection;
  final double monthlyGrowth;

  DashboardStats({
    required this.totalCustomers,
    required this.activeSchemes,
    required this.totalInvestment,
    required this.pendingDues,
    required this.completedCycles,
    required this.todayCollection,
    required this.monthlyGrowth,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    return DashboardStats(
      totalCustomers: json['totalCustomers'] ?? 0,
      activeSchemes: json['activeSchemes'] ?? 0,
      totalInvestment: (json['totalInvestment'] ?? 0.0).toDouble(),
      pendingDues: (json['pendingDues'] ?? 0.0).toDouble(),
      completedCycles: json['completedCycles'] ?? 0,
      todayCollection: (json['todayCollection'] ?? 0.0).toDouble(),
      monthlyGrowth: (json['monthlyGrowth'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalCustomers': totalCustomers,
      'activeSchemes': activeSchemes,
      'totalInvestment': totalInvestment,
      'pendingDues': pendingDues,
      'completedCycles': completedCycles,
      'todayCollection': todayCollection,
      'monthlyGrowth': monthlyGrowth,
    };
  }

  DashboardStats copyWith({
    int? totalCustomers,
    int? activeSchemes,
    double? totalInvestment,
    double? pendingDues,
    int? completedCycles,
    double? todayCollection,
    double? monthlyGrowth,
  }) {
    return DashboardStats(
      totalCustomers: totalCustomers ?? this.totalCustomers,
      activeSchemes: activeSchemes ?? this.activeSchemes,
      totalInvestment: totalInvestment ?? this.totalInvestment,
      pendingDues: pendingDues ?? this.pendingDues,
      completedCycles: completedCycles ?? this.completedCycles,
      todayCollection: todayCollection ?? this.todayCollection,
      monthlyGrowth: monthlyGrowth ?? this.monthlyGrowth,
    );
  }
}
