import 'package:flutter/material.dart';
import '../models/user.dart';
import '../models/transaction.dart';
import '../models/scheme_type.dart';
import '../services/storage_service.dart';

class DataProvider extends ChangeNotifier {
  final StorageService _storageService = StorageService.instance;

  List<User> _users = [];
  List<Transaction> _transactions = [];
  List<SchemeType> _schemeTypes = [];
  bool _isLoading = false;

  // Getters
  List<User> get users => _users;
  List<Transaction> get transactions => _transactions;
  List<SchemeType> get schemeTypes => _schemeTypes;
  bool get isLoading => _isLoading;

  // Initialize data
  Future<void> initializeData() async {
    _setLoading(true);
    try {
      await Future.wait([
        _loadUsers(),
        _loadTransactions(),
        _loadSchemeTypes(),
      ]);
    } catch (e) {
      // Continue with empty data rather than crashing
      // Error is handled silently to prevent app crashes
    } finally {
      _setLoading(false);
    }
  }

  // Load users
  Future<void> _loadUsers() async {
    try {
      _users = await _storageService.getUsers();
      notifyListeners();
    } catch (e) {
      // Handle error silently and continue with empty list
      _users = [];
    }
  }

  // Load transactions
  Future<void> _loadTransactions() async {
    try {
      _transactions = await _storageService.getTransactions();
      notifyListeners();
    } catch (e) {
      // Handle error silently and continue with empty list
      _transactions = [];
    }
  }

  // Load scheme types
  Future<void> _loadSchemeTypes() async {
    try {
      _schemeTypes = await _storageService.getSchemeTypes();
      notifyListeners();
    } catch (e) {
      // Handle error silently and continue with empty list
      _schemeTypes = [];
    }
  }

  // Add new transaction
  Future<void> addTransaction(Transaction transaction) async {
    try {
      await _storageService.saveTransaction(transaction);
      _transactions.add(transaction);
      notifyListeners();
    } catch (e) {
      // Re-throw so the UI can handle it
      rethrow;
    }
  }

  // Add new user
  Future<void> addUser(User user) async {
    await _storageService.saveUser(user);
    _users.add(user);
    notifyListeners();
  }

  // Get transactions by user ID
  List<Transaction> getTransactionsByUserId(String userId) {
    return _transactions.where((t) => t.userId == userId).toList();
  }

  // Get recent transactions (last 5)
  List<Transaction> getRecentTransactions({int limit = 5}) {
    final sortedTransactions = List<Transaction>.from(_transactions)
      ..sort((a, b) => b.date.compareTo(a.date));
    return sortedTransactions.take(limit).toList();
  }

  // Get user by ID
  User? getUserById(String userId) {
    try {
      return _users.firstWhere((user) => user.id == userId);
    } catch (e) {
      return null;
    }
  }

  // Get total amount for user
  double getTotalAmountForUser(String userId) {
    return _transactions
        .where((t) => t.userId == userId)
        .fold(0.0, (sum, transaction) => sum + transaction.amount);
  }

  // Get dashboard statistics
  Map<String, dynamic> getDashboardStats() {
    final totalTransactions = _transactions.length;
    final totalAmount = _transactions.fold(0.0, (sum, t) => sum + t.amount);
    final totalUsers = _users.length;

    // Today's transactions
    final today = DateTime.now();
    final todayTransactions = _transactions
        .where(
          (t) =>
              t.date.year == today.year &&
              t.date.month == today.month &&
              t.date.day == today.day,
        )
        .toList();

    final todayAmount = todayTransactions.fold(0.0, (sum, t) => sum + t.amount);

    return {
      'totalTransactions': totalTransactions,
      'totalAmount': totalAmount,
      'totalUsers': totalUsers,
      'todayTransactions': todayTransactions.length,
      'todayAmount': todayAmount,
    };
  }

  // Refresh data
  Future<void> refreshData() async {
    await initializeData();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
