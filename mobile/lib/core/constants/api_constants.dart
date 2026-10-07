import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  static String get baseUrl {
    // 1. Check if defined in .env
    final envUrl = dotenv.env['API_BASE_URL'];
    if (envUrl != null && envUrl.isNotEmpty) {
      return envUrl;
    }

    // 2. Platform default fallback
    if (kIsWeb) {
      return 'http://localhost:8081';
    } else if (Platform.isAndroid) {
      // For Android Emulator: 10.0.2.2. If physical device, set API_BASE_URL in .env
      return 'http://10.0.2.2:8081';
    } else {
      return 'http://localhost:8081';
    }
  }

  // Auth endpoints
  static const String register = '/api/auth/register';
  static const String login = '/api/auth/login';
  static const String me = '/api/auth/me';

  // Catalog endpoints
  static const String projects = '/api/projects';
  static const String services = '/api/services';
  static const String materials = '/api/materials';
  static const String styles = '/api/styles';

  // Transformation endpoints
  static const String transformations = '/api/transformations';

  // Quotes
  static const String quotes = '/api/quotes';

  // Favorites
  static const String favorites = '/api/favorites';

  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 90);
}
