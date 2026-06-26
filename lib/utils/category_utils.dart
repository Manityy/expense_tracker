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
        return AppColors.terracotta;
      case 'Bills':
        return AppColors.mediterranean;
      case 'Food':
        return AppColors.saffron;
      case 'Groceries':
        return AppColors.olive;
      case 'Transport':
        return AppColors.mediterranean;
      case 'Entertainment':
        return AppColors.harissaSoft;
      case 'Healthcare':
        return AppColors.mint;
      case 'Education':
        return AppColors.saffron;
      case 'Shopping':
        return AppColors.terracotta;
      case 'Savings':
        return AppColors.olive;
      default:
        return AppColors.yellow;
    }
  }
}
