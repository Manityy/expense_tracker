import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'savings_goal_page.dart';
import 'salary_setup_page.dart';
import 'category_budgets_page.dart';
import '../challenges/challenges_page.dart';
import '../../utils/challenges_helper.dart';
import '../../utils/app_colors.dart';
import '../../models/user_model.dart';
import '../../services/firestore_service.dart';
import '../../services/export_service.dart';
import 'app_settings_section.dart';
import 'package:expense_tracker/l10n/app_localizations.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  Future<Map<String, dynamic>> _loadProfileData() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final firestoreService = FirestoreService();
    final results = await Future.wait([
      firestoreService.getUser(userId),
      firestoreService.getThisWeekExpenses(userId),
      firestoreService.getThisWeekendExpenses(userId),
      firestoreService.getLastWeekExpenses(userId),
      firestoreService.getCategorySpendingThisMonth(userId),
      firestoreService.getMonthlyTotalExpenses(userId),
    ]);
    return {
      'userDoc': results[0] as DocumentSnapshot<Map<String, dynamic>>,
      'weekExpenses': results[1] as List<Map<String, dynamic>>,
      'weekendExpenses': results[2] as List<Map<String, dynamic>>,
      'lastWeekExpenses': results[3] as List<Map<String, dynamic>>,
      'monthSpending': results[4] as Map<String, double>,
      'totalExpenses': results[5] as double,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(l10n.profile),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _loadProfileData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData) {
            return Center(child: Text(l10n.unableToLoadProfile));
          }

          final data = snapshot.data!;
          final userDoc = data['userDoc'] as DocumentSnapshot<Map<String, dynamic>>;
          final weekExpenses = data['weekExpenses'] as List<Map<String, dynamic>>;
          final weekendExpenses = data['weekendExpenses'] as List<Map<String, dynamic>>;
          final lastWeekExpenses = data['lastWeekExpenses'] as List<Map<String, dynamic>>;
          final monthSpending = data['monthSpending'] as Map<String, double>;
          final totalExpenses = data['totalExpenses'] as double;

          if (!userDoc.exists) {
            return Center(child: Text(l10n.userNotFound));
          }

          final userModel = UserModel.fromMap(userDoc.data()!);
          final remaining = userModel.salary - totalExpenses;
          final goalProgress = userModel.savingsGoal > 0
              ? (remaining / userModel.savingsGoal).clamp(0.0, 1.0)
              : 0.0;

          final challenges = ChallengesHelper.evaluate(
            weekExpenses: weekExpenses,
            weekendExpenses: weekendExpenses,
            lastWeekExpenses: lastWeekExpenses,
            monthSpending: monthSpending,
            categoryBudgets: userModel.categoryBudgets,
          );

          final completedCount = challenges.where((c) => c.isCompleted).length;

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ProfileHeader(
                  name: userModel.name,
                  email: userModel.email,
                ),

                const SizedBox(height: 20),

                const AppSettingsSection(),

                const SizedBox(height: 24),

                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        label: l10n.monthlyIncome,
                        value: '${userModel.salary.toStringAsFixed(0)} DT',
                        color: AppColors.yellow,
                        icon: Icons.account_balance_wallet_outlined,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        label: l10n.remainingThisMonth,
                        value: '${remaining.toStringAsFixed(0)} DT',
                        color: remaining >= 0 ? AppColors.sage : AppColors.pink,
                        icon: Icons.savings_outlined,
                      ),
                    ),
                  ],
                ),

                if (userModel.savingsGoal > 0) ...[
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Text('🌱', style: TextStyle(fontSize: 20)),
                            SizedBox(width: 8),
                            Text(
                              'Savings Goal',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${remaining.toStringAsFixed(0)} / ${userModel.savingsGoal.toStringAsFixed(0)} DT',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              '${(goalProgress * 100).toStringAsFixed(0)}%',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: goalProgress,
                            minHeight: 8,
                            backgroundColor: AppColors.sage.withValues(alpha: 0.3),
                            color: AppColors.sage,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 28),

                _SectionLabel(title: l10n.accountSettings),
                const SizedBox(height: 8),
                _SettingsGroup(
                  items: [
                    _ProfileMenuItem(
                      icon: Icons.payments_outlined,
                      iconColor: AppColors.yellow,
                      title: l10n.updateSalary,
                      subtitle: l10n.manageMonthlyIncome,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SalarySetupPage(),
                          ),
                        );
                      },
                    ),
                    _ProfileMenuItem(
                      icon: Icons.pie_chart_outline,
                      iconColor: AppColors.lavender,
                      title: l10n.categoryBudgets,
                      subtitle: l10n.categoryBudgetsSubtitle,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const CategoryBudgetsPage(),
                          ),
                        );
                      },
                    ),
                    _ProfileMenuItem(
                      icon: Icons.download_outlined,
                      iconColor: AppColors.sage,
                      title: l10n.exportExpenses,
                      subtitle: l10n.exportExpensesSubtitle,
                      onTap: () async {
                        final userId = FirebaseAuth.instance.currentUser!.uid;
                        final expenses =
                            await FirestoreService().getExpensesOnce(userId);
                        if (!context.mounted) return;
                        if (expenses.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(l10n.noExpensesToExport)),
                          );
                          return;
                        }
                        await ExportService().exportExpensesCsv(expenses);
                      },
                    ),
                    _ProfileMenuItem(
                      icon: Icons.flag_outlined,
                      iconColor: AppColors.blue,
                      title: l10n.savingsGoal,
                      subtitle: userModel.savingsGoal > 0
                          ? l10n.savingsGoalSet(
                              userModel.savingsGoal.toStringAsFixed(0),
                            )
                          : l10n.savingsGoalUnset,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SavingsGoalPage(),
                          ),
                        );
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                _SectionLabel(title: l10n.achievements),
                const SizedBox(height: 8),
                _SettingsGroup(
                  items: [
                    _ProfileMenuItem(
                      icon: Icons.emoji_events_outlined,
                      iconColor: AppColors.pink,
                      title: l10n.myChallenges,
                      subtitle: completedCount > 0
                          ? l10n.challengesCompleted(completedCount)
                          : l10n.challengesEmpty,
                      trailing: completedCount > 0
                          ? Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.yellow,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '🏆 $completedCount',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                            )
                          : null,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ChallengesPage(),
                          ),
                        );
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          title: Text(l10n.logOutConfirmTitle),
                          content: Text(l10n.logOutConfirmMessage),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: Text(l10n.cancel),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.redAccent,
                              ),
                              child: Text(l10n.logOut),
                            ),
                          ],
                        ),
                      );

                      if (confirmed == true) {
                        await FirebaseAuth.instance.signOut();
                      }
                    },
                    icon: const Icon(Icons.logout, size: 20),
                    label: Text(l10n.logOut),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.redAccent.shade700,
                      side: BorderSide(color: Colors.redAccent.shade200),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final String name;
  final String email;

  const _ProfileHeader({
    required this.name,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    final initials = name.trim().isNotEmpty
        ? name.trim().split(' ').take(2).map((w) => w[0].toUpperCase()).join()
        : '?';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.sidiBlue,
            AppColors.sidiBlueLight,
          ],
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        children: [
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.7),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 3,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              initials,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple.shade700,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            email,
            style: TextStyle(
              color: Colors.black.withValues(alpha: 0.55),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;

  const _StatCard({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 22),
          const SizedBox(height: 12),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.black.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String title;

  const _SectionLabel({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.8,
          color: Colors.grey.shade600,
        ),
      ),
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  final List<_ProfileMenuItem> items;

  const _SettingsGroup({required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          for (int i = 0; i < items.length; i++) ...[
            if (i > 0)
              Divider(
                height: 1,
                indent: 68,
                color: Colors.grey.shade200,
              ),
            items[i],
          ],
        ],
      ),
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback onTap;

  const _ProfileMenuItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            trailing ??
                Icon(
                  Icons.chevron_right,
                  color: Colors.grey.shade400,
                ),
          ],
        ),
      ),
    );
  }
}
