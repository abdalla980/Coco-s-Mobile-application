import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Centralized configuration loader for environment variables
class EnvConfig {
  static bool _isInitialized = false;

  /// Load environment configuration from .env file
  /// Call this in main() before runApp()
  static Future<void> load() async {
    try {
      await dotenv.load(fileName: '.env');
      _isInitialized = true;
    } catch (e) {
      debugPrint('Warning: Failed to load .env file: $e');
    }
  }

  /// Safe getter that handles uninitialized dotenv
  static String _get(String key, {String fallback = ''}) {
    if (!_isInitialized) return fallback;
    return dotenv.get(key, fallback: fallback);
  }

  // ==================== Feature Flags ====================

  /// Enable real Instagram API (false = use mock)
  static bool get enableRealInstagram {
    return _get('ENABLE_REAL_INSTAGRAM_API', fallback: 'false').toLowerCase() ==
        'true';
  }

  /// Enable real Facebook API (false = use mock)
  static bool get enableRealFacebook {
    return _get('ENABLE_REAL_FACEBOOK_API', fallback: 'false').toLowerCase() ==
        'true';
  }

  /// Enable real AI caption generation (false = use mock)
  static bool get enableRealAICaptions {
    return _get('ENABLE_REAL_AI_CAPTIONS', fallback: 'false').toLowerCase() ==
        'true';
  }

  // ==================== API Credentials ====================

  /// Facebook App ID
  static String get facebookAppId {
    return _get('FACEBOOK_APP_ID', fallback: '');
  }

  /// Facebook App Secret (DO NOT expose to client-side code)
  static String get facebookAppSecret {
    return _get('FACEBOOK_APP_SECRET', fallback: '');
  }

  /// Instagram App ID
  static String get instagramAppId {
    return _get('INSTAGRAM_APP_ID', fallback: '');
  }

  /// Instagram App Secret (DO NOT expose to client-side code)
  static String get instagramAppSecret {
    return _get('INSTAGRAM_APP_SECRET', fallback: '');
  }

  /// Gemini API Key for AI caption generation
  static String get geminiApiKey {
    return _get('GEMINI_API_KEY', fallback: '');
  }

  // ==================== Validation ====================

  /// Check if all required configuration is present
  static bool get isConfigured {
    return facebookAppId.isNotEmpty && instagramAppId.isNotEmpty;
  }

  /// Get missing configuration keys
  static List<String> get missingKeys {
    final missing = <String>[];
    if (facebookAppId.isEmpty) missing.add('FACEBOOK_APP_ID');
    if (instagramAppId.isEmpty) missing.add('INSTAGRAM_APP_ID');
    return missing;
  }
}
