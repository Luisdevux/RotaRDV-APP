// lib/core/constants/api_constants.dart

import 'package:flutter_dotenv/flutter_dotenv.dart';

// Classe para armazenar constantes relacionadas a API
class ApiConstants {
  static String get baseUrl {
    if (!dotenv.isInitialized) {
      return 'https://rotardv-api.luisfelipe.dpdns.org';
    }
    return dotenv.env['API_BASE_URL'] ?? 'https://rotardv-api.luisfelipe.dpdns.org';
  }
}
