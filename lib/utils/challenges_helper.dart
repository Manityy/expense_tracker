class ChallengeStatus {
  final String title;
  final String description;
  final double progress;
  final String statusText;
  final bool isCompleted;

  ChallengeStatus({
    required this.title,
    required this.description,
    required this.progress,
    required this.statusText,
    required this.isCompleted,
  });
}

class ChallengesHelper {
  static List<ChallengeStatus> evaluate({
    required List<Map<String, dynamic>> weekExpenses,
    required List<Map<String, dynamic>> weekendExpenses,
    required List<Map<String, dynamic>> lastWeekExpenses,
    required Map<String, double> monthSpending,
    required Map<String, double> categoryBudgets,
  }) {
    // 1. No-Spend Weekend
    double weekendSpend = 0.0;
    for (final exp in weekendExpenses) {
      final cat = exp['category'] as String? ?? '';
      if (cat == 'Food' || cat == 'Entertainment' || cat == 'Shopping') {
        weekendSpend += (exp['amount'] as num?)?.toDouble() ?? 0.0;
      }
    }
    final noSpendWeekendCompleted = weekendSpend == 0.0;
    final noSpendStatusText = noSpendWeekendCompleted
        ? 'Completed! 🏆 (0 DT spent)'
        : 'Failed (spent ${weekendSpend.toStringAsFixed(2)} DT)';

    // 2. Personalized Food challenge — beat last week's food spending
    double weeklyFoodSpend = 0.0;
    for (final exp in weekExpenses) {
      if ((exp['category'] as String? ?? '') == 'Food') {
        weeklyFoodSpend += (exp['amount'] as num?)?.toDouble() ?? 0.0;
      }
    }
    double lastWeekFoodSpend = 0.0;
    for (final exp in lastWeekExpenses) {
      if ((exp['category'] as String? ?? '') == 'Food') {
        lastWeekFoodSpend += (exp['amount'] as num?)?.toDouble() ?? 0.0;
      }
    }
    final foodTarget = lastWeekFoodSpend > 0 ? lastWeekFoodSpend * 0.85 : 60.0;
    final foodCompleted = weeklyFoodSpend <= foodTarget;
    final foodProgress = foodTarget > 0
        ? (weeklyFoodSpend / foodTarget).clamp(0.0, 1.0)
        : 0.0;
    final foodStatusText = foodCompleted
        ? 'Completed! 🏆 (${(foodTarget - weeklyFoodSpend).clamp(0, double.infinity).toStringAsFixed(0)} DT under target)'
        : 'Spent ${weeklyFoodSpend.toStringAsFixed(0)} / ${foodTarget.toStringAsFixed(0)} DT target';

    // 3. Budget Hero
    int configuredCount = 0;
    int withinBudgetCount = 0;
    var failedBudget = false;

    categoryBudgets.forEach((category, budget) {
      if (budget > 0.0) {
        configuredCount++;
        final spend = monthSpending[category] ?? 0.0;
        if (spend <= budget) {
          withinBudgetCount++;
        } else {
          failedBudget = true;
        }
      }
    });

    final budgetHeroCompleted = configuredCount > 0 && !failedBudget;
    final budgetHeroProgress = configuredCount > 0
        ? (withinBudgetCount / configuredCount).clamp(0.0, 1.0)
        : 0.0;

    String budgetHeroStatusText;
    if (configuredCount == 0) {
      budgetHeroStatusText = 'No budgets configured yet.';
    } else if (budgetHeroCompleted) {
      budgetHeroStatusText =
          'Completed! 🏆 (All $configuredCount budgets on track)';
    } else {
      budgetHeroStatusText =
          'Failed ($withinBudgetCount/$configuredCount budgets on track)';
    }

    // 4. Spend less than last week overall
    double weekTotal = weekExpenses.fold<double>(
      0,
      (total, e) => total + ((e['amount'] as num?)?.toDouble() ?? 0),
    );
    double lastWeekTotal = lastWeekExpenses.fold<double>(
      0,
      (total, e) => total + ((e['amount'] as num?)?.toDouble() ?? 0),
    );
    final spendLessTarget =
        lastWeekTotal > 0 ? lastWeekTotal * 0.9 : weekTotal;
    final spendLessCompleted =
        lastWeekTotal > 0 && weekTotal <= spendLessTarget;
    final spendLessProgress = lastWeekTotal > 0
        ? (weekTotal / lastWeekTotal).clamp(0.0, 1.0)
        : 0.0;
    final spendLessStatusText = lastWeekTotal <= 0
        ? 'Log expenses for 2 weeks to unlock this challenge.'
        : spendLessCompleted
            ? 'Completed! 🏆 (${(lastWeekTotal - weekTotal).toStringAsFixed(0)} DT saved vs last week)'
            : '${weekTotal.toStringAsFixed(0)} / ${spendLessTarget.toStringAsFixed(0)} DT target';

    return [
      ChallengeStatus(
        title: 'No-Spend Weekend',
        description:
            'Log 0 DT in Food, Entertainment, or Shopping during Sat–Sun.',
        progress: noSpendWeekendCompleted ? 1.0 : 0.0,
        statusText: noSpendStatusText,
        isCompleted: noSpendWeekendCompleted,
      ),
      ChallengeStatus(
        title: 'Food Flex',
        description: lastWeekFoodSpend > 0
            ? 'Spend at least 15% less on Food than last week (target: ${foodTarget.toStringAsFixed(0)} DT).'
            : 'Keep weekly Food spending under 60 DT.',
        progress: foodProgress,
        statusText: foodStatusText,
        isCompleted: foodCompleted,
      ),
      ChallengeStatus(
        title: 'Budget Hero',
        description: 'Stay within all configured category budgets this month.',
        progress: budgetHeroProgress,
        statusText: budgetHeroStatusText,
        isCompleted: budgetHeroCompleted,
      ),
      ChallengeStatus(
        title: 'Week-over-Week Saver',
        description: lastWeekTotal > 0
            ? 'Spend 10% less overall than last week.'
            : 'Compare your spending to last week once you have history.',
        progress: spendLessProgress,
        statusText: spendLessStatusText,
        isCompleted: spendLessCompleted,
      ),
    ];
  }
}
