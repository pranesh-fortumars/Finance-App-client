import 'package:flutter/material.dart';
import '../models/user.dart';
import '../models/address.dart';
import '../models/transaction.dart';
import '../services/storage_service.dart';
import '../widgets/common/card_widget.dart';

class BonusScreen extends StatefulWidget {
  const BonusScreen({super.key});

  @override
  State<BonusScreen> createState() => _BonusScreenState();
}

class _BonusScreenState extends State<BonusScreen> {
  final StorageService _storageService = StorageService.instance;
  
  List<User> _users = [];
  List<Transaction> _transactions = [];
  bool _isLoading = true;
  String _selectedClient = 'all';

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

      setState(() {
        _users = users;
        _transactions = transactions;
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Map<String, double> _getClientBonuses() {
    Map<String, double> clientBonuses = {};
    
    if (_transactions.isNotEmpty) {
      for (var transaction in _transactions) {
        if (transaction.interest > 0) { // interest field stores bonus amount
          final userId = transaction.userId;
          clientBonuses[userId] = (clientBonuses[userId] ?? 0.0) + transaction.interest;
        }
      }
    }
    
    return clientBonuses;
  }

  List<Transaction> _getFilteredTransactions() {
    if (_transactions.isEmpty) return [];
    
    if (_selectedClient == 'all') {
      return _transactions.where((t) => t.interest > 0).toList();
    }
    return _transactions.where((t) => t.userId == _selectedClient && t.interest > 0).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final clientBonuses = _getClientBonuses();
    final filteredTransactions = _getFilteredTransactions();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bonus Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showGiveBonusDialog,
            tooltip: 'Give Bonus',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Filters
            CardWidget(
              title: 'Filters',
              child:               DropdownButtonFormField<String>(
                initialValue: _selectedClient,
                decoration: const InputDecoration(
                  labelText: 'Select Client',
                  border: OutlineInputBorder(),
                ),
                items: [
                  const DropdownMenuItem(value: 'all', child: Text('All Clients')),
                  ..._users.map((user) => DropdownMenuItem(
                    value: user.id,
                    child: Text('${user.name} (${user.serialNumber})'),
                  )),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedClient = value!;
                  });
                },
              ),
            ),
            const SizedBox(height: 16),

            // Total Bonus Summary
            CardWidget(
              title: 'Bonus Summary',
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          'Total Bonus Paid',
                          '₹${clientBonuses.values.fold(0.0, (sum, bonus) => sum + bonus).toStringAsFixed(2)}',
                          Icons.account_balance_wallet,
                          Colors.green,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildStatCard(
                          'Clients with Bonus',
                          '${clientBonuses.length}',
                          Icons.people,
                          Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // All Clients with Bonuses
            CardWidget(
              title: 'All Clients & Their Bonuses',
              child: _buildAllClientsList(clientBonuses),
            ),
            const SizedBox(height: 16),

            // Bonus Transactions
            CardWidget(
              title: 'Bonus Transactions',
              child: _buildBonusTransactionsList(filteredTransactions),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAllClientsList(Map<String, double> clientBonuses) {
    return Column(
      children: _users.map((user) {
        final bonusAmount = clientBonuses[user.id] ?? 0.0;
        
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: bonusAmount > 0 
                    ? Colors.green.withValues(alpha: 0.1)
                    : Colors.grey.withValues(alpha: 0.1),
                child: Text(
                  user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
                  style: TextStyle(
                    color: bonusAmount > 0 ? Colors.green : Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Serial: ${user.serialNumber} • ${user.mobileNumber}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '₹${bonusAmount.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: bonusAmount > 0 ? Colors.green : Colors.grey,
                    ),
                  ),
                  Text(
                    bonusAmount > 0 ? 'Total Bonus' : 'No Bonus',
                    style: TextStyle(
                      color: bonusAmount > 0 ? Colors.green : Colors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                onPressed: () => _showGiveBonusDialog(selectedUserId: user.id),
                tooltip: 'Give Bonus',
                color: Colors.blue,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBonusTransactionsList(List<Transaction> transactions) {
    if (transactions.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Text('No bonus transactions found'),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final transaction = transactions[index];
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
            color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: Colors.green.withValues(alpha: 0.1),
                child: const Icon(
                  Icons.stars,
                  color: Colors.green,
                  size: 16,
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
                      'Payment: ₹${transaction.amount.toStringAsFixed(2)} • ${transaction.date.day}/${transaction.date.month}/${transaction.date.year}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                    if (transaction.remarks != null && transaction.remarks!.contains('Extra Bonus'))
                      const Text(
                        'Extra Bonus',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '₹${transaction.interest.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const Text(
                    'Bonus',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _showGiveBonusDialog({String? selectedUserId}) {
    final TextEditingController amountController = TextEditingController();
    final TextEditingController remarksController = TextEditingController();
    String? selectedUser = selectedUserId;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Give Extra Bonus'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                initialValue: selectedUser,
                decoration: const InputDecoration(
                  labelText: 'Select Client',
                  border: OutlineInputBorder(),
                ),
                items: _users.map((user) => DropdownMenuItem(
                  value: user.id,
                  child: Text('${user.name} (${user.serialNumber})'),
                )).toList(),
                onChanged: (value) {
                  selectedUser = value;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: amountController,
                decoration: const InputDecoration(
                  labelText: 'Bonus Amount',
                  prefixText: '₹ ',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter bonus amount';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid amount';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: remarksController,
                decoration: const InputDecoration(
                  labelText: 'Remarks (Optional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => _giveBonus(
              selectedUser!,
              double.parse(amountController.text),
              remarksController.text,
            ),
            child: const Text('Give Bonus'),
          ),
        ],
      ),
    );
  }

  Future<void> _giveBonus(String userId, double amount, String remarks) async {
    try {
      // Create a bonus transaction
      final transaction = Transaction(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: userId,
        schemeId: 'bonus',
        amount: 0.0, // No payment amount, just bonus
        paymentMode: PaymentMode.offline,
        date: DateTime.now(),
        interest: amount, // Store bonus in interest field
        remarks: 'Extra Bonus: ${remarks.isNotEmpty ? remarks : 'Manual bonus given'}',
        receiptNumber: 'BONUS${DateTime.now().millisecondsSinceEpoch}',
      );

      await _storageService.saveTransaction(transaction);
      
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Bonus of ₹${amount.toStringAsFixed(2)} given successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        _loadData(); // Refresh data
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error giving bonus: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
