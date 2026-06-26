import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:expense_tracker/l10n/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context)!;
    if (_step == 1) {
      final salary = double.tryParse(_salaryController.text.trim());
      if (salary == null || salary <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.validIncomeRequired)),
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
    final l10n = AppLocalizations.of(context)!;
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
                            : Text(_step < 2 ? l10n.continueBtn : l10n.finishSetup),
                      ),
                    ),
                    if (_step == 2) ...[
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed:
                            _isSaving ? null : () => _finish(skipBudgets: true),
                        child: Text(l10n.skipBudgetSetup),
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
    final l10n = AppLocalizations.of(context)!;
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
            l10n.onboardingWelcome(name),
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.onboardingTagline,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.sidiBlue.withValues(alpha: 0.7),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            l10n.onboardingIntro,
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
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.all(28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('💰', style: TextStyle(fontSize: 40)),
          const SizedBox(height: 16),
          Text(
            l10n.monthlyIncomeSetup,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.monthlyIncomeSetupHint,
            style: TextStyle(color: Colors.grey.shade600, height: 1.4),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: l10n.salary,
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
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.all(28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('🌱', style: TextStyle(fontSize: 40)),
          const SizedBox(height: 16),
          Text(
            l10n.savingsGoalSetup,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.savingsGoalSetupHint,
            style: TextStyle(color: Colors.grey.shade600, height: 1.4),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: l10n.monthlySavingsTarget,
              suffixText: 'DT',
              hintText: '0',
            ),
          ),
        ],
      ),
    );
  }
}
