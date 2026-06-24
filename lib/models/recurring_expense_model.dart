class RecurringExpenseModel {
  final String id;
  final String title;
  final double amount;
  final String category;
  final int dayOfMonth;
  final DateTime createdAt;
  final String userId;
  final String? lastPostedMonth;

  RecurringExpenseModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.dayOfMonth,
    required this.createdAt,
    required this.userId,
    this.lastPostedMonth,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'category': category,
      'dayOfMonth': dayOfMonth,
      'createdAt': createdAt.toIso8601String(),
      'userId': userId,
      if (lastPostedMonth != null) 'lastPostedMonth': lastPostedMonth,
    };
  }

  factory RecurringExpenseModel.fromMap(String id, Map<String, dynamic> map) {
    return RecurringExpenseModel(
      id: id,
      title: map['title'] ?? '',
      amount: (map['amount'] as num?)?.toDouble() ?? 0.0,
      category: map['category'] ?? '',
      dayOfMonth: map['dayOfMonth'] ?? 1,
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
      userId: map['userId'] ?? '',
      lastPostedMonth: map['lastPostedMonth'] as String?,
    );
  }
}
