class FinanceInsight {
  final String emoji;
  final String title;
  final String message;

  FinanceInsight({
    required this.emoji,
    required this.title,
    required this.message,
  });
}

class MonthForecast {
  final double projectedSpend;
  final double projectedRemaining;
  final int daysLeft;
  final double dailyAverage;

  MonthForecast({
    required this.projectedSpend,
    required this.projectedRemaining,
    required this.daysLeft,
    required this.dailyAverage,
  });
}

class FinanceHelpers {
  static MonthForecast calculateForecast({
    required double salary,
    required double monthSpent,
    DateTime? now,
  }) {
    final today = now ?? DateTime.now();
    final daysInMonth = DateTime(today.year, today.month + 1, 0).day;
    final daysElapsed = today.day.clamp(1, daysInMonth);
    final daysLeft = daysInMonth - daysElapsed;

    final dailyAverage = daysElapsed > 0 ? monthSpent / daysElapsed : 0.0;
    final projectedSpend = monthSpent + (dailyAverage * daysLeft);
    final projectedRemaining = salary - projectedSpend;

    return MonthForecast(
      projectedSpend: projectedSpend,
      projectedRemaining: projectedRemaining,
      daysLeft: daysLeft,
      dailyAverage: dailyAverage,
    );
  }

  static FinanceInsight? generateInsight({
    required double salary,
    required double monthSpent,
    required Map<String, double> categorySpending,
    required Map<String, double> categoryBudgets,
    required MonthForecast forecast,
  }) {
    for (final entry in categoryBudgets.entries) {
      if (entry.value <= 0) continue;
      final spent = categorySpending[entry.key] ?? 0;
      final ratio = spent / entry.value;
      if (ratio >= 1) {
        return FinanceInsight(
          emoji: '🚨',
          title: '${entry.key} budget exceeded',
          message:
              'You spent ${spent.toStringAsFixed(0)} DT of your ${entry.value.toStringAsFixed(0)} DT ${entry.key} limit. Try to pause non-essential ${entry.key.toLowerCase()} spending.',
        );
      }
      if (ratio >= 0.8) {
        return FinanceInsight(
          emoji: '⚠️',
          title: '${entry.key} budget at ${(ratio * 100).toStringAsFixed(0)}%',
          message:
              'Only ${(entry.value - spent).toStringAsFixed(0)} DT left in your ${entry.key} budget this month.',
        );
      }
    }

    if (salary > 0 && forecast.projectedSpend > salary) {
      return FinanceInsight(
        emoji: '📉',
        title: 'Spending pace is high',
        message:
            'At your current rate (~${forecast.dailyAverage.toStringAsFixed(0)} DT/day), you may end the month ${(forecast.projectedSpend - salary).toStringAsFixed(0)} DT over budget.',
      );
    }

    if (categorySpending.isNotEmpty) {
      final top = categorySpending.entries.reduce(
        (a, b) => a.value >= b.value ? a : b,
      );
      if (top.value > 0) {
        return FinanceInsight(
          emoji: '💡',
          title: 'Top spending: ${top.key}',
          message:
              '${top.key} is your biggest category at ${top.value.toStringAsFixed(0)} DT this month (${monthSpent > 0 ? ((top.value / monthSpent) * 100).toStringAsFixed(0) : '0'}% of spending).',
        );
      }
    }

    if (monthSpent == 0) {
      return FinanceInsight(
        emoji: '🌱',
        title: 'Fresh start this month',
        message: 'No expenses logged yet. Add your first expense to unlock personalized insights.',
      );
    }

    if (forecast.projectedRemaining >= 0 && salary > 0) {
      return FinanceInsight(
        emoji: '✅',
        title: 'On track this month',
        message:
            'You could finish with about ${forecast.projectedRemaining.toStringAsFixed(0)} DT remaining if you keep this pace.',
      );
    }

    return null;
  }
}
