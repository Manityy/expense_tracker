import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:expense_tracker/l10n/app_localizations.dart';
import '../../providers/data_providers.dart';
import '../expenses/add_expense_page.dart';
import '../../widgets/dashboard_card.dart';
import '../../utils/app_colors.dart';
import '../../utils/category_l10n.dart';
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
    final l10n = AppLocalizations.of(context)!;

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
            return Center(child: Text(l10n.profileNotFound));
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
              final locale = Localizations.localeOf(context).toString();
              final monthLabel =
                  ExpenseDateUtils.monthLabel(DateTime.now(), locale);
              final forecast = FinanceHelpers.calculateForecast(
                salary: salary,
                monthSpent: totalExpenses,
              );
              final spending = ExpenseHelpers.categorySpending(expenses);
              final insight = FinanceHelpers.generateLocalizedInsight(
                l10n: l10n,
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
                      TunisianWelcomeHeader(
                        greeting: l10n.welcomeGreeting(user.name),
                        subtitle: l10n.welcomeSubtitle,
                      ),
                      const SizedBox(height: 20),
                      _buildIncomeSection(
                        context: context,
                        l10n: l10n,
                        salary: salary,
                        monthLabel: monthLabel,
                        totalExpenses: totalExpenses,
                        remaining: remaining,
                      ),
                      const SizedBox(height: 20),
                      _buildUsageCard(l10n, usagePercentage),
                      const SizedBox(height: 20),
                      _buildForecastCard(l10n, forecast, salary),
                      const SizedBox(height: 20),
                      if (savingsGoal > 0)
                        _buildSavingsCard(
                          l10n: l10n,
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
                        l10n: l10n,
                        activeBudgets: activeBudgets,
                        spending: spending,
                      ),
                      const SizedBox(height: 20),
                      _buildAiCard(context, l10n),
                      const SizedBox(height: 20),
                      Text(
                        l10n.recentTransactions,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (recent.isEmpty)
                        Text(
                          l10n.noExpensesYet,
                          style: TextStyle(color: Colors.grey.shade600),
                        )
                      else
                        ...recent.map((expense) {
                          final data = expense.data();
                          return ExpenseCard(
                            title: data['title'] as String? ?? '',
                            category: CategoryL10n.name(
                              l10n,
                              data['category'] as String? ?? 'Other',
                            ),
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
    required BuildContext context,
    required AppLocalizations l10n,
    required double salary,
    required double totalExpenses,
    required double remaining,
    required String monthLabel,
  }) {
    final muted = Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.55);
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
              Row(
                children: [
                  const Icon(Icons.account_balance_wallet),
                  const SizedBox(width: 8),
                  Text(
                    l10n.monthlyIncome,
                    style: const TextStyle(fontWeight: FontWeight.w600),
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
            color: muted,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: DashboardCard(
                title: l10n.spentThisMonth,
                value: '${totalExpenses.toStringAsFixed(0)} DT',
                color: AppColors.harissaSoft,
                icon: Icons.payments,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: DashboardCard(
                title: l10n.remainingThisMonth,
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

  Widget _buildUsageCard(AppLocalizations l10n, num usagePercentage) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          usagePercentage > 100
              ? '🚨 ${l10n.usageExceeded}'
              : '⚠️ ${l10n.usagePercent(usagePercentage.toStringAsFixed(1))}',
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildForecastCard(AppLocalizations l10n, MonthForecast forecast, double salary) {
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
          Row(
            children: [
              const Icon(Icons.trending_up),
              const SizedBox(width: 8),
              Text(
                l10n.endOfMonthForecast,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            forecast.projectedRemaining >= 0
                ? l10n.forecastOnPace(
                    forecast.projectedRemaining.toStringAsFixed(0),
                    forecast.daysLeft,
                  )
                : l10n.forecastOverspend(
                    (forecast.projectedSpend - salary).toStringAsFixed(0),
                  ),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.dailyAverage(forecast.dailyAverage.toStringAsFixed(0)),
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
    required AppLocalizations l10n,
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
            Text(
              l10n.savingsGoalTitle,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(l10n.goal),
                Text('${savingsGoal.toStringAsFixed(0)} DT'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(l10n.current),
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
              remaining >= savingsGoal ? l10n.goalAchieved : l10n.keepSaving,
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
    required AppLocalizations l10n,
    required List<MapEntry<String, double>> activeBudgets,
    required Map<String, double> spending,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '📊 ${l10n.categoryBudgetsTitle}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (activeBudgets.isEmpty) ...[
              Text(
                l10n.noCategoryBudgets,
                style: const TextStyle(color: Colors.grey, height: 1.4),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  icon: const Icon(Icons.settings),
                  label: Text(l10n.setupCategoryBudgets),
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
                  alertText =
                      ' 🚨 ${l10n.budgetExceededBy((spent - limit).toStringAsFixed(0))}';
                } else if (ratio >= 0.8) {
                  barColor = AppColors.yellow;
                  alertText = ' ⚠️ ${l10n.budgetEightyPercent}';
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
                              Text(CategoryL10n.name(l10n, category),
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

  Widget _buildAiCard(BuildContext context, AppLocalizations l10n) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '🤖 ${l10n.flousiAiAssistant}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(l10n.flousiAiSubtitle),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.smart_toy),
                label: Text(l10n.chatWithAi),
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
