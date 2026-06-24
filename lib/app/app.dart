import 'package:flutter/material.dart';
import '../features/auth/auth_wrapper.dart';
import '../utils/app_theme.dart';

class ExpenseTrackerApp extends StatelessWidget {
  const ExpenseTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flousi',
      theme: AppTheme.lightTheme,
      home: const AuthWrapper(),
    );
  }
}
