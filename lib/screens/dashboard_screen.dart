import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/transaction.dart';
import '../models/user.dart';
import '../models/address.dart';
import '../utils/calculations.dart';
import '../widgets/charts/doughnut_chart_widget.dart';
import '../providers/navigation_provider.dart';
import '../providers/data_provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        context.read<DataProvider>().initializeData();
      } catch (e) {
        // Handle initialization error silently
        // The app will continue with default state
      }
    });
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Morning';
    if (hour < 17) return 'Afternoon';
    return 'Evening';
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(
      builder: (context, dataProvider, child) {
        final theme = Theme.of(context);

        if (dataProvider.isLoading) {
          return Scaffold(
            body: Center(
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
                    'Loading dashboard...',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // Fallback for when data fails to load
        if (dataProvider.users.isEmpty && dataProvider.transactions.isEmpty) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: theme.colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Unable to load data',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Please check your connection and try again',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      dataProvider.refreshData();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              // Welcome Header
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        theme.colorScheme.primary,
                        theme.colorScheme.primary.withValues(alpha: 0.8),
                      ],
                    ),
                  ),
                  child: SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Good ${_getGreeting()}!',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Welcome to your finance dashboard',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Stats Grid
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      children: [
                        _buildModernStatCard(
                          context,
                          'Total Customers',
                          dataProvider
                              .getDashboardStats()['totalUsers']
                              .toString(),
                          Icons.people_rounded,
                          const Color(0xFF3B82F6),
                          '+12%',
                          true,
                        ),
                        _buildModernStatCard(
                          context,
                          'Active Schemes',
                          '5', // Active schemes count
                          Icons.savings_rounded,
                          const Color(0xFF10B981),
                          '+8%',
                          true,
                        ),
                        _buildModernStatCard(
                          context,
                          'Total Investment',
                          Calculations.formatCurrency(
                            dataProvider.getDashboardStats()['totalAmount'],
                          ),
                          Icons.trending_up_rounded,
                          const Color(0xFF8B5CF6),
                          '+24%',
                          true,
                        ),
                        _buildModernStatCard(
                          context,
                          'Pending Dues',
                          '₹0', // Pending dues
                          Icons.schedule_rounded,
                          const Color(0xFFF59E0B),
                          '-5%',
                          true,
                        ),
                        _buildModernStatCard(
                          context,
                          'Completed Cycles',
                          '12', // Completed cycles
                          Icons.check_circle_rounded,
                          const Color(0xFF06B6D4),
                          '+3',
                          true,
                        ),
                        _buildModernStatCard(
                          context,
                          'Today\'s Collection',
                          Calculations.formatCurrency(
                            dataProvider.getDashboardStats()['todayAmount'],
                          ),
                          Icons.currency_rupee_rounded,
                          const Color(0xFFEC4899),
                          '+18%',
                          true,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Recent Transactions
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Recent Transactions',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              context.read<NavigationProvider>().navigateTo(
                                ViewId.reports,
                              );
                            },
                            child: Text(
                              'View All',
                              style: TextStyle(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildTransactionsList(dataProvider),
                    ],
                  ),
                ),
              ),

              // Analytics Charts
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: _buildAnalyticsCharts(dataProvider),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildModernStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
    String change,
    bool isPositive,
  ) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[800] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: isDark ? Colors.grey[700]! : Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isPositive
                      ? Colors.green.withValues(alpha: 0.1)
                      : Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  change,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isPositive ? Colors.green : Colors.red,
                    fontWeight: FontWeight.w600,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.grey[100] : Colors.grey[900],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionsList(DataProvider dataProvider) {
    final theme = Theme.of(context);

    if (dataProvider.getRecentTransactions().isEmpty) {
      return Center(
        child: Column(
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 48,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'No recent transactions',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: dataProvider.getRecentTransactions().length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final transaction = dataProvider.getRecentTransactions()[index];
        final user =
            dataProvider.getUserById(transaction.userId) ??
            User(
              id: '',
              name: 'Unknown User',
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
            );

        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _getPaymentModeColor(
                    transaction.paymentMode,
                  ).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  _getPaymentModeIcon(transaction.paymentMode),
                  color: _getPaymentModeColor(transaction.paymentMode),
                  size: 20,
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
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      Calculations.formatDate(transaction.date),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.6,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    Calculations.formatCurrency(transaction.amount),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _getPaymentModeShortName(transaction.paymentMode),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: _getPaymentModeColor(transaction.paymentMode),
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAnalyticsCharts(DataProvider dataProvider) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      children: [
        // Payment Mode Distribution
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? Colors.grey[800] : Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(
              color: isDark ? Colors.grey[700]! : Colors.grey[200]!,
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Payment Mode Distribution',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 200,
                child: DoughnutChartWidget(
                  labels: _getPaymentModeData(dataProvider).keys.toList(),
                  values: _getPaymentModeData(dataProvider).values.toList(),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Monthly Collection Trend
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? Colors.grey[800] : Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(
              color: isDark ? Colors.grey[700]! : Colors.grey[200]!,
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Monthly Collection Analysis',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              _buildMonthlyStats(dataProvider),
            ],
          ),
        ),
      ],
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
        return Icons.offline_bolt_rounded;
      case PaymentMode.card:
        return Icons.credit_card_rounded;
      case PaymentMode.upi:
        return Icons.phone_android_rounded;
      case PaymentMode.netbanking:
        return Icons.account_balance_rounded;
    }
  }

  String _getPaymentModeShortName(PaymentMode mode) {
    switch (mode) {
      case PaymentMode.offline:
        return 'OFFLINE';
      case PaymentMode.card:
        return 'CARD';
      case PaymentMode.upi:
        return 'UPI';
      case PaymentMode.netbanking:
        return 'NET';
    }
  }

  Map<String, double> _getPaymentModeData(DataProvider dataProvider) {
    final transactions = dataProvider.transactions;
    final Map<PaymentMode, double> modeTotals = {};

    for (final transaction in transactions) {
      modeTotals[transaction.paymentMode] =
          (modeTotals[transaction.paymentMode] ?? 0) + transaction.amount;
    }

    return {
      'Offline': modeTotals[PaymentMode.offline] ?? 0,
      'Card': modeTotals[PaymentMode.card] ?? 0,
      'UPI': modeTotals[PaymentMode.upi] ?? 0,
      'Net Banking': modeTotals[PaymentMode.netbanking] ?? 0,
    };
  }

  Widget _buildMonthlyStats(DataProvider dataProvider) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final now = DateTime.now();
    final currentMonth = DateTime(now.year, now.month);
    final lastMonth = DateTime(now.year, now.month - 1);

    final currentMonthTransactions = dataProvider.transactions
        .where(
          (t) => t.date.isAfter(currentMonth.subtract(const Duration(days: 1))),
        )
        .toList();
    final lastMonthTransactions = dataProvider.transactions
        .where(
          (t) =>
              t.date.isAfter(lastMonth.subtract(const Duration(days: 1))) &&
              t.date.isBefore(currentMonth),
        )
        .toList();

    final currentMonthTotal = currentMonthTransactions.fold(
      0.0,
      (sum, t) => sum + t.amount,
    );
    final lastMonthTotal = lastMonthTransactions.fold(
      0.0,
      (sum, t) => sum + t.amount,
    );

    final growth = lastMonthTotal > 0
        ? ((currentMonthTotal - lastMonthTotal) / lastMonthTotal * 100)
        : 0;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'This Month',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
                Text(
                  Calculations.formatCurrency(currentMonthTotal),
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Last Month',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
                Text(
                  Calculations.formatCurrency(lastMonthTotal),
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.grey[300] : Colors.grey[700],
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: growth >= 0
                ? Colors.green.withValues(alpha: 0.1)
                : Colors.red.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                growth >= 0 ? Icons.trending_up : Icons.trending_down,
                color: growth >= 0 ? Colors.green : Colors.red,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                '${growth >= 0 ? '+' : ''}${growth.toStringAsFixed(1)}% from last month',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: growth >= 0 ? Colors.green : Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
