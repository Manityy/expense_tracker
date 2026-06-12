class UserModel {
  final String uid;
  final String name;
  final String email;
  final double salary;
  final double savingsGoal;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.salary,
    required this.savingsGoal,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'salary': salary,
      'savingsGoal': savingsGoal,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      name: map['name'],
      email: map['email'],
      salary: (map['salary'] ?? 0).toDouble(),
      savingsGoal: (map['savingsGoal'] ?? 0).toDouble(),
    );
  }
}