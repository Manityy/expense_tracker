import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../services/firestore_service.dart';
import 'monthly_trend_page.dart';
import '../../utils/app_colors.dart';
import '../../utils/expense_date_utils.dart';
import '../../utils/analytics_helpers.dart';
import '../../utils/category_utils.dart';
import '../../models/user_model.dart';
import '../../widgets/tunisian_motif.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  final firestoreService = FirestoreService();
  int _touchedCategory = -1;
  int _reloadToken = 0;
  DateTime _selectedMonth = DateTime(DateTime.now().year, DateTime.now().month);

  Future<Map<String, dynamic>> _loadAnalyticsData() {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    return Future.wait([
      FirebaseFirestore.instance
          .collection('expenses')
          .where('userId', isEqualTo: userId)
          .get(),
      firestoreService.getUser(userId),
    ]).then((results) => {
          'expenses': (results[0] as QuerySnapshot<Map<String, dynamic>>).docs,
          'userDoc': results[1] as DocumentSnapshot<Map<String, dynamic>>,
        });
  }

  Future<void> _pickMonth() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedMonth,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedMonth = DateTime(picked.year, picked.month);
        _touchedCategory = -1;
      });
    }
  }

  Future<void> _refresh() async {
    setState(() {
      _reloadToken++;
      _touchedCategory = -1;
    });
    await Future<void>.delayed(const Duration(milliseconds: 300));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Analytics'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        key: ValueKey(_reloadToken),
        future: _loadAnalyticsData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('Unable to load analytics'));
          }

          final data = snapshot.data!;
          final expenses =
              data['expenses'] as List<QueryDocumentSnapshot<Map<String, dynamic>>>;
          final userDoc = data['userDoc'] as DocumentSnapshot<Map<String, dynamic>>;

          if (expenses.isEmpty) {
            return TunisianEmptyState(
              embedded: true,
              icon: Icons.pie_chart_outline,
              title: 'No expenses yet',
              subtitle: 'Start tracking to unlock analytics.',
            );
          }

          final userModel = userDoc.exists
              ? UserModel.fromMap(userDoc.data()!)
              : UserModel(uid: '', name: '', email: '', salary: 0, savingsGoal: 0);
          final salary = userModel.salary;
          final month = _selectedMonth;

          final monthExpenses = expenses.where((doc) {
            final date = ExpenseDateUtils.parse(doc.data()['date']);
            return date != null && ExpenseDateUtils.isInMonth(date, month);
          }).toList();

          final totals = AnalyticsHelpers.monthlyTotalsFromExpenses(expenses);
          final last6 = AnalyticsHelpers.lastNMonths(
            totals: totals,
            count: 6,
            endMonth: month,
          );
          final maxY = AnalyticsHelpers.chartMaxY(last6.map((e) => e.value));
          final selectedMonthKey =
              '${month.year}-${month.month.toString().padLeft(2, '0')}';

          final categoryTotals = <String, double>{};
          var grandTotal = 0.0;
          for (final doc in monthExpenses) {
            final d = doc.data();
            final cat = d['category'] as String? ?? 'Other';
            final amt = (d['amount'] as num?)?.toDouble() ?? 0;
            categoryTotals[cat] = (categoryTotals[cat] ?? 0) + amt;
            grandTotal += amt;
          }

          final sortedCategories = categoryTotals.entries.toList()
            ..sort((a, b) => b.value.compareTo(a.value));

          final remaining = salary - grandTotal;
          final usagePct = salary > 0 ? (grandTotal / salary) * 100 : 0.0;

          if (monthExpenses.isEmpty) {
            return RefreshIndicator(
              onRefresh: _refresh,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(20),
                children: [
                  _MonthBanner(
                    label: ExpenseDateUtils.monthLabel(month),
                    onTap: _pickMonth,
                  ),
                  const SizedBox(height: 40),
                  Icon(Icons.calendar_month_outlined,
                      size: 56, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text(
                    'No expenses in ${ExpenseDateUtils.monthLabel(month)}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Pick another month or add an expense.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _refresh,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _MonthBanner(
                    label: ExpenseDateUtils.monthLabel(month),
                    onTap: _pickMonth,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          label: 'Spent',
                          value: '${grandTotal.toStringAsFixed(0)} DT',
                          color: AppColors.pink,
                          icon: Icons.payments_outlined,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatCard(
                          label: 'Remaining',
                          value: '${remaining.toStringAsFixed(0)} DT',
                          color: remaining >= 0 ? AppColors.sage : AppColors.pink,
                          icon: Icons.savings_outlined,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          label: 'Of income',
                          value: salary > 0
                              ? '${usagePct.toStringAsFixed(0)}%'
                              : '—',
                          color: AppColors.yellow,
                          icon: Icons.percent,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatCard(
                          label: 'Transactions',
                          value: '${monthExpenses.length}',
                          color: AppColors.saffron,
                          icon: Icons.receipt_long_outlined,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'By category',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      children: [
                        if (sortedCategories.length >= 2) ...[
                          SizedBox(
                            height: 180,
                            child: PieChart(
                              PieChartData(
                                sectionsSpace: 3,
                                centerSpaceRadius: 48,
                                pieTouchData: PieTouchData(
                                  touchCallback: (event, response) {
                                    setState(() {
                                      if (!event.isInterestedForInteractions ||
                                          response?.touchedSection == null) {
                                        _touchedCategory = -1;
                                        return;
                                      }
                                      _touchedCategory = response!
                                          .touchedSection!.touchedSectionIndex;
                                    });
                                  },
                                ),
                                sections: List.generate(
                                  sortedCategories.length,
                                  (i) {
                                    final entry = sortedCategories[i];
                                    final colors = AppColors.cardPalette;
                                    final isTouched = _touchedCategory == i;
                                    return PieChartSectionData(
                                      value: entry.value,
                                      color: colors[i % colors.length],
                                      radius: isTouched ? 52 : 42,
                                      title: isTouched
                                          ? '${(entry.value / grandTotal * 100).toStringAsFixed(0)}%'
                                          : '',
                                      titleStyle: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                        ...sortedCategories.map((entry) {
                          final pct = grandTotal > 0
                              ? entry.value / grandTotal
                              : 0.0;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      CategoryUtils.getIcon(entry.key),
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        entry.key,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '${entry.value.toStringAsFixed(0)} DT',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: LinearProgressIndicator(
                                    value: pct.clamp(0, 1),
                                    minHeight: 8,
                                    backgroundColor: Colors.grey.shade100,
                                    color: CategoryUtils.getColor(entry.key),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${(pct * 100).toStringAsFixed(0)}% of spending',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    '6-month spending',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(12, 20, 16, 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: SizedBox(
                      height: 200,
                      child: BarChart(
                        BarChartData(
                          maxY: maxY,
                          minY: 0,
                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: false,
                            horizontalInterval: maxY / 4,
                            getDrawingHorizontalLine: (v) => FlLine(
                              color: Colors.grey.shade200,
                              strokeWidth: 1,
                            ),
                          ),
                          borderData: FlBorderData(show: false),
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
                                reservedSize: 40,
                                interval: maxY / 4,
                                getTitlesWidget: (v, meta) => Text(
                                  v.toStringAsFixed(0),
                                  style: TextStyle(
                                    fontSize: 9,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 28,
                                getTitlesWidget: (v, meta) {
                                  final i = v.toInt();
                                  if (i < 0 || i >= last6.length) {
                                    return const SizedBox.shrink();
                                  }
                                  return Text(
                                    AnalyticsHelpers.formatMonthKey(last6[i].key)
                                        .split(' ')
                                        .first,
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey.shade600,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          barGroups: List.generate(last6.length, (i) {
                            final isSelected = last6[i].key == selectedMonthKey;
                            return BarChartGroupData(
                              x: i,
                              barRods: [
                                BarChartRodData(
                                  toY: last6[i].value,
                                  width: 18,
                                  color: isSelected
                                      ? AppColors.sidiBlue
                                      : AppColors.mediterranean.withValues(alpha: 0.65),
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(6),
                                  ),
                                ),
                              ],
                            );
                          }),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Material(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(24),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const MonthlyTrendPage(),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.saffron,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Icon(Icons.insights),
                            ),
                            const SizedBox(width: 16),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Full monthly history',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Trends, averages & month-over-month',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(Icons.chevron_right, color: Colors.grey.shade400),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _MonthBanner extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _MonthBanner({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.saffron.withValues(alpha: 0.45),
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              const Icon(Icons.calendar_month_outlined, size: 22),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
              Text(
                'Change',
                style: TextStyle(
                  color: AppColors.sidiBlue,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
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
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 22),
          const SizedBox(height: 10),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.black.withValues(alpha: 0.55),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}
