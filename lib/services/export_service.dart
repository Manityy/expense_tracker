import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../utils/expense_date_utils.dart';

class ExportService {
  Future<void> exportExpensesCsv(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> expenses,
  ) async {
    final buffer = StringBuffer('Date,Title,Category,Amount (DT)\n');

    final sorted = List<QueryDocumentSnapshot<Map<String, dynamic>>>.from(
      expenses,
    )..sort((a, b) {
        final dateA = ExpenseDateUtils.parse(a.data()['date']) ?? DateTime(1970);
        final dateB = ExpenseDateUtils.parse(b.data()['date']) ?? DateTime(1970);
        return dateB.compareTo(dateA);
      });

    for (final doc in sorted) {
      final data = doc.data();
      final date = ExpenseDateUtils.parse(data['date']);
      final dateStr = date != null
          ? '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}'
          : '';
      final title = _escapeCsv(data['title']?.toString() ?? '');
      final category = _escapeCsv(data['category']?.toString() ?? '');
      final amount = (data['amount'] as num?)?.toDouble() ?? 0;
      buffer.writeln('$dateStr,$title,$category,$amount');
    }

    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/flousi_expenses.csv');
    await file.writeAsString(buffer.toString());

    await Share.shareXFiles(
      [XFile(file.path)],
      subject: 'Flousi Expenses Export',
      text: 'Your expense export from Flousi',
    );
  }

  String _escapeCsv(String value) {
    if (value.contains(',') || value.contains('"')) {
      return '"${value.replaceAll('"', '""')}"';
    }
    return value;
  }
}
