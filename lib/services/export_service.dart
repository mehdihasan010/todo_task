import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../utils/app_logger.dart';
import '../utils/file_helper.dart';
import '../services/permission_service.dart';

/// Service for exporting files
class ExportService {
  /// Export file using FilePicker to let user choose directory
  static Future<String> exportWithPicker(
    String fileName,
    String content,
  ) async {
    try {
      // Request storage permission for Android devices
      if (Platform.isAndroid) {
        if (!await PermissionService.requestStoragePermission()) {
          return 'Permission denied to write files';
        }
      }

      String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

      if (selectedDirectory == null) {
        return 'No directory selected';
      }

      final filePath = '$selectedDirectory/$fileName';
      await FileHelper.writeToFile(filePath, content);
      return 'File exported successfully to $filePath';
    } catch (e) {
      AppLogger.error('Export with picker failed', e);
      return 'Export failed: ${e.toString()}';
    }
  }

  /// Export file on Android platform
  static Future<String?> exportOnAndroid(
    String fileName,
    String content,
  ) async {
    try {
      // Request necessary permissions
      if (!await PermissionService.requestStoragePermission()) {
        return 'Permission denied to write files';
      }

      // Try multiple methods to find a suitable export location

      // Method 1: Using Download directory through storage API
      final downloadDir = await _getDownloadsDirectory();
      if (downloadDir != null) {
        final filePath = '${downloadDir.path}/$fileName';
        await FileHelper.writeToFile(filePath, content);
        return 'File exported successfully to $filePath';
      }

      // Method 2: Using direct path to Downloads (older Android versions)
      try {
        final downloadsPath = '/storage/emulated/0/Download';
        final filePath = '$downloadsPath/$fileName';
        await FileHelper.writeToFile(filePath, content);
        return 'File exported successfully to $filePath';
      } catch (directPathError) {
        AppLogger.error('Direct path export failed', directPathError);
      }

      // Method 3: Using app's documents directory as fallback
      final docsDir = await getApplicationDocumentsDirectory();
      final filePath = '${docsDir.path}/$fileName';
      await FileHelper.writeToFile(filePath, content);
      return 'File exported successfully to app folder: $filePath';
    } catch (e) {
      AppLogger.error('Android export error', e);
      return null; // Return null to fall back to FilePicker method
    }
  }

  /// Get the Downloads directory
  static Future<Directory?> _getDownloadsDirectory() async {
    if (!Platform.isAndroid) return null;

    try {
      final List<Directory>? externalDirs =
          await getExternalStorageDirectories();
      if (externalDirs == null || externalDirs.isEmpty) return null;

      // Find the Downloads directory by parsing the path
      for (final dir in externalDirs) {
        final downloadsDir = Directory('${dir.path}/Download');

        // Return if it exists
        if (await downloadsDir.exists()) {
          return downloadsDir;
        }

        // Try to create it if it doesn't exist
        try {
          return await downloadsDir.create(recursive: true);
        } catch (e) {
          AppLogger.error('Could not create Downloads directory', e);
        }
      }

      // Return the first external directory as fallback
      return externalDirs.first;
    } catch (e) {
      AppLogger.error('Error accessing external storage', e);
      return null;
    }
  }
}
