class NotificationConfig {
  final bool emailEnabled;
  final bool whatsappEnabled;
  final List<int> reminderDays;
  final List<int> escalationDays;
  final String reportSchedule;

  NotificationConfig({
    required this.emailEnabled,
    required this.whatsappEnabled,
    required this.reminderDays,
    required this.escalationDays,
    required this.reportSchedule,
  });

  factory NotificationConfig.fromJson(Map<String, dynamic> json) {
    return NotificationConfig(
      emailEnabled: json['emailEnabled'] ?? false,
      whatsappEnabled: json['whatsappEnabled'] ?? false,
      reminderDays: List<int>.from(json['reminderDays'] ?? []),
      escalationDays: List<int>.from(json['escalationDays'] ?? []),
      reportSchedule: json['reportSchedule'] ?? '19:00',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'emailEnabled': emailEnabled,
      'whatsappEnabled': whatsappEnabled,
      'reminderDays': reminderDays,
      'escalationDays': escalationDays,
      'reportSchedule': reportSchedule,
    };
  }

  NotificationConfig copyWith({
    bool? emailEnabled,
    bool? whatsappEnabled,
    List<int>? reminderDays,
    List<int>? escalationDays,
    String? reportSchedule,
  }) {
    return NotificationConfig(
      emailEnabled: emailEnabled ?? this.emailEnabled,
      whatsappEnabled: whatsappEnabled ?? this.whatsappEnabled,
      reminderDays: reminderDays ?? this.reminderDays,
      escalationDays: escalationDays ?? this.escalationDays,
      reportSchedule: reportSchedule ?? this.reportSchedule,
    );
  }
}
