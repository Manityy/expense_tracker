import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:expense_tracker/l10n/app_localizations.dart';

import '../../services/firestore_service.dart';

class SalarySetupPage extends StatefulWidget {
  const SalarySetupPage({super.key});

  @override
  State<SalarySetupPage> createState() => _SalarySetupPageState();
}

class _SalarySetupPageState extends State<SalarySetupPage> {
  final salaryController = TextEditingController();
  final firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.setYourSalary),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: salaryController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: l10n.monthlyIncome,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    await firestoreService.updateSalary(
                      FirebaseAuth.instance.currentUser!.uid,
                      double.parse(salaryController.text),
                    );

                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.salarySaved)),
                      );
                      Navigator.pop(context);
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(e.toString())),
                      );
                    }
                  }
                },
                child: Text(l10n.saveSalary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
