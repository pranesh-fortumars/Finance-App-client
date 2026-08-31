import '../models/transaction.dart';
import '../models/user.dart';
import '../models/user_scheme.dart';
import '../models/report_filter.dart';

class Analytics {
  static List<double> simpleMovingAverage(
    List<double> values, {
    int windowSize = 7,
  }) {
    if (windowSize <= 1) return List.from(values);

    final result = List<double>.filled(values.length, 0.0);
    double sum = 0;

    for (int i = 0; i < values.length; i++) {
      sum += values[i];
      if (i >= windowSize) {
        sum -= values[i - windowSize];
      }
      final denom = (i + 1).clamp(1, windowSize);
      result[i] = sum / denom;
    }

    return result;
  }

  static List<Map<String, dynamic>> groupTransactionsByDay(
    List<Transaction> transactions, {
    int days = 30,
  }) {
    final end = DateTime.now();
    final start = end.subtract(Duration(days: days - 1));
    final Map<String, double> map = {};

    // Initialize all days with 0
    for (int i = 0; i < days; i++) {
      final date = start.add(Duration(days: i));
      final key = date.toIso8601String().substring(0, 10);
      map[key] = 0.0;
    }

    // Add transaction amounts
    for (final transaction in transactions) {
      final date = transaction.date;
      final key = date.toIso8601String().substring(0, 10);
      if (map.containsKey(key)) {
        map[key] = map[key]! + transaction.amount;
      }
    }

    final entries = map.entries.toList();
    entries.sort((a, b) => a.key.compareTo(b.key));
    return entries
        .map((entry) => {'label': entry.key, 'value': entry.value})
        .toList();
  }

  static List<Map<String, dynamic>> groupTransactionsByMonth(
    List<Transaction> transactions, {
    required int year,
  }) {
    final Map<int, double> map = {};
    for (int m = 0; m < 12; m++) {
      map[m] = 0.0;
    }

    for (final transaction in transactions) {
      final date = transaction.date;
      if (date.year == year) {
        map[date.month] = map[date.month]! + transaction.amount;
      }
    }

    const monthLabels = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    final entries = map.entries.toList();
    entries.sort((a, b) => a.key.compareTo(b.key));
    return entries
        .map((entry) => {'label': monthLabels[entry.key], 'value': entry.value})
        .toList();
  }

  static Map<String, List<dynamic>> paymentModeDistribution(
    List<Transaction> transactions,
  ) {
    final Map<String, double> counts = {
      'offline': 0,
      'card': 0,
      'upi': 0,
      'netbanking': 0,
    };

    for (final transaction in transactions) {
      final mode = transaction.paymentMode.toString().split('.').last;
      counts[mode] = (counts[mode] ?? 0) + 1;
    }

    return {'labels': counts.keys.toList(), 'values': counts.values.toList()};
  }

  static Map<String, List<dynamic>> amountBySchemeType(
    List<Transaction> transactions,
    List<UserScheme> userSchemes,
  ) {
    final schemeMap = <String, String>{};
    for (final scheme in userSchemes) {
      schemeMap[scheme.id] = scheme.schemeType.name;
    }

    final Map<String, double> sums = {};
    for (final transaction in transactions) {
      final schemeName = schemeMap[transaction.schemeId] ?? 'Unknown';
      sums[schemeName] = (sums[schemeName] ?? 0) + transaction.amount;
    }

    return {'labels': sums.keys.toList(), 'values': sums.values.toList()};
  }

  static List<Map<String, dynamic>> userGrowthByMonth(
    List<User> users, {
    required int year,
  }) {
    final Map<int, double> map = {};
    for (int m = 0; m < 12; m++) {
      map[m] = 0.0;
    }

    for (final user in users) {
      final date = user.createdAt;
      if (date.year == year) {
        map[date.month] = map[date.month]! + 1;
      }
    }

    const monthLabels = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    final entries = map.entries.toList();
    entries.sort((a, b) => a.key.compareTo(b.key));
    return entries
        .map((entry) => {'label': monthLabels[entry.key], 'value': entry.value})
        .toList();
  }

  static List<Transaction> filterTransactions(
    List<Transaction> transactions,
    ReportFilter filter,
  ) {
    return transactions.where((transaction) {
      if (filter.startDate != null &&
          transaction.date.isBefore(filter.startDate!)) {
        return false;
      }
      if (filter.endDate != null && transaction.date.isAfter(filter.endDate!)) {
        return false;
      }
      if (filter.userId != null && transaction.userId != filter.userId) {
        return false;
      }
      if (filter.paymentMode != null &&
          transaction.paymentMode.toString().split('.').last !=
              filter.paymentMode) {
        return false;
      }
      return true;
    }).toList();
  }
}
