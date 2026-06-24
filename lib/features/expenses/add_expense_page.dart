import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../constants/expense_categories.dart';
import '../../services/firestore_service.dart';
import '../../services/ai_service.dart';
import '../../services/storage_service.dart';
import '../../utils/app_colors.dart';
import '../../utils/expense_date_utils.dart';

class AddExpensePage extends StatefulWidget {
  final String? expenseId;
  final Map<String, dynamic>? initialData;

  const AddExpensePage({
    super.key,
    this.expenseId,
    this.initialData,
  });

  bool get isEditing => expenseId != null;

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  final firestoreService = FirestoreService();
  final storageService = StorageService();
  final titleController = TextEditingController();
  final amountController = TextEditingController();

  String selectedCategory = 'Other';
  DateTime selectedDate = DateTime.now();
  String? receiptUrl;
  File? _receiptFile;
  bool _isSaving = false;

  Timer? _debounceTimer;
  bool _isAutoCategorizing = false;
  String? _aiSuggestionMessage;
  bool _userInteractedWithCategory = false;

  @override
  void initState() {
    super.initState();
    final data = widget.initialData;
    if (data != null) {
      titleController.text = data['title'] as String? ?? '';
      amountController.text =
          ((data['amount'] as num?)?.toDouble() ?? 0).toString();
      selectedCategory = data['category'] as String? ?? 'Other';
      selectedDate =
          ExpenseDateUtils.parse(data['date']) ?? DateTime.now();
      receiptUrl = data['receiptUrl'] as String?;
      _userInteractedWithCategory = true;
    }
    if (!widget.isEditing) {
      titleController.addListener(_onTitleChanged);
    }
  }

