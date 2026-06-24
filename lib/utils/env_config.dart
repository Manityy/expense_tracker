import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  static bool _loaded = false;

  static Future<void> load() async {
    if (_loaded) return;

    const fromDefine = String.fromEnvironment('GROQ_API_KEY');
    if (fromDefine.isNotEmpty) {
      _loaded = true;
      return;
    }

    try {
      await dotenv.load(fileName: '.env');
    } catch (_) {
      // .env is gitignored — copy .env.example to .env before running locally.
    }

    _loaded = true;
  }

  static String get groqApiKey {
    const fromDefine = String.fromEnvironment('GROQ_API_KEY');
    if (fromDefine.isNotEmpty) return fromDefine;

    return dotenv.env['GROQ_API_KEY']?.trim() ?? '';
  }

  static bool get hasGroqApiKey {
    final key = groqApiKey;
    return key.isNotEmpty && key != 'your_groq_api_key_here';
  }
}

class AIServiceException implements Exception {
  final String message;

  AIServiceException(this.message);

  @override
  String toString() => message;
}
