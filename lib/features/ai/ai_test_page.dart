// import 'package:flutter/material.dart';
// import '../../services/ai_service.dart';
//
// class AITestPage extends StatefulWidget {
//   const AITestPage({super.key});
//
//   @override
//   State<AITestPage> createState() => _AITestPageState();
// }
//
// class _AITestPageState extends State<AITestPage> {
//   String result = '';
//   bool loading = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('AI Test'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           children: [
//             ElevatedButton(
//               onPressed: () async {
//                 setState(() {
//                   loading = true;
//                 });
//
//                 final advice = await AIService().generateAdvice(
//                   salary: 2000,
//                   expenses: 935,
//                   savingsGoal: 300,
//                 );
//
//                 setState(() {
//                   result = advice;
//                   loading = false;
//                 });
//               },
//               child: const Text('Generate Advice'),
//             ),
//
//             const SizedBox(height: 20),
//
//             if (loading)
//               const CircularProgressIndicator(),
//
//             const SizedBox(height: 20),
//
//             Expanded(
//               child: SingleChildScrollView(
//                 child: Text(result),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }