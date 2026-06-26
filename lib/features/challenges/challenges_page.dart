import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:expense_tracker/l10n/app_localizations.dart';
import '../../services/firestore_service.dart';
import '../../utils/app_colors.dart';
import '../../utils/challenges_helper.dart';
import '../../models/user_model.dart';

class ChallengesPage extends StatefulWidget {
  const ChallengesPage({super.key});

  @override
  State<ChallengesPage> createState() => _ChallengesPageState();
}

class _ChallengesPageState extends State<ChallengesPage> {
  final firestoreService = FirestoreService();

  Future<List<dynamic>> _loadData() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    return Future.wait([
      firestoreService.getThisWeekExpenses(userId),
      firestoreService.getThisWeekendExpenses(userId),
      firestoreService.getLastWeekExpenses(userId),
      firestoreService.getCategorySpendingThisMonth(userId),
      firestoreService.getUser(userId),
    ]);
  }

  IconData _getChallengeIcon(String title) {
    if (title.contains('Weekend')) return Icons.weekend_outlined;
    if (title.contains('Food')) return Icons.local_cafe_outlined;
    if (title.contains('Saver')) return Icons.savings_outlined;
    return Icons.shield_outlined;
  }

  Color _getChallengeThemeColor(String title) {
    if (title.contains('Weekend')) return AppColors.lavender;
    if (title.contains('Food')) return AppColors.pink;
    if (title.contains('Saver')) return AppColors.yellow;
    return AppColors.sage;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.savingsChallenges),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _loadData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error loading challenges: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          final data = snapshot.data!;
          final weekExpenses = data[0] as List<Map<String, dynamic>>;
          final weekendExpenses = data[1] as List<Map<String, dynamic>>;
          final lastWeekExpenses = data[2] as List<Map<String, dynamic>>;
          final monthSpending = data[3] as Map<String, double>;
          final userDoc = data[4];

          final budgets = userDoc.exists
              ? UserModel.fromMap(userDoc.data()!).categoryBudgets
              : <String, double>{};

          final challenges = ChallengesHelper.evaluate(
            weekExpenses: weekExpenses,
            weekendExpenses: weekendExpenses,
            lastWeekExpenses: lastWeekExpenses,
            monthSpending: monthSpending,
            categoryBudgets: budgets,
          );

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: challenges.length,
            itemBuilder: (context, index) {
              final challenge = challenges[index];
              final themeColor = _getChallengeThemeColor(challenge.title);
              final isCompleted = challenge.isCompleted;

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: themeColor,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              _getChallengeIcon(challenge.title),
                              color: Colors.deepPurple.shade900,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  challenge.title,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  challenge.statusText,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: isCompleted
                                        ? Colors.green.shade700
                                        : Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (isCompleted)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green.shade50,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.green.shade200,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.check_circle,
                                    size: 16,
                                    color: Colors.green.shade700,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'ACTIVE',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green.shade700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        challenge.description,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Progress bar
                      Row(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: LinearProgressIndicator(
                                value: challenge.progress,
                                minHeight: 8,
                                backgroundColor: Colors.grey[200],
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  isCompleted
                                      ? Colors.green.shade400
                                      : (challenge.progress > 0.8
                                          ? Colors.orange.shade400
                                          : themeColor),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            '${(challenge.progress * 100).toStringAsFixed(0)}%',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
