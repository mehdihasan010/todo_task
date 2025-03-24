import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';
import '../utils/app_logger.dart';

/// Service to handle permission requests
class PermissionService {
  /// Check and request storage permissions for Android
  static Future<bool> requestStoragePermission() async {
    if (!Platform.isAndroid) return true;

    // Request storage permission
    var status = await Permission.storage.request();
    if (!status.isGranted) {
      AppLogger.error('Storage permission denied');
      return false;
    }

    // On Android 10+, also request manage external storage permission
    if (defaultTargetPlatform == TargetPlatform.android) {
      try {
        var managedStorageStatus =
            await Permission.manageExternalStorage.request();
        if (!managedStorageStatus.isGranted) {
          AppLogger.log('Manage external storage permission not granted');
        }
      } catch (e) {
        // Some devices may not have this permission
        AppLogger.error('Error requesting manage external storage', e);
      }
    }

    return true;
  }
}