  void _onTitleChanged() {
    if (_userInteractedWithCategory) return;

    final text = titleController.text.trim();
    if (text.isEmpty) {
      setState(() => _aiSuggestionMessage = null);
      return;
    }

    final localMatch = _matchLocalCategory(text);
    if (localMatch != null) {
      _debounceTimer?.cancel();
      setState(() {
        selectedCategory = localMatch;
        _aiSuggestionMessage = '✨ Auto-selected: $localMatch';
      });
      return;
    }

    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 800), () {
      _fetchAICategory(text);
    });
  }

  String? _matchLocalCategory(String title) {
    final lowercase = title.toLowerCase();

    if (RegExp(r'\b(rent|kré|kraya|owner|coloc|house|apartment|dari|dar)\b')
        .hasMatch(lowercase)) {
      return 'Rent';
    }
    if (RegExp(
            r'\b(steg|sonede|telecom|ooredoo|orange|topnet|bill|electricity|water|wifi|gaz|internet|recharge|facture)\b')
        .hasMatch(lowercase)) {
      return 'Bills';
    }
    if (RegExp(
            r'\b(burger|pizza|restaurant|cafe|chawarma|makloub|kfc|food|lunch|dinner|breakfast|cappuccino|baguette|plat|makla)\b')
        .hasMatch(lowercase)) {
      return 'Food';
    }
    if (RegExp(
            r'\b(monoprix|carrefour|aziza|mg|superette|marche|attar|hanout|epicerie|lait|pain|khobz|water|groceries|dghira|khodhra)\b')
        .hasMatch(lowercase)) {
      return 'Groceries';
    }
    if (RegExp(
            r'\b(metro|taxi|bolt|indrive|bus|transport|essence|gasoline|carbure|car|train|tcv|louage|krohab)\b')
        .hasMatch(lowercase)) {
      return 'Transport';
    }
    if (RegExp(
            r'\b(cinema|film|netflix|party|concert|pub|game|luna|fun|outing|fest|gaming|salle)\b')
        .hasMatch(lowercase)) {
      return 'Entertainment';
    }
    if (RegExp(
            r'\b(pharmacy|pharma|doctor|medecin|clinique|hopital|medical|dawa|dentist|dent)\b')
        .hasMatch(lowercase)) {
      return 'Healthcare';
    }
    if (RegExp(
            r'\b(university|fac|ecole|inscription|stylo|cahier|book|cours|etudes|revision|faculte|school)\b')
        .hasMatch(lowercase)) {
      return 'Education';
    }
    if (RegExp(
            r'\b(zara|bershka|celio|shopping|clothes|shoes|pull|jacket|robe|pantalon|boutique|mall)\b')
        .hasMatch(lowercase)) {
      return 'Shopping';
    }
    if (RegExp(r'\b(saving|epargne|banque|invest|gold|crypto|depot)\b')
        .hasMatch(lowercase)) {
      return 'Savings';
    }

    return null;
  }

  Future<void> _fetchAICategory(String title) async {
    if (!mounted) return;
    setState(() {
      _isAutoCategorizing = true;
      _aiSuggestionMessage = null;
    });

    try {
      final category = await AIService().classifyCategory(title);
      if (expenseCategories.contains(category) && mounted && !_userInteractedWithCategory) {
        setState(() {
          selectedCategory = category;
          _aiSuggestionMessage = '✨ AI Categorized: $category';
        });
      }
    } catch (e) {
      debugPrint('Error auto-categorizing: $e');
    } finally {
      if (mounted) setState(() => _isAutoCategorizing = false);
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );
    if (picked != null) setState(() => selectedDate = picked);
  }

  Future<void> _pickReceipt() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: const Text('Take photo'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Choose from gallery'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
    if (source == null) return;

    final picker = ImagePicker();
    final image = await picker.pickImage(source: source, imageQuality: 75);
    if (image != null) {
      setState(() => _receiptFile = File(image.path));
    }
  }

  Future<void> _save() async {
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

    setState(() => _isSaving = true);

    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      String? uploadedReceiptUrl = receiptUrl;

      if (_receiptFile != null) {
        uploadedReceiptUrl = await storageService.uploadReceipt(
          userId: userId,
          imageFile: _receiptFile!,
        );
      }

      final payload = {
        'title': title,
        'amount': amount,
        'category': selectedCategory,
        'date': selectedDate.toIso8601String(),
        'userId': userId,
        if (uploadedReceiptUrl != null) 'receiptUrl': uploadedReceiptUrl,
      };

      if (widget.isEditing) {
        await firestoreService.updateExpense(widget.expenseId!, payload);
      } else {
        await firestoreService.createExpense(payload);
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.isEditing ? 'Expense updated' : 'Expense saved successfully',
            ),
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  void dispose() {
    if (!widget.isEditing) {
      titleController.removeListener(_onTitleChanged);
    }
    titleController.dispose();
    amountController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dateLabel = DateFormat('EEE, MMM d, yyyy').format(selectedDate);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          widget.isEditing ? 'Edit Expense' : 'Add Expense',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: 'Expense Title',
                      hintText: 'e.g., Carrefour groceries',
                      border: UnderlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: amountController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Amount',
                      suffixText: 'DT',
                      border: UnderlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.calendar_today_outlined),
                    title: const Text('Date'),
                    subtitle: Text(dateLabel),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: _pickDate,
                  ),
                  const Divider(),
                  InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    ),
                    child: DropdownButton<String>(
                      value: selectedCategory,
                      isExpanded: true,
                      underline: const SizedBox.shrink(),
                      items: expenseCategories.map((category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCategory = value!;
                          _userInteractedWithCategory = true;
                          _aiSuggestionMessage = null;
                        });
                      },
                    ),
                  ),
                  if (_isAutoCategorizing) ...[
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Flousi is categorizing...',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ] else if (_aiSuggestionMessage != null) ...[
                    const SizedBox(height: 10),
                    Text(
                      _aiSuggestionMessage!,
                      style: TextStyle(
                        color: Colors.deepPurple.shade900,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: _pickReceipt,
                    icon: const Icon(Icons.receipt_long_outlined),
                    label: Text(
                      _receiptFile != null || receiptUrl != null
                          ? 'Receipt attached'
                          : 'Attach receipt photo',
                    ),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                  if (_receiptFile != null) ...[
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        _receiptFile!,
                        height: 120,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ] else if (receiptUrl != null) ...[
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        receiptUrl!,
                        height: 120,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const SizedBox.shrink(),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.lavender,
                foregroundColor: Colors.deepPurple.shade900,
                elevation: 0,
                minimumSize: const Size.fromHeight(56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
              ),
              onPressed: _isSaving ? null : _save,
              child: _isSaving
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(
                      widget.isEditing ? 'Update Expense' : 'Save Expense',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
