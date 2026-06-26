import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:expense_tracker/l10n/app_localizations.dart';
import '../home/home_page.dart';
import '../expenses/expense_list_page.dart';
import '../expenses/analytics_page.dart';
import '../subscriptions/subscriptions_page.dart';
import '../profile/profile_page.dart';
import '../../providers/data_providers.dart';
import '../../services/app_background_service.dart';
import '../../widgets/tunisian_motif.dart';

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
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: FlousiBackground(
        child: pages[selectedIndex],
      ),

      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,

        onDestinationSelected: (index) {
          setState(() {
            selectedIndex = index;
          });
        },

        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home),
            label: l10n.navHome,
          ),
          NavigationDestination(
            icon: const Icon(Icons.receipt_long_outlined),
            selectedIcon: const Icon(Icons.receipt_long),
            label: l10n.navExpenses,
          ),
          NavigationDestination(
            icon: const Icon(Icons.pie_chart_outline),
            selectedIcon: const Icon(Icons.pie_chart),
            label: l10n.navAnalytics,
          ),
          NavigationDestination(
            icon: const Icon(Icons.repeat_outlined),
            selectedIcon: const Icon(Icons.repeat),
            label: l10n.navSubscriptions,
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline),
            selectedIcon: const Icon(Icons.person),
            label: l10n.navProfile,
          ),
        ],
      ),
    );
  }
}