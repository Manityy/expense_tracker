import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../home/home_page.dart';
import '../expenses/expense_list_page.dart';
import '../expenses/analytics_page.dart';
import '../subscriptions/subscriptions_page.dart';
import '../profile/profile_page.dart';
import '../../providers/data_providers.dart';
import '../../services/app_background_service.dart';

class MainNavigationPage extends ConsumerStatefulWidget {
  const MainNavigationPage({super.key});

  @override
  ConsumerState<MainNavigationPage> createState() =>
      _MainNavigationPageState();
}

class _MainNavigationPageState
    extends ConsumerState<MainNavigationPage> {
  int selectedIndex = 0;

  final pages = [
    const HomePage(),
    const ExpenseListPage(),
    AnalyticsPage(),
    const SubscriptionsPage(),
    const ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    _runBackgroundTasks();
  }

  Future<void> _runBackgroundTasks() async {
    await AppBackgroundService.runStartupTasks(
      ref.read(firestoreServiceProvider),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[selectedIndex],

      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,

        onDestinationSelected: (index) {
          setState(() {
            selectedIndex = index;
          });
        },

        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),

          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long),
            label: 'Expenses',
          ),

          NavigationDestination(
            icon: Icon(Icons.pie_chart_outline),
            selectedIcon: Icon(Icons.pie_chart),
            label: 'Analytics',
          ),

          NavigationDestination(
            icon: Icon(Icons.repeat_outlined),
            selectedIcon: Icon(Icons.repeat),
            label: 'Subs',
          ),

          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}