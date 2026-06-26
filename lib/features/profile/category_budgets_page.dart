import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/l10n/app_localizations.dart';
import '../../constants/expense_categories.dart';
import '../../services/firestore_service.dart';
import '../../models/user_model.dart';
import '../../utils/app_colors.dart';
import '../../utils/category_l10n.dart';

class CategoryBudgetsPage extends StatefulWidget {
  const CategoryBudgetsPage({super.key});

  @override
  State<CategoryBudgetsPage> createState() => _CategoryBudgetsPageState();
}

class _CategoryBudgetsPageState extends State<CategoryBudgetsPage> {
  final firestoreService = FirestoreService();
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  final List<String> categories = expenseCategories;

  final Map<String, TextEditingController> _controllers = {};
  bool _isLoading = true;

  String getCategoryIcon(String category) {
    switch (category) {
      case 'Rent': return '🏠';
      case 'Bills': return '💡';
      case 'Food': return '🍔';
      case 'Groceries': return '🛒';
      case 'Transport': return '🚌';
      case 'Entertainment': return '🎉';
      case 'Healthcare': return '🏥';
      case 'Education': return '📚';
      case 'Shopping': return '🛍️';
      case 'Savings': return '💰';
      default: return '💸';
    }
  }

  Color getCategoryColor(String category) {
    switch (category) {
      case 'Rent': return AppColors.lavender;
      case 'Bills': return AppColors.blue;
      case 'Food': return AppColors.yellow;
      case 'Groceries': return AppColors.sage;
      case 'Transport': return AppColors.blue;
      case 'Entertainment': return AppColors.pink;
      case 'Healthcare': return AppColors.sage;
      case 'Education': return AppColors.lavender;
      case 'Shopping': return AppColors.pink;
      case 'Savings': return AppColors.sage;
      default: return Colors.grey.shade100;
    }
  }

  @override
  void initState() {
    super.initState();
    for (final category in categories) {
      _controllers[category] = TextEditingController();
    }
    _loadBudgets();
  }

  Future<void> _loadBudgets() async {
    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      final data = doc.data();
      if (data != null) {
        final user = UserModel.fromMap(data);
        for (final category in categories) {
          final limit = user.categoryBudgets[category];
          if (limit != null && limit > 0) {
            _controllers[category]!.text = limit.toStringAsFixed(0);
          }
        }
      }
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.errorLoadingBudgets('$e'))),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _saveBudgets() async {
    setState(() {
      _isLoading = true;
    });

    final Map<String, double> updatedBudgets = {};
    for (final category in categories) {
      final text = _controllers[category]!.text.trim();
      if (text.isNotEmpty) {
        final val = double.tryParse(text);
        if (val != null && val >= 0) {
          updatedBudgets[category] = val;
        }
      }
    }

    try {
      await firestoreService.updateCategoryBudgets(userId, updatedBudgets);
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.budgetsSaved)),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.errorSavingBudgets('$e'))),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          l10n.categoryBudgetsTitle,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.lavender),
              ),
            )
          : Scrollbar(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.02),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: getCategoryColor(category),
                          radius: 20,
                          child: Text(
                            getCategoryIcon(category),
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            CategoryL10n.name(l10n, category),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        SizedBox(
                          width: 120,
                          child: TextField(
                            controller: _controllers[category],
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.end,
                            decoration: InputDecoration(
                              hintText: l10n.noLimit,
                              hintStyle: TextStyle(color: Colors.grey.shade400),
                              suffixText: ' DT',
                              suffixStyle: const TextStyle(fontWeight: FontWeight.bold),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Colors.grey.shade200),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Colors.grey.shade100),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: AppColors.lavender),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
      bottomNavigationBar: _isLoading
          ? null
          : Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.lavender,
                  foregroundColor: Colors.deepPurple.shade900,
                  elevation: 0,
                  minimumSize: const Size.fromHeight(56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                onPressed: _saveBudgets,
                child: Text(
                  l10n.save,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
    );
  }
}
