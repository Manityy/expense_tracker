import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/firestore_service.dart';
import 'package:fl_chart/fl_chart.dart';
import 'monthly_trend_page.dart';
class AnalyticsPage extends StatelessWidget {
  AnalyticsPage({super.key});

  final firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
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

          final Map<String, double> categoryTotals = {};
          double grandTotal = 0;

          for (final doc in expenses) {
            final data = doc.data();

            final category = data['category'] as String;
            final amount = (data['amount'] as num).toDouble();

            categoryTotals[category] =
                (categoryTotals[category] ?? 0) + amount;

            grandTotal += amount;
          }
          final sortedEntries = categoryTotals.entries.toList()
            ..sort((a, b) => b.value.compareTo(a.value));
          final sections = sortedEntries.map((entry) {
            return PieChartSectionData(
              value: entry.value,
              title: entry.key,
              radius: 80,
            );
          }).toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.show_chart),
                    title: const Text('Monthly Trend'),
                    subtitle: const Text('View spending over time'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const MonthlyTrendPage(),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 20),


                SizedBox(
                  height: 300,
                  child: PieChart(
                    PieChartData(
                      sections: sections,
                      centerSpaceRadius: 40,
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                ...sortedEntries.map((entry) {
                  final percentage = (entry.value / grandTotal) * 100;

                  return Card(
                    child: ListTile(
                      title: Text(entry.key),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${entry.value.toStringAsFixed(0)} DT',
                          ),
                          Text(
                            '${percentage.toStringAsFixed(1)}%',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          );
        },
      ),
    );
  }
}