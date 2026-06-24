import 'dart:convert';
import 'package:http/http.dart' as http;

import '../utils/env_config.dart';

class AIService {
  String get _apiKey {
    if (!EnvConfig.hasGroqApiKey) {
      throw AIServiceException(
        'Groq API key is not configured. Copy .env.example to .env and set GROQ_API_KEY.',
      );
    }
    return EnvConfig.groqApiKey;
  }

  Future<String> sendMessage({
    required String conversationHistory,
    required String userMessage,
    required double salary,
    required double expenses,
    required double savingsGoal,
    required String recentTransactions,
  }) async {
    final response = await http.post(
      Uri.parse(
        'https://api.groq.com/openai/v1/chat/completions',
      ),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_apiKey',
      },
      body: jsonEncode({
        'model': 'llama-3.3-70b-versatile',
        'messages': [
          {
            'role': 'system',
            'content':
            '''
You are Flousi AI.

You are a smart personal finance assistant for students and young professionals.

Rules:
- Use Tunisian Dinars (DT).
- Give practical financial advice.
- Analyze spending habits.
- Help users reach savings goals.
- Keep answers concise and friendly.
- Use the financial data provided.
''',
          },
          {
            'role': 'user',
            'content': '''
Salary: $salary DT
Monthly Expenses: $expenses DT
Savings Goal: $savingsGoal DT
Remaining this month: ${salary - expenses} DT

Recent Transactions:
$recentTransactions

Conversation History:
$conversationHistory

Current User Question:
$userMessage
''',
          }
        ]
      }),
    );

    if (response.statusCode != 200) {
      throw AIServiceException(
        'AI request failed (${response.statusCode}). Check your API key and try again.',
      );
    }

    final data = jsonDecode(response.body);

    return data['choices'][0]['message']['content'];
  }

  Future<String> classifyCategory(String expenseTitle) async {
    final response = await http.post(
      Uri.parse(
        'https://api.groq.com/openai/v1/chat/completions',
      ),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_apiKey',
      },
      body: jsonEncode({
        'model': 'llama-3.3-70b-versatile',
        'messages': [
          {
            'role': 'system',
            'content':
            '''
You are a transaction categorization engine.
Given an expense title, classify it into EXACTLY one of these categories:
Rent, Bills, Food, Groceries, Transport, Entertainment, Healthcare, Education, Shopping, Savings, Other.

Do not reply with any explanation, introductory text, punctuation, or extra words. Output ONLY the exact category name.
''',
          },
          {
            'role': 'user',
            'content': expenseTitle,
          }
        ]
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['choices'][0]['message']['content'].toString().trim();
    } else {
      throw AIServiceException('Failed to classify category');
    }
  }
}
