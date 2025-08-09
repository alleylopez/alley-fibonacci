import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

String get apiPath {
  // Use the compile-time variable if available (for production).
  const fromEnv = String.fromEnvironment('API_PATH');
  if (fromEnv.isNotEmpty) {
    return fromEnv;
  }
  // Fallback to dotenv for local development.
  return dotenv.env['API_PATH'] ?? '';
}
