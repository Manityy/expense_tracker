import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:expense_tracker/l10n/app_localizations.dart';

import '../../constants/expense_categories.dart';
import '../../services/firestore_service.dart';
import '../../utils/app_colors.dart';
import '../../utils/category_l10n.dart';
import '../../utils/category_utils.dart';
import '../../widgets/expense_card.dart';
import '../../widgets/tunisian_motif.dart';
import 'add_expense_page.dart';

class ExpenseListPage extends StatefulWidget {
  const ExpenseListPage({super.key});

  @override
  State<ExpenseListPage> createState() => _ExpenseListPageState();
}

class _ExpenseListPageState extends State<ExpenseListPage> {
  final firestoreService = FirestoreService();
  final _searchController = TextEditingController();
  String? _selectedCategory;

  static const _categories = ['All', ...expenseCategories];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is String) return DateTime.tryParse(value);
    return null;
  }

  String _formatDateHeader(DateTime date, AppLocalizations l10n) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final expenseDay = DateTime(date.year, date.month, date.day);
    final locale = Localizations.localeOf(context).toString();

    if (expenseDay == today) return l10n.today;
    if (expenseDay == today.subtract(const Duration(days: 1))) {
      return l10n.yesterday;
    }
    return DateFormat('EEEE, MMM d', locale).format(date);
  }

  Future<bool> _confirmDelete(BuildContext context, AppLocalizations l10n) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Text(l10n.deleteExpense),
              content: Text(l10n.deleteExpenseConfirm),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text(l10n.cancel),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.redAccent,
                  ),
                  child: Text(l10n.delete),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  List<QueryDocumentSnapshot<Map<String, dynamic>>> _filterExpenses(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> expenses,
  ) {
    final query = _searchController.text.trim().toLowerCase();

    return expenses.where((doc) {
      final expense = doc.data();
      final title = (expense['title'] as String? ?? '').toLowerCase();
      final category = expense['category'] as String? ?? 'Other';

      final matchesSearch =
          query.isEmpty || title.contains(query) || category.toLowerCase().contains(query);
      final matchesCategory =
          _selectedCategory == null || category == _selectedCategory;

      return matchesSearch && matchesCategory;
    }).toList();
  }

  Map<String, List<QueryDocumentSnapshot<Map<String, dynamic>>>> _groupByDate(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> expenses,
  ) {
    final sorted = List<QueryDocumentSnapshot<Map<String, dynamic>>>.from(expenses)
      ..sort((a, b) {
        final dateA = _parseDate(a.data()['date']) ?? DateTime(1970);
        final dateB = _parseDate(b.data()['date']) ?? DateTime(1970);
        return dateB.compareTo(dateA);
      });

    final grouped = <String, List<QueryDocumentSnapshot<Map<String, dynamic>>>>{};

    for (final doc in sorted) {
      final date = _parseDate(doc.data()['date']) ?? DateTime.now();
      final key = DateFormat('yyyy-MM-dd').format(date);
      grouped.putIfAbsent(key, () => []).add(doc);
    }

    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(l10n.myExpenses),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddExpensePage()),
          );
        },
        backgroundColor: AppColors.lavender,
        foregroundColor: Colors.deepPurple.shade900,
        icon: const Icon(Icons.add),
        label: Text(l10n.addExpense),
        elevation: 2,
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: firestoreService.getUserExpenses(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(l10n.errorLoadingExpenses('${snapshot.error}')),
            );
          }

          final allExpenses = snapshot.data?.docs ?? [];

          if (allExpenses.isEmpty) {
            return TunisianEmptyState(
              embedded: true,
              icon: Icons.receipt_long_outlined,
              title: l10n.noExpensesYetShort,
              subtitle: l10n.noExpensesYetSubtitle,
              showPalm: false,
              action: FilledButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AddExpensePage(),
                    ),
                  );
                },
                icon: const Icon(Icons.add),
                label: Text(l10n.addExpense),
              ),
            );
          }

          final filtered = _filterExpenses(allExpenses);
          final totalAmount = filtered.fold<double>(0, (total, doc) {
            return total + ((doc.data()['amount'] as num?)?.toDouble() ?? 0);
          });
          final grouped = _groupByDate(filtered);
          final groupKeys = grouped.keys.toList()
            ..sort((a, b) => b.compareTo(a));

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.pink,
                            AppColors.lavender.withValues(alpha: 0.8),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.expensesCount(filtered.length),
                                  style: TextStyle(
                                    color: Colors.black.withValues(alpha: 0.6),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${totalAmount.toStringAsFixed(0)} DT',
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.5),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.payments_outlined),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _searchController,
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        hintText: l10n.searchExpenses,
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() {});
                                },
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 36,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _categories.length,
                        separatorBuilder: (context, _) => const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          final category = _categories[index];
                          final isAll = category == 'All';
                          final isSelected = isAll
                              ? _selectedCategory == null
                              : _selectedCategory == category;

                          return FilterChip(
                            label: Text(
                              isAll
                                  ? l10n.all
                                  : CategoryL10n.name(l10n, category),
                            ),
                            selected: isSelected,
                            showCheckmark: false,
                            selectedColor: AppColors.lavender,
                            backgroundColor: Colors.white,
                            side: BorderSide(
                              color: isSelected
                                  ? AppColors.lavender
                                  : Colors.grey.shade300,
                            ),
                            onSelected: (_) {
                              setState(() {
                                _selectedCategory = isAll ? null : category;
                              });
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    await Future<void>.delayed(const Duration(milliseconds: 400));
                  },
                  child: filtered.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 48,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              l10n.noMatchingExpenses,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                        itemCount: groupKeys.length,
                        itemBuilder: (context, groupIndex) {
                          final key = groupKeys[groupIndex];
                          final groupExpenses = grouped[key]!;
                          final headerDate =
                              _parseDate(groupExpenses.first.data()['date']) ??
                                  DateTime.now();

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 8,
                                  bottom: 8,
                                ),
                                child: Text(
                                  _formatDateHeader(headerDate, l10n),
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              ),
                              ...groupExpenses.map((doc) {
                                final expense = doc.data();
                                final category =
                                    expense['category'] as String? ?? 'Other';
                                final amount =
                                    (expense['amount'] as num?)?.toDouble() ?? 0;
                                final date =
                                    _parseDate(expense['date']) ?? DateTime.now();

                                return Dismissible(
                                  key: ValueKey(doc.id),
                                  direction: DismissDirection.endToStart,
                                  background: Container(
                                    alignment: Alignment.centerRight,
                                    padding: const EdgeInsets.only(right: 24),
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.redAccent.shade100,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Icon(
                                      Icons.delete_outline,
                                      color: Colors.redAccent.shade700,
                                    ),
                                  ),
                                  confirmDismiss: (_) =>
                                      _confirmDelete(context, l10n),
                                  onDismissed: (_) {
                                    firestoreService.deleteExpense(doc.id);
                                  },
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => AddExpensePage(
                                            expenseId: doc.id,
                                            initialData: expense,
                                          ),
                                        ),
                                      );
                                    },
                                    child: ExpenseCard(
                                      title: expense['title'] as String? ?? '',
                                      category: CategoryL10n.name(l10n, category),
                                      amount: '${amount.toStringAsFixed(0)} DT',
                                      icon: CategoryUtils.getIcon(category),
                                      color: CategoryUtils.getColor(category),
                                      dateLabel: DateFormat('h:mm a', locale)
                                          .format(date),
                                    ),
                                  ),
                                );
                              }),
                            ],
                          );
                        },
                      ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
