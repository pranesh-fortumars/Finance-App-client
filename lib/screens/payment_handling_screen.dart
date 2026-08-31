import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../models/user.dart';
import '../models/address.dart';
import '../services/storage_service.dart';
import '../utils/calculations.dart';

class PaymentHandlingScreen extends StatefulWidget {
  const PaymentHandlingScreen({super.key});

  @override
  State<PaymentHandlingScreen> createState() => _PaymentHandlingScreenState();
}

class _PaymentHandlingScreenState extends State<PaymentHandlingScreen>
    with TickerProviderStateMixin {
  final StorageService _storageService = StorageService.instance;
  final TextEditingController _searchController = TextEditingController();

  List<Transaction> _transactions = [];
  List<Transaction> _filteredTransactions = [];
  List<User> _users = [];
  bool _isLoading = true;
  String _searchQuery = '';
  PaymentMode? _selectedPaymentMode;
  DateTime? _selectedDate;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _loadData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final transactions = await _storageService.getTransactions();
      final users = await _storageService.getUsers();

      setState(() {
        _transactions = transactions;
        _filteredTransactions = transactions;
        _users = users;
      });
    } finally {
      setState(() => _isLoading = false);
      _animationController.forward();
    }
  }

  void _filterTransactions() {
    setState(() {
      _filteredTransactions = _transactions.where((transaction) {
        final user = _users.firstWhere(
          (u) => u.id == transaction.userId,
          orElse: () => User(
            id: '',
            name: 'Unknown',
            mobileNumber: '',
            permanentAddress: Address(
              doorNumber: '',
              street: '',
              area: '',
              localAddress: '',
              city: '',
              district: '',
              state: '',
              pinCode: '',
            ),
            serialNumber: 'unknown',
            status: UserStatus.active,
            createdAt: DateTime.now(),
            schemes: [],
          ),
        );

        bool matchesSearch =
            _searchQuery.isEmpty ||
            user.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            user.mobileNumber.contains(_searchQuery) ||
            (transaction.receiptNumber ?? '').toLowerCase().contains(
              _searchQuery.toLowerCase(),
            );

        bool matchesPaymentMode =
            _selectedPaymentMode == null ||
            transaction.paymentMode == _selectedPaymentMode;

        bool matchesDate =
            _selectedDate == null ||
            (transaction.date.year == _selectedDate!.year &&
                transaction.date.month == _selectedDate!.month &&
                transaction.date.day == _selectedDate!.day);

        return matchesSearch && matchesPaymentMode && matchesDate;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Modern App Bar
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            backgroundColor: theme.colorScheme.surface,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      theme.colorScheme.primary.withValues(alpha: 0.1),
                      theme.colorScheme.secondary.withValues(alpha: 0.05),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Payment Handling',
                              style: theme.textTheme.titleLarge?.copyWith(
                                color: theme.colorScheme.onSurface,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: theme.colorScheme.primary.withValues(
                                      alpha: 0.3,
                                    ),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: IconButton(
                                onPressed: _loadData,
                                icon: const Icon(
                                  Icons.refresh_rounded,
                                  color: Colors.white,
                                ),
                                tooltip: 'Refresh',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Manage and track all payments',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.7,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Filters Section
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Search Bar
                  TextFormField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search by name, amount, or ID...',
                      prefixIcon: const Icon(Icons.search_rounded),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: theme.colorScheme.surface,
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                      _filterTransactions();
                    },
                  ),
                  const SizedBox(height: 16),

                  // Filter Row
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<PaymentMode?>(
                          initialValue: _selectedPaymentMode,
                          decoration: InputDecoration(
                            labelText: 'Payment Mode',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: theme.colorScheme.surface,
                            isDense: true,
                          ),
                          items: [
                            const DropdownMenuItem(
                              value: null,
                              child: Text('All Modes'),
                            ),
                            ...PaymentMode.values.map((mode) {
                              return DropdownMenuItem(
                                value: mode,
                                child: Text(
                                  mode.toString().split('.').last.toUpperCase(),
                                ),
                              );
                            }),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedPaymentMode = value;
                            });
                            _filterTransactions();
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate: _selectedDate ?? DateTime.now(),
                              firstDate: DateTime(2020),
                              lastDate: DateTime.now(),
                            );
                            if (date != null) {
                              setState(() {
                                _selectedDate = date;
                              });
                              _filterTransactions();
                            }
                          },
                          child: InputDecorator(
                            decoration: InputDecoration(
                              labelText: 'Date',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: theme.colorScheme.surface,
                              isDense: true,
                              prefixIcon: const Icon(
                                Icons.calendar_today_rounded,
                              ),
                            ),
                            child: Text(
                              _selectedDate == null
                                  ? 'All Dates'
                                  : Calculations.formatDate(_selectedDate!),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Transactions List
          _isLoading
              ? SliverToBoxAdapter(
                  child: SizedBox(
                    height: 200,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              theme.colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Loading payments...',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: 0.7,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : _filteredTransactions.isEmpty
              ? SliverToBoxAdapter(
                  child: SizedBox(
                    height: 300,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.payment_outlined,
                            size: 64,
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.3,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No payments found',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: 0.6,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Try adjusting your search or filters',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final transaction = _filteredTransactions[index];
                    return FadeTransition(
                      opacity: _fadeAnimation,
                      child: _buildTransactionCard(transaction, index),
                    );
                  }, childCount: _filteredTransactions.length),
                ),
        ],
      ),
    );
  }

  Widget _buildTransactionCard(Transaction transaction, int index) {
    final theme = Theme.of(context);
    final user = _users.firstWhere(
      (u) => u.id == transaction.userId,
      orElse: () => User(
        id: '',
        name: 'Unknown',
        mobileNumber: '',
        permanentAddress: Address(
          doorNumber: '',
          street: '',
          area: '',
          localAddress: '',
          city: '',
          district: '',
          state: '',
          pinCode: '',
        ),
        serialNumber: 'unknown',
        status: UserStatus.active,
        createdAt: DateTime.now(),
        schemes: [],
      ),
    );

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 8, 20, 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: _getPaymentModeColor(
                      transaction.paymentMode,
                    ).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Icon(
                    _getPaymentModeIcon(transaction.paymentMode),
                    color: _getPaymentModeColor(transaction.paymentMode),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        user.mobileNumber,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.6,
                          ),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      Calculations.formatCurrency(transaction.amount),
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getPaymentModeColor(
                          transaction.paymentMode,
                        ).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        transaction.paymentMode
                            .toString()
                            .split('.')
                            .last
                            .toUpperCase(),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: _getPaymentModeColor(transaction.paymentMode),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Transaction Details
            Row(
              children: [
                Icon(
                  Icons.calendar_today_rounded,
                  size: 16,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
                const SizedBox(width: 8),
                Text(
                  Calculations.formatDate(transaction.date),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(width: 16),
                Icon(
                  Icons.receipt_rounded,
                  size: 16,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
                const SizedBox(width: 8),
                Text(
                  transaction.receiptNumber ?? '',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),

            if (transaction.remarks != null &&
                transaction.remarks!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.description_rounded,
                    size: 16,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      transaction.remarks!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.7,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 16),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _showTransactionDetails(transaction, user),
                    icon: const Icon(Icons.visibility_rounded, size: 16),
                    label: const Text('View Details'),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: theme.colorScheme.outline),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _editTransaction(transaction),
                    icon: const Icon(Icons.edit_rounded, size: 16),
                    label: const Text('Edit'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getPaymentModeColor(PaymentMode mode) {
    switch (mode) {
      case PaymentMode.offline:
        return const Color(0xFF3B82F6);
      case PaymentMode.card:
        return const Color(0xFF10B981);
      case PaymentMode.upi:
        return const Color(0xFF8B5CF6);
      case PaymentMode.netbanking:
        return const Color(0xFFF59E0B);
    }
  }

  IconData _getPaymentModeIcon(PaymentMode mode) {
    switch (mode) {
      case PaymentMode.offline:
        return Icons.money_rounded;
      case PaymentMode.card:
        return Icons.credit_card_rounded;
      case PaymentMode.upi:
        return Icons.phone_android_rounded;
      case PaymentMode.netbanking:
        return Icons.account_balance_rounded;
    }
  }

  void _showTransactionDetails(Transaction transaction, User user) {
    showDialog(
      context: context,
      builder: (context) =>
          _TransactionDetailsDialog(transaction: transaction, user: user),
    );
  }

  void _editTransaction(Transaction transaction) {
    // TODO: Implement edit functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Edit functionality coming soon!'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}

class _TransactionDetailsDialog extends StatelessWidget {
  final Transaction transaction;
  final User user;

  const _TransactionDetailsDialog({
    required this.transaction,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.receipt_long_rounded,
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Transaction Details',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
            const SizedBox(height: 24),

            _buildDetailRow(context, 'User', user.name),
            _buildDetailRow(context, 'Mobile', user.mobileNumber),
            _buildDetailRow(
              context,
              'Amount',
              Calculations.formatCurrency(transaction.amount),
            ),
            _buildDetailRow(
              context,
              'Date',
              Calculations.formatDate(transaction.date),
            ),
            _buildDetailRow(
              context,
              'Payment Mode',
              transaction.paymentMode.toString().split('.').last.toUpperCase(),
            ),
            _buildDetailRow(
              context,
              'Receipt Number',
              transaction.receiptNumber,
            ),
            if (transaction.remarks != null && transaction.remarks!.isNotEmpty)
              _buildDetailRow(context, 'Remarks', transaction.remarks!),

            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Close'),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    // TODO: Implement edit functionality
                  },
                  child: const Text('Edit'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String? value) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value ?? '',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
