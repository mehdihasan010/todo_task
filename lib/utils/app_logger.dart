import 'package:flutter/foundation.dart';

/// Helper class for logging messages
class AppLogger {
  static void log(String message) {
    if (kDebugMode) {
      print('[TodoApp] $message');
    }
  }

  static void error(String message, [dynamic error]) {
    if (kDebugMode) {
      print('[TodoApp ERROR] $message');
      if (error != null) {
        print('Error details: $error');
      }
    }
  }
}
