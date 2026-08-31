import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Finance Tracker',
            debugShowCheckedModeBanner: false,
            theme: themeProvider.lightTheme,
            darkTheme: themeProvider.darkTheme,
            themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: const MainScreen(),
          );
        },
      ),
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationProvider>(
      builder: (context, navigationProvider, child) {
        return Scaffold(
          appBar: AppBarWidget(viewId: navigationProvider.currentView),
          body: ScreenWidget(viewId: navigationProvider.currentView),
          bottomNavigationBar: BottomNavWidget(navigationProvider: navigationProvider),
        );
      },
    );
  }
}

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final ViewId viewId;
  const AppBarWidget({super.key, required this.viewId});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return AppBar(
      title: Text(_getTitle(viewId)),
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: [
        IconButton(
          icon: Icon(themeProvider.isDarkMode ? Icons.light_mode_rounded : Icons.dark_mode_rounded),
          onPressed: () => themeProvider.toggleTheme(),
        ),
      ],
    );
  }

  String _getTitle(ViewId id) {
    switch (id) {
      case ViewId.dashboard: return 'Dashboard';
      case ViewId.users: return 'User Management';
      case ViewId.entry: return 'Daily Entry';
      case ViewId.reports: return 'Reports';
      case ViewId.payments: return 'Payment Handling';
      case ViewId.notifications: return 'Notifications';
      case ViewId.bonus: return 'Bonus Management';
      default: return 'Finance Tracker';
    }
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class ScreenWidget extends StatelessWidget {
  final ViewId viewId;
  const ScreenWidget({super.key, required this.viewId});

  @override
  Widget build(BuildContext context) {
    switch (viewId) {
      case ViewId.dashboard: return const Center(child: Text('Dashboard'));
      case ViewId.users: return const Center(child: Text('User Management'));
      case ViewId.entry: return const Center(child: Text('Daily Entry'));
      case ViewId.reports: return const Center(child: Text('Reports'));
      case ViewId.payments: return const Center(child: Text('Payment Handling'));
      case ViewId.notifications: return const Center(child: Text('Notifications'));
      case ViewId.bonus: return const Center(child: Text('Bonus Management'));
      default: return const Center(child: Text('Unknown View'));
    }
  }
}

class BottomNavWidget extends StatelessWidget {
  final NavigationProvider navigationProvider;
  const BottomNavWidget({super.key, required this.navigationProvider});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: navigationProvider.currentView.index <= 4 ? navigationProvider.currentView.index : 0,
      type: BottomNavigationBarType.fixed,
      onTap: (index) => navigationProvider.navigateTo(ViewId.values[index]),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.dashboard_rounded), label: 'Dashboard'),
        BottomNavigationBarItem(icon: Icon(Icons.people_rounded), label: 'Users'),
        BottomNavigationBarItem(icon: Icon(Icons.add_card_rounded), label: 'Entry'),
        BottomNavigationBarItem(icon: Icon(Icons.analytics_rounded), label: 'Reports'),
        BottomNavigationBarItem(icon: Icon(Icons.payments_rounded), label: 'Payments'),
      ],
    );
  }
}

class NavigationProvider extends ChangeNotifier {
  ViewId currentView = ViewId.dashboard;
  void navigateTo(ViewId view) {
    currentView = view;
    notifyListeners();
  }
}

class ThemeProvider extends ChangeNotifier {
  bool isDarkMode = false;
  ThemeData get lightTheme => ThemeData.light();
  ThemeData get darkTheme => ThemeData.dark();
  void toggleTheme() {
    isDarkMode = !isDarkMode;
    notifyListeners();
  }
}

enum ViewId { dashboard, users, entry, reports, payments, notifications, bonus }
