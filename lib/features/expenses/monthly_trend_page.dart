import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:expense_tracker/l10n/app_localizations.dart';
import '../../utils/app_colors.dart';
import '../../utils/analytics_helpers.dart';
import '../../widgets/tunisian_motif.dart';

class MonthlyTrendPage extends StatefulWidget {
  const MonthlyTrendPage({super.key});

  @override
  State<MonthlyTrendPage> createState() => _MonthlyTrendPageState();
}

class _MonthlyTrendPageState extends State<MonthlyTrendPage> {
  int _touchedBar = -1;
  int _reloadToken = 0;

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> _loadExpenses() {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance
        .collection('expenses')
        .where('userId', isEqualTo: userId)
        .get()
        .then((s) => s.docs);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    return Scaffold(
      backgroundColor: AppColors.background,
      body: FlousiBackground(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text(l10n.monthlyTrend),
          ),
          body: FutureBuilder<List<QueryDocumentSnapshot<Map<String, dynamic>>>>(
        key: ValueKey(_reloadToken),
        future: _loadExpenses(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final expenses = snapshot.data ?? [];
          if (expenses.isEmpty) {
            return TunisianEmptyState(
              embedded: true,
              icon: Icons.show_chart,
              title: l10n.noSpendingHistory,
              subtitle: l10n.noSpendingHistorySubtitle,
            );
          }

          final totals = AnalyticsHelpers.monthlyTotalsFromExpenses(expenses);
          final last6 = AnalyticsHelpers.lastNMonths(totals: totals, count: 6);
          final allMonths = totals.entries.toList()
            ..sort((a, b) => b.key.compareTo(a.key));

          final currentMonth = last6.last;
          final prevMonth = last6.length >= 2 ? last6[last6.length - 2] : null;
          final monthChange = prevMonth != null && prevMonth.value > 0
              ? ((currentMonth.value - prevMonth.value) / prevMonth.value) * 100
              : null;
          final avgMonthly = last6.fold<double>(0, (s, e) => s + e.value) /
              last6.where((e) => e.value > 0).length.clamp(1, 6);
          final maxY = AnalyticsHelpers.chartMaxY(last6.map((e) => e.value));

          return RefreshIndicator(
            onRefresh: () async {
              setState(() {
                _reloadToken++;
                _touchedBar = -1;
              });
              await Future<void>.delayed(const Duration(milliseconds: 300));
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SummaryHero(
                    l10n: l10n,
                    monthLabel: AnalyticsHelpers.formatMonthKey(
                      currentMonth.key,
                      locale,
                    ),
                    amount: currentMonth.value,
                    monthChange: monthChange,
                    avgMonthly: avgMonthly,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    l10n.lastSixMonths,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(12, 24, 16, 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: SizedBox(
                      height: 240,
                      child: BarChart(
                        BarChartData(
                          maxY: maxY,
                          minY: 0,
                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: false,
                            horizontalInterval: maxY / 4,
                            getDrawingHorizontalLine: (value) => FlLine(
                              color: Colors.grey.shade200,
                              strokeWidth: 1,
                            ),
                          ),
                          borderData: FlBorderData(show: false),
                          barTouchData: BarTouchData(
                            enabled: true,
                            touchCallback: (event, response) {
                              setState(() {
                                if (!event.isInterestedForInteractions ||
                                    response?.spot == null) {
                                  _touchedBar = -1;
                                  return;
                                }
                                _touchedBar = response!.spot!.touchedBarGroupIndex;
                              });
                            },
                            touchTooltipData: BarTouchTooltipData(
                              getTooltipColor: (_) => Colors.black87,
                              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                                return BarTooltipItem(
                                  '${rod.toY.toStringAsFixed(0)} DT',
                                  const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              },
                            ),
                          ),
                          titlesData: FlTitlesData(
                            topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 44,
                                interval: maxY / 4,
                                getTitlesWidget: (value, meta) {
                                  if (value < 0) return const SizedBox.shrink();
                                  return Text(
                                    value.toStringAsFixed(0),
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey.shade600,
                                    ),
                                  );
                                },
                              ),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 32,
                                getTitlesWidget: (value, meta) {
                                  final i = value.toInt();
                                  if (i < 0 || i >= last6.length) {
                                    return const SizedBox.shrink();
                                  }
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Text(
                                      AnalyticsHelpers.formatMonthKey(
                                        last6[i].key,
                                        locale,
                                      ).replaceAll("'", "'\n"),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: _touchedBar == i
                                            ? FontWeight.bold
                                            : FontWeight.w500,
                                        color: _touchedBar == i
                                            ? Colors.deepPurple.shade900
                                            : Colors.grey.shade600,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          barGroups: List.generate(last6.length, (i) {
                            final value = last6[i].value;
                            final isTouched = _touchedBar == i;
                            final isCurrent = i == last6.length - 1;
                            return BarChartGroupData(
                              x: i,
                              barRods: [
                                BarChartRodData(
                                  toY: value,
                                  width: isTouched ? 26 : 22,
                                  color: isCurrent
                                      ? AppColors.sidiBlue
                                      : AppColors.mediterranean.withValues(alpha: 0.7),
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(8),
                                  ),
                                  backDrawRodData: BackgroundBarChartRodData(
                                    show: true,
                                    toY: maxY,
                                    color: Colors.grey.shade100,
                                  ),
                                ),
                              ],
                            );
                          }),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  Text(
                    l10n.allMonths,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  ...allMonths.asMap().entries.map((entry) {
                    final index = entry.key;
                    final month = entry.value;
                    final prev = index < allMonths.length - 1
                        ? allMonths[index + 1].value
                        : null;
                    double? change;
                    if (prev != null && prev > 0) {
                      change = ((month.value - prev) / prev) * 100;
                    }
                    return _HistoryTile(
                      l10n: l10n,
                      monthLabel: AnalyticsHelpers.formatMonthKeyLong(
                        month.key,
                        locale,
                      ),
                      amount: month.value,
                      changePercent: change,
                      isLatest: index == 0,
                    );
                  }),
                ],
              ),
            ),
          );
        },
          ),
        ),
      ),
    );
  }
}

class _SummaryHero extends StatelessWidget {
  final AppLocalizations l10n;
  final String monthLabel;
  final double amount;
  final double? monthChange;
  final double avgMonthly;

