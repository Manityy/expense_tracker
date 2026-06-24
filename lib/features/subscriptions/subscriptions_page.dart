import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/firestore_service.dart';
import '../../models/recurring_expense_model.dart';
import '../../utils/app_colors.dart';

class SubscriptionsPage extends StatefulWidget {
  const SubscriptionsPage({super.key});

  @override
  State<SubscriptionsPage> createState() => _SubscriptionsPageState();
}

class _SubscriptionsPageState extends State<SubscriptionsPage> {
  final firestoreService = FirestoreService();

  final List<String> categories = [
    'Rent',
    'Bills',
    'Food',
    'Groceries',
    'Transport',
    'Entertainment',
    'Healthcare',
    'Education',
    'Shopping',
    'Savings',
    'Other'
  ];

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Rent':
        return Icons.home_outlined;
      case 'Bills':
        return Icons.receipt_outlined;
      case 'Food':
        return Icons.restaurant_outlined;
      case 'Groceries':
        return Icons.shopping_basket_outlined;
      case 'Transport':
        return Icons.directions_car_outlined;
      case 'Entertainment':
        return Icons.movie_outlined;
      case 'Healthcare':
        return Icons.medical_services_outlined;
      case 'Education':
        return Icons.school_outlined;
      case 'Shopping':
        return Icons.shopping_bag_outlined;
      case 'Savings':
        return Icons.savings_outlined;
      default:
        return Icons.miscellaneous_services_outlined;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Rent':
        return AppColors.lavender;
      case 'Bills':
        return AppColors.blue;
      case 'Food':
        return AppColors.pink;
      case 'Groceries':
        return AppColors.sage;
      case 'Transport':
        return AppColors.yellow;
      case 'Entertainment':
        return AppColors.lavender;
      case 'Healthcare':
        return AppColors.blue;
      case 'Education':
        return AppColors.sage;
      case 'Shopping':
        return AppColors.pink;
      case 'Savings':
        return AppColors.yellow;
      default:
        return AppColors.lavender;
    }
  }

  int _daysUntilOccurrence(int dayOfMonth) {
    final now = DateTime.now();
    final today = now.day;
    
    if (dayOfMonth >= today) {
      return dayOfMonth - today;
    } else {
      final nextMonthYear = now.month == 12 ? now.year + 1 : now.year;
      final nextMonth = now.month == 12 ? 1 : now.month + 1;
      
      final firstOfNext = DateTime(nextMonthYear, nextMonth, 1);
      final lastOfCurrent = firstOfNext.subtract(const Duration(days: 1));
      final daysInCurrentMonth = lastOfCurrent.day;
      
      return (daysInCurrentMonth - today) + dayOfMonth;
    }
  }

  void _showSubscriptionBottomSheet(
    BuildContext context, {
    RecurringExpenseModel? existing,
  }) {
    final titleController = TextEditingController(text: existing?.title ?? '');
    final amountController = TextEditingController(
      text: existing != null ? existing.amount.toString() : '',
    );
    String selectedCategory = existing?.category ?? 'Bills';
    int selectedDay = existing?.dayOfMonth ?? 1;
    final isEditing = existing != null;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
                left: 24,
                right: 24,
                top: 24,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Add Subscription',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: 'Subscription / Title',
                        hintText: 'e.g. Netflix, Rent, Internet',
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: amountController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: 'Amount (DT)',
                        hintText: '0.00',
                      ),
                    ),
                    const SizedBox(height: 16),
                    InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Category',
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedCategory,
                          isExpanded: true,
                          items: categories.map((cat) {
                            return DropdownMenuItem(
                              value: cat,
                              child: Text(cat),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setModalState(() {
                                selectedCategory = val;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Day of Month Due',
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<int>(
                          value: selectedDay,
                          isExpanded: true,
                          items: List.generate(31, (index) => index + 1).map((day) {
                            return DropdownMenuItem(
                              value: day,
                              child: Text('Day $day'),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setModalState(() {
                                selectedDay = val;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.lavender,
                        foregroundColor: Colors.deepPurple.shade900,
                        minimumSize: const Size.fromHeight(56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () async {
                        final title = titleController.text.trim();
                        final amountText = amountController.text.trim();

                        if (title.isEmpty || amountText.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please fill in all fields')),
                          );
                          return;
                        }

                        final amount = double.tryParse(amountText);
                        if (amount == null || amount <= 0) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please enter a valid amount')),
                          );
                          return;
                        }

                        try {
                          final userId = FirebaseAuth.instance.currentUser!.uid;
                          final model = RecurringExpenseModel(
                            id: existing?.id ?? '',
                            title: title,
                            amount: amount,
                            category: selectedCategory,
                            dayOfMonth: selectedDay,
                            createdAt: existing?.createdAt ?? DateTime.now(),
                            userId: userId,
                            lastPostedMonth: existing?.lastPostedMonth,
                          );

                          await firestoreService.addRecurringExpense(userId, model);

                          if (context.mounted) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  isEditing
                                      ? 'Subscription updated'
                                      : 'Subscription added successfully',
                                ),
                              ),
                            );
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error: ${e.toString()}')),
                            );
                          }
                        }
                      },
                      child: Text(
                        isEditing ? 'Update Subscription' : 'Add Subscription',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Subscriptions'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showSubscriptionBottomSheet(context),
        backgroundColor: AppColors.lavender,
        foregroundColor: Colors.deepPurple.shade900,
        icon: const Icon(Icons.add),
        label: const Text('Add Subscription'),
        elevation: 2,
      ),
      body: StreamBuilder<List<RecurringExpenseModel>>(
        stream: firestoreService.getRecurringExpenses(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error loading subscriptions: ${snapshot.error}'));
          }
          final subs = snapshot.data ?? [];
          if (subs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.repeat,
                    size: 64,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No recurring subscriptions yet',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Tap "Add Subscription" to schedule recurring outlays.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }

          // Sort subscriptions by days remaining
          final sortedSubs = List<RecurringExpenseModel>.from(subs)
            ..sort((a, b) => _daysUntilOccurrence(a.dayOfMonth)
                .compareTo(_daysUntilOccurrence(b.dayOfMonth)));

          return ListView.builder(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 88),
            itemCount: sortedSubs.length,
            itemBuilder: (context, index) {
              final sub = sortedSubs[index];
              final daysLeft = _daysUntilOccurrence(sub.dayOfMonth);

              String dueText = '';
              if (daysLeft == 0) {
                dueText = 'Due Today';
              } else if (daysLeft == 1) {
                dueText = 'Due Tomorrow';
              } else {
                dueText = 'Due in $daysLeft days';
              }

              final catColor = _getCategoryColor(sub.category);

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: InkWell(
                  borderRadius: BorderRadius.circular(24),
                  onTap: () => _showSubscriptionBottomSheet(context, existing: sub),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: catColor,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _getCategoryIcon(sub.category),
                          color: Colors.deepPurple.shade900,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              sub.title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Day ${sub.dayOfMonth} of month • $dueText',
                              style: TextStyle(
                                fontSize: 13,
                                color: daysLeft <= 3
                                    ? Colors.redAccent.shade700
                                    : Colors.grey.shade600,
                                fontWeight: daysLeft <= 3 ? FontWeight.w600 : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${sub.amount.toStringAsFixed(2)} DT',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                            onPressed: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Delete Subscription'),
                                  content: Text(
                                      'Are you sure you want to remove the recurring payment for "${sub.title}"?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, false),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, true),
                                      child: const Text('Delete'),
                                    ),
                                  ],
                                ),
                              );
                              if (confirm == true) {
                                await firestoreService.deleteRecurringExpense(userId, sub.id);
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
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
