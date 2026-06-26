import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/firestore_service.dart';
import '../../utils/app_colors.dart';
import '../../widgets/tunisian_motif.dart';
import '../navigation/main_navigation_page.dart';
import '../profile/category_budgets_page.dart';

class OnboardingPage extends StatefulWidget {
  final String userName;

  const OnboardingPage({super.key, required this.userName});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _pageController = PageController();
  final _salaryController = TextEditingController();
  final _savingsController = TextEditingController();
  final _firestore = FirestoreService();
  int _step = 0;
  bool _isSaving = false;

  @override
  void dispose() {
    _pageController.dispose();
    _salaryController.dispose();
    _savingsController.dispose();
    super.dispose();
  }

  Future<void> _finish({bool skipBudgets = false}) async {
    final salary = double.tryParse(_salaryController.text.trim()) ?? 0;
    final savings = double.tryParse(_savingsController.text.trim()) ?? 0;
    final uid = FirebaseAuth.instance.currentUser!.uid;

    setState(() => _isSaving = true);
    try {
      await _firestore.completeOnboarding(
        uid: uid,
        salary: salary,
        savingsGoal: savings,
      );
      if (!mounted) return;
      if (!skipBudgets) {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CategoryBudgetsPage()),
        );
      }
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const MainNavigationPage()),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _next() {
    if (_step == 1) {
      final salary = double.tryParse(_salaryController.text.trim());
      if (salary == null || salary <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a valid monthly income')),
        );
        return;
      }
    }
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
    setState(() => _step++);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: TunisianMotifBackground(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Row(
                  children: List.generate(3, (i) {
                    return Expanded(
                      child: Container(
                        height: 4,
                        margin: EdgeInsets.only(right: i < 2 ? 8 : 0),
                        decoration: BoxDecoration(
                          color: i <= _step
                              ? AppColors.sidiBlue
                              : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (i) => setState(() => _step = i),
                  children: [
                    _WelcomeStep(name: widget.userName),
                    _SalaryStep(controller: _salaryController),
                    _SavingsStep(controller: _savingsController),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: FilledButton(
                        onPressed: _isSaving
                            ? null
                            : () {
                                if (_step < 2) {
                                  _next();
                                } else {
                                  _finish();
                                }
                              },
                        child: _isSaving
                            ? const CircularProgressIndicator(strokeWidth: 2)
                            : Text(_step < 2 ? 'Continue' : 'Finish setup'),
                      ),
                    ),
                    if (_step == 2) ...[
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed:
                            _isSaving ? null : () => _finish(skipBudgets: true),
                        child: const Text('Skip budget setup for now'),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WelcomeStep extends StatelessWidget {
  final String name;

  const _WelcomeStep({required this.name});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.saffron,
                  AppColors.mediterranean.withValues(alpha: 0.85),
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.waving_hand, size: 48),
          ),
          const SizedBox(height: 28),
          Text(
            'Ahlan fi Flousi, $name!',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'فلوسي — barra flousk',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.sidiBlue.withValues(alpha: 0.7),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Let\'s set up your profile in 3 quick steps so your dashboard, budgets, and AI insights work correctly.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade600, height: 1.5, fontSize: 15),
          ),
        ],
      ),
    );
  }
}

class _SalaryStep extends StatelessWidget {
  final TextEditingController controller;

  const _SalaryStep({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('💰', style: TextStyle(fontSize: 40)),
          const SizedBox(height: 16),
          const Text(
            'Monthly income',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'This helps Flousi calculate how much you have left each month.',
            style: TextStyle(color: Colors.grey.shade600, height: 1.4),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Salary',
              suffixText: 'DT',
            ),
          ),
        ],
      ),
    );
  }
}

class _SavingsStep extends StatelessWidget {
  final TextEditingController controller;

  const _SavingsStep({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('🌱', style: TextStyle(fontSize: 40)),
          const SizedBox(height: 16),
          const Text(
            'Savings goal',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Optional — set a target to track progress on your home screen.',
            style: TextStyle(color: Colors.grey.shade600, height: 1.4),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Monthly savings target',
              suffixText: 'DT',
              hintText: '0',
            ),
          ),
        ],
      ),
    );
  }
}