  const _SummaryHero({
    required this.l10n,
    required this.monthLabel,
    required this.amount,
    required this.monthChange,
    required this.avgMonthly,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.saffron,
            AppColors.mediterranean.withValues(alpha: 0.85),
          ],
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            monthLabel,
            style: TextStyle(
              color: Colors.black.withValues(alpha: 0.6),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${amount.toStringAsFixed(0)} DT',
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              if (monthChange != null) ...[
                _MiniStat(
                  icon: monthChange! <= 0
                      ? Icons.trending_down
                      : Icons.trending_up,
                  label: l10n.vsLastMonth,
                  value: '${monthChange!.abs().toStringAsFixed(0)}%',
                  positive: monthChange! <= 0,
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: _MiniStat(
                  icon: Icons.analytics_outlined,
                  label: l10n.sixMonthAverage,
                  value: '${avgMonthly.toStringAsFixed(0)} DT',
                  positive: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool positive;

  const _MiniStat({
    required this.icon,
    required this.label,
    required this.value,
    required this.positive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 11)),
                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HistoryTile extends StatelessWidget {
  final AppLocalizations l10n;
  final String monthLabel;
  final double amount;
  final double? changePercent;
  final bool isLatest;

  const _HistoryTile({
    required this.l10n,
    required this.monthLabel,
    required this.amount,
    required this.changePercent,
    required this.isLatest,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: isLatest
            ? Border.all(color: AppColors.sidiBlue, width: 2)
            : null,
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isLatest ? AppColors.saffron : AppColors.mediterranean.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.calendar_month_outlined),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  monthLabel,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                if (changePercent != null)
                  Text(
                    changePercent! <= 0
                        ? '↓ ${l10n.vsPrevious('${changePercent!.abs().toStringAsFixed(0)}%')}'
                        : '↑ ${l10n.vsPrevious('${changePercent!.toStringAsFixed(0)}%')}',
                    style: TextStyle(
                      fontSize: 12,
                      color: changePercent! <= 0
                          ? Colors.green.shade700
                          : Colors.red.shade700,
                    ),
                  ),
              ],
            ),
          ),
          Text(
            '${amount.toStringAsFixed(0)} DT',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

