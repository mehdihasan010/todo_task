import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../utils/app_logger.dart';

/// Helper class for common file operations
class FileHelper {
  /// Get the application documents directory
  static Future<Directory> getAppDirectory() async {
    return await getApplicationDocumentsDirectory();
  }

  /// Get the path for a file in the app directory
  static Future<String> getFilePath(String fileName) async {
    final directory = await getAppDirectory();
    return '${directory.path}/$fileName';
  }

  /// Check if a file exists
  static Future<bool> fileExists(String filePath) async {
    return await File(filePath).exists();
  }

  /// Write content to a file
  static Future<void> writeToFile(String filePath, String content) async {
    try {
      final file = File(filePath);
      await file.writeAsString(content, flush: true);
    } catch (e) {
      AppLogger.error('Failed to write to file: $filePath', e);
      rethrow;
    }
  }

  /// Read content from a file
  static Future<String?> readFromFile(String filePath) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        return null;
      }
      return await file.readAsString();
    } catch (e) {
      AppLogger.error('Failed to read from file: $filePath', e);
      return null;
    }
  }

  /// Generate a unique filename with timestamp
  static String generateUniqueFilename(String extension) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return 'todos_$timestamp.$extension';
  }
}
