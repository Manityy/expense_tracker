import 'package:cloud_firestore/cloud_firestore.dart';

class ExpenseDateUtils {
  static DateTime? parse(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is String) return DateTime.tryParse(value);
    return null;
  }

  static bool isInMonth(DateTime date, DateTime month) {
    return date.year == month.year && date.month == month.month;
  }

  static String monthLabel(DateTime date) {
    const names = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${names[date.month - 1]} ${date.year}';
  }
}
