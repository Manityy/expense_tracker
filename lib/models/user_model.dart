class UserModel {
  final String uid;
  final String name;
  final String email;
  final double salary;
  final double savingsGoal;
  final Map<String, double> categoryBudgets;
  final bool onboardingCompleted;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.salary,
    required this.savingsGoal,
    Map<String, double>? categoryBudgets,
    this.onboardingCompleted = false,
  }) : categoryBudgets = categoryBudgets ?? {};

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'salary': salary,
      'savingsGoal': savingsGoal,
      'categoryBudgets': categoryBudgets,
      'onboardingCompleted': onboardingCompleted,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    final rawBudgets = map['categoryBudgets'] as Map<dynamic, dynamic>? ?? {};
    final budgets = rawBudgets.map(
      (key, value) => MapEntry(key.toString(), (value as num).toDouble()),
    );

    return UserModel(
      uid: map['uid'],
      name: map['name'],
      email: map['email'],
      salary: (map['salary'] ?? 0).toDouble(),
      savingsGoal: (map['savingsGoal'] ?? 0).toDouble(),
      categoryBudgets: budgets,
      onboardingCompleted: map['onboardingCompleted'] ?? false,
    );
  }
}