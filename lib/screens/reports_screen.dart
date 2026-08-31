import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/user.dart';
import '../models/address.dart';
import '../models/transaction.dart';
import '../services/storage_service.dart';
import '../widgets/common/card_widget.dart';
import '../widgets/charts/bar_chart_widget.dart';
import '../widgets/charts/doughnut_chart_widget.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  final StorageService _storageService = StorageService.instance;

  String _selectedPeriod = 'monthly';
  String _selectedClient = 'all';
  List<User> _users = [];
  List<Transaction> _transactions = [];
  bool _isLoading = true;
  DateTimeRange? _selectedDateRange;

  // Analytics data
  double _totalAmount = 0.0;
  int _totalTransactions = 0;
  double _averageAmount = 0.0;
  Map<String, double> _paymentModeBreakdown = {};
  Map<String, double> _clientBreakdown = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    
    try {
      final users = await _storageService.getUsers();
      final transactions = await _storageService.getTransactions();

      if (mounted) {
      setState(() {
        _users = users;
        _transactions = transactions;
        _isLoading = false;
      });
      _calculateAnalytics();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _users = [];
          _transactions = [];
        });
      }
    }
  }

  void _calculateAnalytics() {
    final filteredTransactions = _getFilteredTransactions();

        _totalAmount = 0.0;
        _totalTransactions = 0;
        _averageAmount = 0.0;
        _paymentModeBreakdown = {};
    _clientBreakdown = {};

    if (filteredTransactions.isNotEmpty) {
    _totalAmount = filteredTransactions.fold(0.0, (sum, t) => sum + t.amount);
    _totalTransactions = filteredTransactions.length;
    _averageAmount = _totalAmount / _totalTransactions;

    // Payment mode breakdown
    for (var transaction in filteredTransactions) {
      String mode = _getPaymentModeString(transaction.paymentMode);
        _paymentModeBreakdown[mode] = (_paymentModeBreakdown[mode] ?? 0.0) + transaction.amount;
    }

      // Client breakdown
    for (var transaction in filteredTransactions) {
        final user = _users.firstWhere(
          (u) => u.id == transaction.userId,
          orElse: () => User(
            id: 'unknown',
            name: 'Unknown User',
            mobileNumber: '0000000000',
            serialNumber: '000',
            status: UserStatus.active,
            createdAt: DateTime.now(),
            schemes: [],
            permanentAddress: Address(
              doorNumber: '0',
              street: 'Unknown',
              area: 'Unknown',
              localAddress: 'Unknown',
              city: 'Unknown',
              district: 'Unknown',
              state: 'Unknown',
              pinCode: '000000',
            ),
          ),
        );
        _clientBreakdown[user.name] = (_clientBreakdown[user.name] ?? 0.0) + transaction.amount;
      }
    }

    if (mounted) {
    setState(() {});
    }
  }

  List<Transaction> _getFilteredTransactions() {
    List<Transaction> filtered = List.from(_transactions);

    // Filter by date range if selected, otherwise by period
    if (_selectedDateRange != null) {
      filtered = filtered.where((t) {
        // Compare only the date part (year, month, day) to match exactly with daily entry date
        final transactionDate = DateTime(t.date.year, t.date.month, t.date.day);
        final startDate = DateTime(_selectedDateRange!.start.year, _selectedDateRange!.start.month, _selectedDateRange!.start.day);
        final endDate = DateTime(_selectedDateRange!.end.year, _selectedDateRange!.end.month, _selectedDateRange!.end.day);
        
        return (transactionDate.isAtSameMomentAs(startDate) || transactionDate.isAfter(startDate)) &&
               (transactionDate.isAtSameMomentAs(endDate) || transactionDate.isBefore(endDate));
      }).toList();
    } else {
    // Filter by period
    DateTime now = DateTime.now();
    DateTime startDate;

    switch (_selectedPeriod) {
      case 'daily':
        startDate = DateTime(now.year, now.month, now.day);
        break;
      case 'weekly':
        startDate = now.subtract(const Duration(days: 7));
        break;
      case 'monthly':
        startDate = DateTime(now.year, now.month, 1);
        break;
      case 'yearly':
        startDate = DateTime(now.year, 1, 1);
        break;
      default:
        startDate = DateTime(now.year, now.month, 1);
    }

      filtered = filtered.where((t) {
        // Compare only the date part (year, month, day) to match exactly with daily entry date
        final transactionDate = DateTime(t.date.year, t.date.month, t.date.day);
        final filterStartDate = DateTime(startDate.year, startDate.month, startDate.day);
        final nowDate = DateTime(now.year, now.month, now.day);
        
        return (transactionDate.isAtSameMomentAs(filterStartDate) || transactionDate.isAfter(filterStartDate)) &&
               (transactionDate.isAtSameMomentAs(nowDate) || transactionDate.isBefore(nowDate));
      }).toList();
    }

    // Filter by client
    if (_selectedClient != 'all') {
      filtered = filtered.where((t) => t.userId == _selectedClient).toList();
    }

    return filtered;
  }

  String _getPaymentModeString(PaymentMode mode) {
    switch (mode) {
      case PaymentMode.offline:
        return 'Offline';
      case PaymentMode.upi:
        return 'UPI';
      case PaymentMode.netbanking:
        return 'Net Banking';
      case PaymentMode.card:
        return 'Card';
    }
  }

  String _getSelectedClientName() {
    if (_selectedClient == 'all') {
      return 'All Clients';
    }
    try {
      final user = _users.firstWhere((u) => u.id == _selectedClient);
      return user.name;
    } catch (e) {
      return 'Unknown Client';
    }
  }

  Widget _buildDateRangeField() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Date Range',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.grey[300] : Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () async {
            final dateRange = await showDateRangePicker(
              context: context,
              firstDate: DateTime(2020),
              lastDate: DateTime.now().add(const Duration(days: 365)),
              initialDateRange: _selectedDateRange ?? DateTimeRange(
                start: DateTime.now().subtract(const Duration(days: 30)),
                end: DateTime.now(),
              ),
            );
            if (dateRange != null) {
              setState(() {
                _selectedDateRange = dateRange;
              });
              _calculateAnalytics();
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[800] : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? Colors.grey[600]! : Colors.grey[300]!,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.date_range_rounded,
                  size: 20,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _selectedDateRange != null
                        ? '${_formatDate(_selectedDateRange!.start)} - ${_formatDate(_selectedDateRange!.end)}'
                        : 'Select date range',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isDark ? Colors.grey[300] : Colors.grey[700],
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_drop_down_rounded,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _getFilterSummaryText() {
    String clientText = _selectedClient == 'all' ? 'All Clients' : _getSelectedClientName();
    
    if (_selectedDateRange != null) {
      return 'Showing data for $clientText (${_formatDate(_selectedDateRange!.start)} - ${_formatDate(_selectedDateRange!.end)})';
    } else {
      return 'Showing data for $clientText (${_selectedPeriod.toUpperCase()} view)';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Loading reports...'),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _exportReport,
            tooltip: 'Export Report',
          ),
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: _printReport,
            tooltip: 'Print Report',
          ),
        ],
      ),
      body: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Filters Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Filters',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        if (constraints.maxWidth < 600) {
                          // Stack vertically on smaller screens
                          return Column(
                      children: [
                              // Date Range Picker
                              _buildDateRangeField(),
                              const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          initialValue: _selectedPeriod,
                          decoration: const InputDecoration(
                            labelText: 'Period',
                            border: OutlineInputBorder(),
                          ),
                          items: const [
                                  DropdownMenuItem(value: 'daily', child: Text('Daily')),
                                  DropdownMenuItem(value: 'weekly', child: Text('Weekly')),
                                  DropdownMenuItem(value: 'monthly', child: Text('Monthly')),
                                  DropdownMenuItem(value: 'yearly', child: Text('Yearly')),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _selectedPeriod = value;
                              });
                              _calculateAnalytics();
                            }
                          },
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          initialValue: _selectedClient,
                          decoration: const InputDecoration(
                                  labelText: 'Client',
                            border: OutlineInputBorder(),
                          ),
                          items: [
                                  const DropdownMenuItem(value: 'all', child: Text('All Clients')),
                                  ..._users.map((user) => DropdownMenuItem(
                                    value: user.id,
                                    child: Text(
                                      user.name,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  )),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _selectedClient = value;
                              });
                              _calculateAnalytics();
                            }
                          },
                        ),
                      ],
                          );
                        } else {
                          // Side by side on larger screens
                          return Column(
                            children: [
                              // Date Range Picker (full width)
                              _buildDateRangeField(),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: DropdownButtonFormField<String>(
                                      initialValue: _selectedPeriod,
                                      decoration: const InputDecoration(
                                        labelText: 'Period',
                                        border: OutlineInputBorder(),
                                      ),
                                      items: const [
                                        DropdownMenuItem(value: 'daily', child: Text('Daily')),
                                        DropdownMenuItem(value: 'weekly', child: Text('Weekly')),
                                        DropdownMenuItem(value: 'monthly', child: Text('Monthly')),
                                        DropdownMenuItem(value: 'yearly', child: Text('Yearly')),
                                      ],
                                      onChanged: (value) {
                                        if (value != null) {
                                          setState(() {
                                            _selectedPeriod = value;
                                          });
                                          _calculateAnalytics();
                                        }
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: DropdownButtonFormField<String>(
                                      initialValue: _selectedClient,
                                      decoration: const InputDecoration(
                                        labelText: 'Client',
                                        border: OutlineInputBorder(),
                                      ),
                                      items: [
                                        const DropdownMenuItem(value: 'all', child: Text('All Clients')),
                                        ..._users.map((user) => DropdownMenuItem(
                                          value: user.id,
                                          child: Text(
                                            user.name,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        )),
                                      ],
                                      onChanged: (value) {
                                        if (value != null) {
                                          setState(() {
                                            _selectedClient = value;
                                          });
                                          _calculateAnalytics();
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        }
                      },
                    ),
                  ],
                ),
                    ),
                  ),
                  const SizedBox(height: 16),

            // Analytics Cards
                        Row(
                          children: [
                Text(
                  'Analytics',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (_selectedClient != 'all') ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Filtered by: ${_getSelectedClientName()}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 16),
            
            // Filter Summary
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.filter_alt,
                    color: Theme.of(context).colorScheme.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _getFilterSummaryText(),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.5,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
                          children: [
                _buildStatCard(
                  'Total Amount',
                  '₹${_totalAmount.toStringAsFixed(2)}',
                  Icons.account_balance_wallet,
                  Colors.blue,
                ),
                _buildStatCard(
                  'Transactions',
                  _totalTransactions.toString(),
                  Icons.receipt,
                  Colors.green,
                ),
                _buildStatCard(
                                'Average',
                                '₹${_averageAmount.toStringAsFixed(2)}',
                                Icons.trending_up,
                                Colors.orange,
                              ),
                _buildStatCard(
                  'Clients',
                  _users.length.toString(),
                  Icons.people,
                                Colors.purple,
                            ),
                          ],
                        ),
            const SizedBox(height: 24),

            // Payment Mode Chart
                  CardWidget(
                    title: 'Payment Mode Distribution',
              child: _buildPaymentModeChart(),
                  ),
                  const SizedBox(height: 16),

            // Client-wise Analytics Chart
                  CardWidget(
              title: 'Client-wise Analytics',
              child: _buildClientBreakdownChart(),
                  ),
                  const SizedBox(height: 16),

            // Daily Transaction Summary (if date range is selected)
            if (_selectedDateRange != null)
              CardWidget(
                title: 'Daily Transaction Summary',
                child: _buildDailyTransactionSummary(),
              ),
            
            // Recent Transactions
            CardWidget(
              title: 'Recent Transactions',
              child: _buildTransactionList(),
            ),
                ],
              ),
      ),
    );
  }

  Widget _buildPaymentModeChart() {
    if (_paymentModeBreakdown.isEmpty) {
      return SizedBox(
        height: 300,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.pie_chart,
                size: 48,
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
              ),
              const SizedBox(height: 8),
              Text(
                'No payment data available',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final entries = _paymentModeBreakdown.entries.toList();
    final labels = entries.map((e) => e.key).toList();
    final values = entries.map((e) => e.value).toList();

    return DoughnutChartWidget(
      labels: labels,
      values: values,
      onElementClick: (index, label) {
        if (index >= 0 && index < labels.length && index < values.length) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$label: ₹${values[index].toStringAsFixed(2)}'),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      },
    );
  }

  Widget _buildClientBreakdownChart() {
    if (_clientBreakdown.isEmpty) {
      return SizedBox(
        height: 300,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.people,
                size: 48,
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
              ),
              const SizedBox(height: 8),
              Text(
                'No client data available',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final sortedEntries = _clientBreakdown.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final labels = sortedEntries.map((e) => e.key).toList();
    final values = sortedEntries.map((e) => e.value).toList();

    return BarChartWidget(
      labels: labels,
      values: values,
      maxY: values.isNotEmpty ? values.reduce((a, b) => a > b ? a : b) * 1.2 : 100,
      onElementClick: (index, label) {
        if (index >= 0 && index < labels.length && index < values.length) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$label: ₹${values[index].toStringAsFixed(2)}'),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      },
    );
  }

  Widget _buildTransactionList() {
    final transactions = _getFilteredTransactions();

    if (transactions.isEmpty) {
      return SizedBox(
        height: 150,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.receipt_long,
                size: 48,
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
              ),
              const SizedBox(height: 8),
              Text(
                'No transactions found',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: transactions.length > 10 ? 10 : transactions.length,
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        return _buildTransactionItem(transaction);
      },
    );
  }

  Widget _buildTransactionItem(Transaction transaction) {
    final user = _users.firstWhere(
      (u) => u.id == transaction.userId,
      orElse: () => User(
        id: 'unknown',
        name: 'Unknown User',
        mobileNumber: '0000000000',
        serialNumber: '000',
        status: UserStatus.active,
        createdAt: DateTime.now(),
        schemes: [],
        permanentAddress: Address(
          doorNumber: '0',
          street: 'Unknown',
          area: 'Unknown',
          localAddress: 'Unknown',
          city: 'Unknown',
          district: 'Unknown',
          state: 'Unknown',
          pinCode: '000000',
        ),
      ),
    );

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: Text(
            user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Text(user.name),
        subtitle: Text(
          '${transaction.date.day}/${transaction.date.month}/${transaction.date.year}',
        ),
        trailing: Text(
          '₹${transaction.amount.toStringAsFixed(2)}',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }

  void _exportReport() {
    final transactions = _getFilteredTransactions();
    final report = StringBuffer();
    
    report.writeln('Financial Report');
    report.writeln('Generated: ${DateTime.now()}');
    report.writeln('Period: $_selectedPeriod');
    report.writeln('Client: ${_getSelectedClientName()}');
    report.writeln('');
    report.writeln('Summary:');
    report.writeln('Total Amount: ₹${_totalAmount.toStringAsFixed(2)}');
    report.writeln('Total Transactions: $_totalTransactions');
    report.writeln('Average Amount: ₹${_averageAmount.toStringAsFixed(2)}');
    report.writeln('');
    report.writeln('Transactions:');
    
    for (var transaction in transactions) {
      final user = _users.firstWhere(
        (u) => u.id == transaction.userId,
        orElse: () => User(
          id: 'unknown',
          name: 'Unknown User',
          mobileNumber: '0000000000',
          serialNumber: '000',
          status: UserStatus.active,
          createdAt: DateTime.now(),
          schemes: [],
          permanentAddress: Address(
            doorNumber: '0',
            street: 'Unknown',
            area: 'Unknown',
            localAddress: 'Unknown',
            city: 'Unknown',
            district: 'Unknown',
            state: 'Unknown',
            pinCode: '000000',
          ),
        ),
      );
      
      report.writeln('${transaction.date.day}/${transaction.date.month}/${transaction.date.year} - ${user.name} - ₹${transaction.amount.toStringAsFixed(2)}');
    }
    
    Clipboard.setData(ClipboardData(text: report.toString()));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Report copied to clipboard')),
    );
  }

  void _printReport() {
    _exportReport();
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
              Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                color: color,
              ),
              ),
            ],
          ),
      ),
    );
  }

  Widget _buildDailyTransactionSummary() {
    final filteredTransactions = _getFilteredTransactions();
    
    if (filteredTransactions.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(
              Icons.receipt_long_rounded,
              size: 48,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 12),
            Text(
              'No transactions found for selected date range',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      );
    }

    // Group transactions by date
    Map<String, List<Transaction>> transactionsByDate = {};
    for (var transaction in filteredTransactions) {
      final dateKey = _formatDate(transaction.date);
      transactionsByDate.putIfAbsent(dateKey, () => []).add(transaction);
    }

    return Column(
      children: transactionsByDate.entries.map((entry) {
        final date = entry.key;
        final transactions = entry.value;
        final totalAmount = transactions.fold(0.0, (sum, t) => sum + t.amount);
        
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date header
              Row(
                children: [
                  Icon(
                    Icons.calendar_today_rounded,
                    size: 20,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    date,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '₹${totalAmount.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              
              // Users who made transactions
              Text(
                'Users who made transactions:',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 8),
              
              // List of users
              ...transactions.map<Widget>((transaction) {
                final user = _users.firstWhere(
                  (u) => u.id == transaction.userId,
                  orElse: () => User(
                    id: 'unknown',
                    name: 'Unknown User',
                    mobileNumber: '0000000000',
                    serialNumber: '000',
                    status: UserStatus.active,
                    createdAt: DateTime.now(),
                    schemes: [],
                    permanentAddress: Address(
                      doorNumber: '0',
                      street: 'Unknown',
                      area: 'Unknown',
                      localAddress: 'Unknown',
                      city: 'Unknown',
                      district: 'Unknown',
                      state: 'Unknown',
                      pinCode: '000000',
                    ),
                  ),
                );
                
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                        child: Text(
                          user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.name,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              'Serial: ${user.serialNumber} • ${user.mobileNumber}',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '₹${transaction.amount.toStringAsFixed(2)}',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          Text(
                            _getPaymentModeString(transaction.paymentMode),
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        );
      }).toList(),
    );
  }
}