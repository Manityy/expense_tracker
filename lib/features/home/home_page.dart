import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/data_providers.dart';
import '../expenses/add_expense_page.dart';
import '../../widgets/dashboard_card.dart';
import '../../utils/app_colors.dart';
import '../../utils/category_utils.dart';
import '../../utils/expense_date_utils.dart';
import '../../utils/expense_helpers.dart';
import '../../utils/finance_helpers.dart';
import '../../widgets/expense_card.dart';
import '../../widgets/tunisian_motif.dart';
import '../ai/conversations_page.dart';
import '../profile/category_budgets_page.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userModelStreamProvider);
    final expensesAsync = ref.watch(expensesStreamProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              'Flousi',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.sidiBlue,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              'فلوسي',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.sidiBlue.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
      body: userAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (user) {
          if (user == null) {
            return const Center(child: Text('Profile not found'));
          }

          return expensesAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('$e')),
            data: (expenses) {
              final salary = user.salary;
              final savingsGoal = user.savingsGoal;
              final totalExpenses = ExpenseHelpers.monthlyTotal(expenses);
              final remaining = salary - totalExpenses;
              final goalProgress = savingsGoal > 0
                  ? (remaining / savingsGoal).clamp(0, 1).toDouble()
                  : 0.0;
              final usagePercentage =
                  salary > 0 ? (totalExpenses / salary) * 100 : 0;
              final monthLabel = ExpenseDateUtils.monthLabel(DateTime.now());
              final forecast = FinanceHelpers.calculateForecast(
                salary: salary,
                monthSpent: totalExpenses,
              );
              final spending = ExpenseHelpers.categorySpending(expenses);
              final insight = FinanceHelpers.generateInsight(
                salary: salary,
                monthSpent: totalExpenses,
                categorySpending: spending,
                categoryBudgets: user.categoryBudgets,
                forecast: forecast,
              );
              final activeBudgets = user.categoryBudgets.entries
                  .where((entry) => entry.value > 0)
                  .toList();
              final recent = ExpenseHelpers.recent(expenses);

              return RefreshIndicator(
                onRefresh: () async {
                  ref.invalidate(userModelStreamProvider);
                  ref.invalidate(expensesStreamProvider);
                  await Future<void>.delayed(const Duration(milliseconds: 400));
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TunisianWelcomeHeader(name: user.name),
                      const SizedBox(height: 20),
                      _buildIncomeSection(
                        salary: salary,
                        monthLabel: monthLabel,
                        totalExpenses: totalExpenses,
                        remaining: remaining,
                      ),
                      const SizedBox(height: 20),
                      _buildUsageCard(usagePercentage),
                      const SizedBox(height: 20),
                      _buildForecastCard(forecast, salary),
                      const SizedBox(height: 20),
                      if (savingsGoal > 0)
                        _buildSavingsCard(
                          savingsGoal: savingsGoal,
                          remaining: remaining,
                          goalProgress: goalProgress,
                        ),
                      if (savingsGoal > 0) const SizedBox(height: 20),
                      if (insight != null) ...[
                        _buildInsightCard(insight),
                        const SizedBox(height: 20),
                      ],
                      _buildBudgetsCard(
                        context: context,
                        activeBudgets: activeBudgets,
                        spending: spending,
                      ),
                      const SizedBox(height: 20),
                      _buildAiCard(context),
                      const SizedBox(height: 20),
                      const Text(
                        'Recent Transactions',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (recent.isEmpty)
                        Text(
                          'No expenses yet. Tap + to add one.',
                          style: TextStyle(color: Colors.grey.shade600),
                        )
                      else
                        ...recent.map((expense) {
                          final data = expense.data();
                          return ExpenseCard(
                            title: data['title'] as String? ?? '',
                            category: data['category'] as String? ?? 'Other',
                            amount: '${data['amount']} DT',
                            icon: CategoryUtils.getIcon(data['category'] ?? 'Other'),
                            color: CategoryUtils.getColor(data['category'] ?? 'Other'),
                          );
                        }),
                      const SizedBox(height: 90),
                    ],
                  ),
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
            MaterialPageRoute(builder: (_) => const AddExpensePage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildIncomeSection({
    required double salary,
    required String monthLabel,
    required double totalExpenses,
    required double remaining,
  }) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.saffron,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: AppColors.saffronDeep.withValues(alpha: 0.15),
            ),
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
                    style: TextStyle(fontWeight: FontWeight.w600),
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
        Text(
          monthLabel,
          style: TextStyle(
            color: Colors.black.withValues(alpha: 0.55),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: DashboardCard(
                title: 'Spent this month',
                value: '${totalExpenses.toStringAsFixed(0)} DT',
                color: AppColors.harissaSoft,
                icon: Icons.payments,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: DashboardCard(
                title: 'Left this month',
                value: '${remaining.toStringAsFixed(0)} DT',
                color: remaining >= 0 ? AppColors.olive : AppColors.harissaSoft,
                icon: Icons.savings,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildUsageCard(num usagePercentage) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          usagePercentage > 100
              ? '🚨 Warning: You have exceeded your monthly income'
              : '⚠️ You have used ${usagePercentage.toStringAsFixed(1)}% of your monthly income',
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildForecastCard(MonthForecast forecast, double salary) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.mediterranean.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.sidiBlue.withValues(alpha: 0.12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.trending_up),
              SizedBox(width: 8),
              Text(
                'End-of-month forecast',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            forecast.projectedRemaining >= 0
                ? 'On pace to finish with ~${forecast.projectedRemaining.toStringAsFixed(0)} DT left (${forecast.daysLeft} days left)'
                : 'On pace to overspend by ~${(forecast.projectedSpend - salary).toStringAsFixed(0)} DT',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Daily average: ${forecast.dailyAverage.toStringAsFixed(0)} DT',
            style: TextStyle(
              color: Colors.black.withValues(alpha: 0.55),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSavingsCard({
    required double savingsGoal,
    required double remaining,
    required double goalProgress,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '🌱 Savings Goal',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Goal'),
                Text('${savingsGoal.toStringAsFixed(0)} DT'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Current'),
                Text('${remaining.toStringAsFixed(0)} DT'),
              ],
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: goalProgress,
              minHeight: 10,
              borderRadius: BorderRadius.circular(10),
            ),
            const SizedBox(height: 16),
            Text(
              remaining >= savingsGoal ? '🎉 Goal achieved!' : '💪 Keep saving!',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightCard(FinanceInsight insight) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.sidiBlue.withValues(alpha: 0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(insight.emoji, style: const TextStyle(fontSize: 22)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  insight.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            insight.message,
            style: TextStyle(color: Colors.grey.shade700, height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _buildBudgetsCard({
    required BuildContext context,
    required List<MapEntry<String, double>> activeBudgets,
    required Map<String, double> spending,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '📊 Category Budgets',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (activeBudgets.isEmpty) ...[
              const Text(
                'No category budgets set. Setup budget limits in your Profile to track category progress!',
                style: TextStyle(color: Colors.grey, height: 1.4),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  icon: const Icon(Icons.settings),
                  label: const Text('Setup Category Budgets'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CategoryBudgetsPage(),
                      ),
                    );
                  },
                ),
              ),
            ] else
              ...activeBudgets.map((entry) {
                final category = entry.key;
                final limit = entry.value;
                final spent = spending[category] ?? 0.0;
                final ratio = limit > 0 ? spent / limit : 0.0;
                final progress = ratio.clamp(0.0, 1.0);
                Color barColor;
                Color txtColor = Colors.black87;
                var alertText = '';
                if (ratio >= 1.0) {
                  barColor = AppColors.pink;
                  txtColor = Colors.red.shade900;
                  alertText = ' 🚨 Exceeded by ${(spent - limit).toStringAsFixed(0)} DT!';
                } else if (ratio >= 0.8) {
                  barColor = AppColors.yellow;
                  alertText = ' ⚠️ 80%+ spent';
                } else {
                  barColor = AppColors.sage;
                }
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(CategoryUtils.getIcon(category),
                                  style: const TextStyle(fontSize: 16)),
                              const SizedBox(width: 6),
                              Text(category,
                                  style: const TextStyle(fontWeight: FontWeight.w600)),
                              if (alertText.isNotEmpty)
                                Text(
                                  alertText,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: ratio >= 1.0
                                        ? Colors.red
                                        : Colors.orange.shade800,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                            ],
                          ),
                          Text(
                            '${spent.toStringAsFixed(0)} / ${limit.toStringAsFixed(0)} DT',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: txtColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 10,
                          backgroundColor: Colors.grey.shade100,
                          valueColor: AlwaysStoppedAnimation<Color>(barColor),
                        ),
                      ),
                    ],
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }

  Widget _buildAiCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '🤖 Flousi AI Assistant',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Need help managing your money? Ask Flousi AI for personalized financial advice.',
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.smart_toy),
                label: const Text('Chat with AI'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ConversationsPage(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
