import 'package:flutter/material.dart';
import '../models/scheme_type.dart';
import '../models/user.dart';
import '../models/user_scheme.dart';
import '../services/storage_service.dart';
import '../utils/calculations.dart';

class SchemeManagementScreen extends StatefulWidget {
  const SchemeManagementScreen({super.key});

  @override
  State<SchemeManagementScreen> createState() => _SchemeManagementScreenState();
}

class _SchemeManagementScreenState extends State<SchemeManagementScreen>
    with TickerProviderStateMixin {
  final StorageService _storageService = StorageService.instance;
  final TextEditingController _searchController = TextEditingController();

  List<SchemeType> _schemes = [];
  List<SchemeType> _filteredSchemes = [];
  List<User> _users = [];
  bool _isLoading = true;
  String _searchQuery = '';
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
      // Only 3 schemes: Savings, Gold, Furniture - NO STORAGE LOADING
      final schemes = [
        SchemeType(
          id: '1',
          name: 'Savings',
          description: 'Regular savings scheme with competitive interest rates',
          interestRate: 8.5,
          amount: 10000,
          duration: 365,
          frequency: Frequency.monthly,
        ),
        SchemeType(
          id: '2',
          name: 'Gold',
          description: 'Gold investment scheme with flexible payment options',
          interestRate: 10.2,
          amount: 50000,
          duration: 365,
          frequency: Frequency.monthly,
        ),
        SchemeType(
          id: '3',
          name: 'Furniture',
          description: 'Furniture purchase scheme with installment options',
          interestRate: 12.0,
          amount: 100000,
          duration: 365,
          frequency: Frequency.monthly,
        ),
      ];
      
      final users = await _storageService.getUsers();

      setState(() {
        _schemes = schemes;
        _filteredSchemes = schemes;
        _users = users;
      });
    } finally {
      setState(() => _isLoading = false);
      _animationController.forward();
    }
  }

  void _filterSchemes() {
    setState(() {
      _filteredSchemes = _schemes.where((scheme) {
        bool matchesSearch =
            _searchQuery.isEmpty ||
            scheme.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            scheme.description.toLowerCase().contains(
              _searchQuery.toLowerCase(),
            );

        return matchesSearch;
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
                              'Scheme Management',
                              style: theme.textTheme.titleLarge?.copyWith(
                                color: theme.colorScheme.onSurface,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Spacer(),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'View and manage the 3 available schemes',
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

          // Search Section
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: TextFormField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search schemes by name or description...',
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
                  _filterSchemes();
                },
              ),
            ),
          ),

          // Schemes List
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
                            'Loading schemes...',
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
              : _filteredSchemes.isEmpty
              ? SliverToBoxAdapter(
                  child: SizedBox(
                    height: 300,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.savings_outlined,
                            size: 64,
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.3,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No schemes found',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: 0.6,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Create your first scheme to get started',
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
                    final scheme = _filteredSchemes[index];
                    return FadeTransition(
                      opacity: _fadeAnimation,
                      child: _buildSchemeCard(scheme, index),
                    );
                  }, childCount: _filteredSchemes.length),
                ),
        ],
      ),
    );
  }

  Widget _buildSchemeCard(SchemeType scheme, int index) {
    final theme = Theme.of(context);
    final userCount = _users
        .where(
          (user) => user.schemes.any(
            (userScheme) => userScheme.schemeType.id == scheme.id,
          ),
        )
        .length;

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
                    color: _getSchemeColor(
                      scheme.frequency,
                    ).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Icon(
                    _getSchemeIcon(scheme.frequency),
                    color: _getSchemeColor(scheme.frequency),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        scheme.name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        scheme.description,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.6,
                          ),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    switch (value) {
                      case 'edit':
                        _showEditSchemeDialog(scheme);
                        break;
                      case 'assign':
                        _showAssignSchemeDialog(scheme);
                        break;
                      case 'assign_client':
                        _showAssignToClientDialog(scheme);
                        break;
                      case 'amounts':
                        _showEditClientAmountDialog(scheme);
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit_rounded, size: 20),
                          SizedBox(width: 8),
                          Text('Edit Scheme'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'assign',
                      child: Row(
                        children: [
                          Icon(Icons.person_add_rounded, size: 20),
                          SizedBox(width: 8),
                          Text('Assign to Users'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'assign_client',
                      child: Row(
                        children: [
                          Icon(Icons.person_add_alt_1_rounded, size: 20),
                          SizedBox(width: 8),
                          Text('Assign to Client'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'amounts',
                      child: Row(
                        children: [
                          Icon(Icons.currency_rupee_rounded, size: 20),
                          SizedBox(width: 8),
                          Text('Edit Client Amounts'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Scheme Details
            Row(
              children: [
                Expanded(
                  child: _buildDetailChip(
                    context,
                    'Interest Rate',
                    '${scheme.interestRate.toStringAsFixed(1)}%',
                    Icons.trending_up_rounded,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildDetailChip(
                    context,
                    'Duration',
                    '${scheme.duration} days',
                    Icons.schedule_rounded,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            Row(
              children: [
                Expanded(
                  child: _buildDetailChip(
                    context,
                    'Amount',
                    '₹${Calculations.formatCurrency(scheme.amount)}',
                    Icons.currency_rupee_rounded,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildDetailChip(
                    context,
                    'Frequency',
                    scheme.frequency.toString().split('.').last.toUpperCase(),
                    Icons.repeat_rounded,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Users Count
            Row(
              children: [
                Icon(
                  Icons.people_rounded,
                  size: 16,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
                const SizedBox(width: 8),
                Text(
                  '$userCount users assigned',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getSchemeColor(
                      scheme.frequency,
                    ).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    scheme.frequency.toString().split('.').last.toUpperCase(),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: _getSchemeColor(scheme.frequency),
                      fontWeight: FontWeight.w600,
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

  Widget _buildDetailChip(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 14,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    fontSize: 10,
                  ),
                ),
                Text(
                  value,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getSchemeColor(Frequency frequency) {
    switch (frequency) {
      case Frequency.daily:
        return const Color(0xFF3B82F6);
      case Frequency.weekly:
        return const Color(0xFF10B981);
      case Frequency.monthly:
        return const Color(0xFF8B5CF6);
      case Frequency.lumpsum:
        return const Color(0xFFF59E0B);
    }
  }

  IconData _getSchemeIcon(Frequency frequency) {
    switch (frequency) {
      case Frequency.daily:
        return Icons.today_rounded;
      case Frequency.weekly:
        return Icons.date_range_rounded;
      case Frequency.monthly:
        return Icons.calendar_month_rounded;
      case Frequency.lumpsum:
        return Icons.account_balance_wallet_rounded;
    }
  }


  void _showEditSchemeDialog(SchemeType scheme) {
    showDialog(
      context: context,
      builder: (context) => _SchemeDialog(
        scheme: scheme,
        onSave: (updatedScheme) async {
          // Update the scheme in the local list
          setState(() {
            final index = _schemes.indexWhere((s) => s.id == updatedScheme.id);
            if (index >= 0) {
              _schemes[index] = updatedScheme;
              _filteredSchemes = _schemes;
            }
          });
        },
      ),
    );
  }

  void _showAssignToClientDialog(SchemeType scheme) {
    showDialog(
      context: context,
      builder: (context) => _AssignToClientDialog(
        scheme: scheme,
        users: _users,
        onAssign: (userId, amount) async {
          final navigator = Navigator.of(context);
          final messenger = ScaffoldMessenger.of(context);
          final user = _users.firstWhere((u) => u.id == userId);
          final userScheme = UserScheme(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            userId: userId,
            schemeType: scheme,
            startDate: DateTime.now(),
            duration: scheme.duration,
            totalAmount: amount,
            interestRate: scheme.interestRate,
            currentBalance: 0.0,
            status: SchemeStatus.active,
          );
          await _storageService.saveUserScheme(userScheme);
          if (mounted) {
            navigator.pop();
            messenger.showSnackBar(
              SnackBar(
                content: Text('${user.name} assigned to ${scheme.name} with ₹${amount.toStringAsFixed(2)}'),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
      ),
    );
  }

  void _showEditClientAmountDialog(SchemeType scheme) async {
    final userSchemes = await _storageService.getUserSchemes();
    final schemeUsers = userSchemes.where((us) => us.schemeType.id == scheme.id).toList();
    
    if (!mounted) return;
    
    if (schemeUsers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No users assigned to this scheme')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => _ClientAmountDialog(
        scheme: scheme,
        userSchemes: schemeUsers,
        onSave: () async {
          if (mounted) {
            await _loadData(); // Reload data to show updated amounts
          }
        },
      ),
    );
  }

  void _showAssignSchemeDialog(SchemeType scheme) {
    showDialog(
      context: context,
      builder: (context) => _AssignSchemeDialog(
        scheme: scheme,
        users: _users,
        onAssign: (userIds) async {
          for (final userId in userIds) {
            final user = _users.firstWhere((u) => u.id == userId);
            final userScheme = UserScheme(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              userId: userId,
              schemeType: scheme,
              startDate: DateTime.now(),
              duration: scheme.duration,
              totalAmount: scheme.amount,
              interestRate: scheme.interestRate,
              currentBalance: 0.0,
              status: SchemeStatus.active,
            );
            await _storageService.saveUserScheme(userScheme);

            final updatedUser = user.copyWith(
              schemes: [...user.schemes, userScheme],
            );
            await _storageService.saveUser(updatedUser);
          }
          _loadData();
        },
      ),
    );
  }

}

class _SchemeDialog extends StatefulWidget {
  final SchemeType? scheme;
  final Function(SchemeType) onSave;

  const _SchemeDialog({this.scheme, required this.onSave});

  @override
  State<_SchemeDialog> createState() => _SchemeDialogState();
}

class _SchemeDialogState extends State<_SchemeDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _interestRateController = TextEditingController();
  final _amountController = TextEditingController();
  final _durationController = TextEditingController();
  Frequency _selectedFrequency = Frequency.monthly;

  @override
  void initState() {
    super.initState();
    if (widget.scheme != null) {
      _nameController.text = widget.scheme!.name;
      _descriptionController.text = widget.scheme!.description;
      _interestRateController.text = widget.scheme!.interestRate.toString();
      _amountController.text = widget.scheme!.amount.toString();
      _durationController.text = widget.scheme!.duration.toString();
      _selectedFrequency = widget.scheme!.frequency;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _interestRateController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.savings_rounded,
                      color: theme.colorScheme.primary,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        widget.scheme == null
                            ? 'Add New Scheme'
                            : 'Edit Scheme',
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

                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Scheme Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter scheme name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                Column(
                  children: [
                    TextFormField(
                      controller: _interestRateController,
                      decoration: const InputDecoration(
                        labelText: 'Interest Rate (%)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Invalid number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<Frequency>(
                      initialValue: _selectedFrequency,
                      decoration: const InputDecoration(
                        labelText: 'Collection Period',
                        border: OutlineInputBorder(),
                      ),
                      items: Frequency.values.map((frequency) {
                        return DropdownMenuItem(
                          value: frequency,
                          child: Text(
                            frequency
                                .toString()
                                .split('.')
                                .last
                                .toUpperCase(),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedFrequency = value!;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _amountController,
                  decoration: const InputDecoration(
                    labelText: 'Amount (₹)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Invalid number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _durationController,
                  decoration: const InputDecoration(
                    labelText: 'Duration (days)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter duration';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Invalid number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: _saveScheme,
                      child: Text(widget.scheme == null ? 'Create' : 'Update'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _saveScheme() {
    if (_formKey.currentState!.validate()) {
      final scheme = SchemeType(
        id: widget.scheme?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        description: _descriptionController.text,
        interestRate: double.parse(_interestRateController.text),
        amount: double.tryParse(_amountController.text) ?? 0.0,
        duration: int.parse(_durationController.text),
        frequency: _selectedFrequency,
      );

      widget.onSave(scheme);
      Navigator.of(context).pop();
    }
  }
}

class _AssignSchemeDialog extends StatefulWidget {
  final SchemeType scheme;
  final List<User> users;
  final Function(List<String>) onAssign;

  const _AssignSchemeDialog({
    required this.scheme,
    required this.users,
    required this.onAssign,
  });

  @override
  State<_AssignSchemeDialog> createState() => _AssignSchemeDialogState();
}

class _AssignSchemeDialogState extends State<_AssignSchemeDialog> {
  final Set<String> _selectedUserIds = <String>{};

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.7,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.person_add_rounded,
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Assign "${widget.scheme.name}" to Users',
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
            const SizedBox(height: 16),

            Expanded(
              child: ListView.builder(
                itemCount: widget.users.length,
                itemBuilder: (context, index) {
                  final user = widget.users[index];
                  final isAlreadyAssigned = user.schemes.any(
                    (userScheme) =>
                        userScheme.schemeType.id == widget.scheme.id,
                  );

                  return CheckboxListTile(
                    title: Text(user.name),
                    subtitle: Text(user.mobileNumber),
                    value: _selectedUserIds.contains(user.id),
                    enabled: !isAlreadyAssigned,
                    onChanged: isAlreadyAssigned
                        ? null
                        : (value) {
                            setState(() {
                              if (value == true) {
                                _selectedUserIds.add(user.id);
                              } else {
                                _selectedUserIds.remove(user.id);
                              }
                            });
                          },
                    secondary: isAlreadyAssigned
                        ? Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'Already Assigned',
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          )
                        : null,
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _selectedUserIds.isEmpty
                      ? null
                      : () {
                          widget.onAssign(_selectedUserIds.toList());
                          Navigator.of(context).pop();
                        },
                  child: Text('Assign (${_selectedUserIds.length})'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ClientAmountDialog extends StatefulWidget {
  final SchemeType scheme;
  final List<UserScheme> userSchemes;
  final VoidCallback onSave;

  const _ClientAmountDialog({
    required this.scheme,
    required this.userSchemes,
    required this.onSave,
  });

  @override
  State<_ClientAmountDialog> createState() => _ClientAmountDialogState();
}

class _ClientAmountDialogState extends State<_ClientAmountDialog> {
  final StorageService _storageService = StorageService.instance;
  final Map<String, TextEditingController> _amountControllers = {};

  @override
  void initState() {
    super.initState();
    for (final userScheme in widget.userSchemes) {
      _amountControllers[userScheme.id] = TextEditingController(
        text: userScheme.totalAmount.toString(),
      );
    }
  }

  @override
  void dispose() {
    for (final controller in _amountControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit Client Amounts - ${widget.scheme.name}'),
      content: SizedBox(
        width: double.maxFinite,
        height: 400,
        child: ListView.builder(
          itemCount: widget.userSchemes.length,
          itemBuilder: (context, index) {
            final userScheme = widget.userSchemes[index];
            
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'User ID: ${userScheme.userId}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _amountControllers[userScheme.id],
                      decoration: const InputDecoration(
                        labelText: 'Amount (₹)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Amount is required';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid amount';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () async {
            final navigator = Navigator.of(context);
            final messenger = ScaffoldMessenger.of(context);
            
            for (final userScheme in widget.userSchemes) {
              final controller = _amountControllers[userScheme.id];
              if (controller != null && controller.text.isNotEmpty) {
                final newAmount = double.parse(controller.text);
                final updatedScheme = userScheme.copyWith(
                  totalAmount: newAmount,
                );
                await _storageService.saveUserScheme(updatedScheme);
              }
            }
            widget.onSave();
            if (mounted) {
              navigator.pop();
              messenger.showSnackBar(
                const SnackBar(content: Text('Client amounts updated successfully!')),
              );
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}

class _AssignToClientDialog extends StatefulWidget {
  final SchemeType scheme;
  final List<User> users;
  final Function(String userId, double amount) onAssign;

  const _AssignToClientDialog({
    required this.scheme,
    required this.users,
    required this.onAssign,
  });

  @override
  State<_AssignToClientDialog> createState() => _AssignToClientDialogState();
}

class _AssignToClientDialogState extends State<_AssignToClientDialog> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  User? _selectedUser;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Assign ${widget.scheme.name} to Client'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<User>(
              initialValue: _selectedUser,
              decoration: const InputDecoration(
                labelText: 'Select Client',
                border: OutlineInputBorder(),
              ),
              items: widget.users.map((user) {
                return DropdownMenuItem(
                  value: user,
                  child: Text('${user.name} (${user.serialNumber})'),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedUser = value;
                });
              },
              validator: (value) => value == null ? 'Please select a client' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _amountController,
              decoration: const InputDecoration(
                labelText: 'Amount (₹)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Amount is required';
                }
                if (double.tryParse(value) == null) {
                  return 'Please enter a valid amount';
                }
                return null;
              },
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
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final amount = double.parse(_amountController.text);
              widget.onAssign(_selectedUser!.id, amount);
            }
          },
          child: const Text('Assign'),
        ),
      ],
    );
  }
}
