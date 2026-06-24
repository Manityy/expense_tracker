import 'package:flutter/material.dart';
import 'app_colors.dart';

class CategoryUtils {
  static String getIcon(String category) {
    switch (category) {
      case 'Rent':
        return '🏠';
      case 'Bills':
        return '💡';
      case 'Food':
        return '🍔';
      case 'Groceries':
        return '🛒';
      case 'Transport':
        return '🚌';
      case 'Entertainment':
        return '🎉';
      case 'Healthcare':
        return '🏥';
      case 'Education':
        return '📚';
      case 'Shopping':
        return '🛍️';
      case 'Savings':
        return '💰';
      default:
        return '💸';
    }
  }

  static Color getColor(String category) {
    switch (category) {
      case 'Rent':
        return AppColors.lavender;
      case 'Bills':
        return AppColors.blue;
      case 'Food':
        return AppColors.yellow;
      case 'Groceries':
        return AppColors.sage;
      case 'Transport':
        return AppColors.blue;
      case 'Entertainment':
        return AppColors.pink;
      case 'Healthcare':
        return AppColors.sage;
      case 'Education':
        return AppColors.lavender;
      case 'Shopping':
        return AppColors.pink;
      case 'Savings':
        return AppColors.sage;
      default:
        return Colors.white;
    }
  }
}
