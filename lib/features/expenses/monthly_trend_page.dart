import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
class MonthlyTrendPage extends StatelessWidget {
  const MonthlyTrendPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Monthly Trend'),
      ),
      body: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
        future: FirebaseFirestore.instance
            .collection('expenses')
            .where('userId', isEqualTo: userId)
            .get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final expenses = snapshot.data!.docs;

          if (expenses.isEmpty) {
            return const Center(
              child: Text('No expenses yet'),
            );
          }

          final Map<String, double> monthlyTotals = {};

          for (final doc in expenses) {
            final data = doc.data();

            final date = DateTime.parse(data['date']);
            final amount = (data['amount'] as num).toDouble();

            final monthKey =
                '${date.year}-${date.month.toString().padLeft(2, '0')}';

            monthlyTotals[monthKey] =
                (monthlyTotals[monthKey] ?? 0) + amount;
          }

          final sortedMonths = monthlyTotals.keys.toList()
            ..sort();
          final spots = <FlSpot>[];

          for (int i = 0; i < sortedMonths.length; i++) {
            spots.add(
              FlSpot(
                i.toDouble(),
                monthlyTotals[sortedMonths[i]]!,
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Text(
                  'Monthly Spending Trend',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                SizedBox(
                  height: 300,
                  child: LineChart(
                    LineChartData(
                      lineBarsData: [
                        LineChartBarData(
                          spots: spots,
                          isCurved: true,
                          dotData: const FlDotData(
                            show: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Expanded(
                  child: ListView.builder(
                    itemCount: sortedMonths.length,
                    itemBuilder: (context, index) {
                      final month = sortedMonths[index];

                      return ListTile(
                        title: Text(month),
                        trailing: Text(
                          '${monthlyTotals[month]!.toStringAsFixed(0)} DT',
                        ),
                      );
                    },
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