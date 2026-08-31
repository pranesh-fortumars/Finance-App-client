import 'dart:convert';
import '../models/user_scheme.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';

class Calculations {
  static double calculateInterest(double principal, double rate, int days) {
    // Simple interest calculation: (P * R * T) / 100
    // Where T is in years, so days/365
    return (principal * rate * (days / 365)) / 100;
  }

  static double calculateMaturityAmount(
    double principal,
    double rate,
    int days,
  ) {
    final interest = calculateInterest(principal, rate, days);
    return principal + interest;
  }

  static double calculateDailyInterest(
    UserScheme scheme, [
    DateTime? currentDate,
  ]) {
    final now = currentDate ?? DateTime.now();
    final daysSinceStart = now.difference(scheme.startDate).inDays;
    return calculateInterest(
      scheme.currentBalance,
      scheme.interestRate,
      daysSinceStart,
    );
  }

  static double calculateRemainingAmount(
    double totalAmount,
    double paidAmount,
  ) {
    return (totalAmount - paidAmount).clamp(0.0, double.infinity);
  }

  static Map<String, dynamic> calculateSchemeProgress(
    UserScheme scheme,
    List<Transaction> transactions,
  ) {
    final totalPaid = transactions
        .where((t) => t.schemeId == scheme.id)
        .fold(0.0, (sum, t) => sum + t.amount);

    final remainingAmount = calculateRemainingAmount(
      scheme.totalAmount,
      totalPaid,
    );
    final completionPercentage = (totalPaid / scheme.totalAmount) * 100;

    final currentDate = DateTime.now();
    final endDate = scheme.startDate.add(Duration(days: scheme.duration));
    final daysRemaining = endDate
        .difference(currentDate)
        .inDays
        .clamp(0, double.infinity)
        .toInt();

    return {
      'totalPaid': totalPaid,
      'remainingAmount': remainingAmount,
      'completionPercentage': completionPercentage,
      'daysRemaining': daysRemaining,
    };
  }

  static String generateReceiptNumber() {
    final now = DateTime.now();
    final year = now.year.toString().substring(2);
    final month = now.month.toString().padLeft(2, '0');
    final day = now.day.toString().padLeft(2, '0');
    final time = now.millisecondsSinceEpoch.toString().substring(6);

    return 'FST$year$month$day$time';
  }

  static String formatCurrency(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  static String formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  static String formatDateTime(DateTime date) {
    return DateFormat('MMM dd, yyyy HH:mm').format(date);
  }

  static String formatTime(DateTime date) {
    return DateFormat('HH:mm').format(date);
  }

  static void exportToCSV(List<Map<String, dynamic>> data, String filename) {
    if (data.isEmpty) return;

    final headers = data.first.keys.toList();
    final csvContent = StringBuffer();

    // Add headers
    csvContent.writeln(headers.join(','));

    // Add data rows
    for (final row in data) {
      final values = headers
          .map((header) {
            final cell = row[header];
            if (cell is DateTime) {
              return formatDate(cell);
            }
            if (cell is Map || cell is List) {
              return jsonEncode(cell).replaceAll(',', ';');
            }
            // Escape commas and quotes
            return '"${cell.toString().replaceAll('"', '""')}"';
          })
          .join(',');
      csvContent.writeln(values);
    }

    // In a real app, you would save this to a file
    // TODO: Implement actual file saving functionality
    // print('CSV Export: $filename');
    // print(csvContent.toString());
  }
}
