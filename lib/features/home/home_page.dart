import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/firestore_service.dart';
import '../../providers/user_provider.dart';
import '../expenses/add_expense_page.dart';
import '../expenses/expense_list_page.dart';
import '../profile/salary_setup_page.dart';
import '../expenses/analytics_page.dart';
import '../expenses/monthly_trend_page.dart';
import '../../widgets/dashboard_card.dart';
import '../../utils/app_colors.dart';
import '../../widgets/expense_card.dart';
class HomePage extends ConsumerWidget {
  final firestoreService = FirestoreService();
  String getCategoryIcon(String category) {

    switch (category) {
      case 'Rent':
        return '🏠';

      case 'Bills':
        return '💡';

      case 'Food':
        return '🍔';

      case 'Groceries':
        return '🛒';

      case 'Transport':
        return '🚌';

      case 'Entertainment':
        return '🎉';

      case 'Healthcare':
        return '🏥';

      case 'Education':
        return '📚';

      case 'Shopping':
        return '🛍️';

      case 'Savings':
        return '💰';

      default:
        return '💸';
    }
  }
  Color getCategoryColor(String category) {
    switch (category) {
      case 'Rent':
        return AppColors.lavender;

      case 'Bills':
        return AppColors.blue;

      case 'Food':
        return AppColors.yellow;

      case 'Groceries':
        return AppColors.sage;

      case 'Transport':
        return AppColors.blue;

      case 'Entertainment':
        return AppColors.pink;

      case 'Healthcare':
        return AppColors.sage;

      case 'Education':
        return AppColors.lavender;

      case 'Shopping':
        return AppColors.pink;

      case 'Savings':
        return AppColors.sage;

      default:
        return Colors.white;
    }
  }
  HomePage({super.key});


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flousi '),

      ),
      body: FutureBuilder(
        future: firestoreService.getUser(
          ref.watch(currentUserProvider)!.uid,
        ),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final data = snapshot.data!.data();
          final salary =
          ((data?['salary'] ?? 0) as num).toDouble();

          return FutureBuilder<double>(
            future: firestoreService.getTotalExpenses(
              ref.watch(currentUserProvider)!.uid,
          ),
          builder: (context, expenseSnapshot) {
            if (!expenseSnapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            final totalExpenses = expenseSnapshot.data!;
            final remaining = salary - totalExpenses;
            final savingsGoal =
            (data?['savingsGoal'] ?? 0).toDouble();
            final goalProgress = savingsGoal > 0
          ? (remaining / savingsGoal).clamp(0, 1).toDouble()
    : 0.0;

            final usagePercentage =
            salary > 0 ? (totalExpenses / salary) * 100 : 0;




            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Text(
                        'Hello, ${data?['name']} 🌸',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 6),

                      const Text(
                        'Let’s take care of your money today',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: AppColors.yellow,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.account_balance_wallet),
                                SizedBox(width: 8),
                                Text(
                                  'Monthly Income',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            Text(
                              '${salary.toStringAsFixed(0)} DT',
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      Row(
                        children: [
                          Expanded(
                            child: DashboardCard(
                              title: 'Spent',
                              value:
                              '${totalExpenses.toStringAsFixed(0)} DT',
                              color: AppColors.pink,
                              icon: Icons.payments,
                            ),
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: DashboardCard(
                              title: 'Left',
                              value:
                              '${remaining.toStringAsFixed(0)} DT',
                              color: remaining >= 0
                                  ? AppColors.sage
                                  : AppColors.pink,
                              icon: Icons.savings,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        usagePercentage > 100
                            ? '🚨 Warning: You have exceeded your income'
                            : '⚠️ You have used ${usagePercentage.toStringAsFixed(1)}% of your income',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text('🌸'),
                              SizedBox(width: 8),
                              Text(
                                'Monthly Summary',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),


                          Row(
                            children: [
                              const Expanded(
                                child: Text('Income'),
                              ),
                              Text('${salary.toStringAsFixed(0)} DT'),
                            ],
                          ),

                          const SizedBox(height: 8),

                          Row(
                            children: [
                              const Expanded(
                                child: Text('Spent'),
                              ),
                              Text('${totalExpenses.toStringAsFixed(0)} DT'),
                            ],
                          ),

                          const SizedBox(height: 8),

                          Row(
                            children: [
                              const Expanded(
                                child: Text('Remaining'),
                              ),
                              Text('${remaining.toStringAsFixed(0)} DT'),
                            ],
                          ),

                          const SizedBox(height: 16),

                          Text(
                            remaining >= 0
                                ? '🎉 You are staying within your budget!'
                                : '⚠️ You spent more than your income this month.',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  const SizedBox(height: 20),

                  if (savingsGoal > 0)
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '🌱 Savings Goal',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 16),

                            Text(
                              'Goal: ${savingsGoal.toStringAsFixed(0)} DT',
                            ),

                            Text(
                              'Current: ${remaining.toStringAsFixed(0)} DT',
                            ),

                            const SizedBox(height: 16),

                            LinearProgressIndicator(
                              value: goalProgress,
                              minHeight: 10,
                              borderRadius:
                              BorderRadius.circular(10),
                            ),

                            const SizedBox(height: 16),

                            Text(
                              remaining >= savingsGoal
                                  ? '🎉 Goal achieved!'
                                  : '💪 Keep saving!',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),


                  const Text(
                    'Recent Transactions',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  FutureBuilder(
                    future: firestoreService.getRecentExpenses(
                      ref.watch(currentUserProvider)!.uid,
                    ),
                    builder: (context, recentSnapshot) {
                      if (!recentSnapshot.hasData) {
                        return const CircularProgressIndicator();
                      }

                      final recentExpenses = recentSnapshot.data!;

                      return Column(
                        children: recentExpenses.map((expense) {
                          final data = expense.data();

                          return ExpenseCard(
                            title: data['title'],
                            category: data['category'],
                            amount: '${data['amount']} DT',
                            icon: getCategoryIcon(data['category']),
                            color: getCategoryColor(data['category']),
                          );
                        }).toList(),
                      );
                    },
                  ),

                  const SizedBox(height: 90),


                ],
              ),

            );

          },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddExpensePage(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}