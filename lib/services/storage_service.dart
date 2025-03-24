import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import '../models/todo_model.dart';
import '../utils/app_logger.dart';
import '../utils/file_helper.dart';
import '../services/export_service.dart';
import '../services/permission_service.dart';

/// Service class for handling todo storage operations
class StorageService {
  static const String _csvFileName = 'todos.csv';
  static const String _csvHeader = 'id,title,description,createdAt,status';

  /// Get local file path for CSV
  Future<String> get _localFilePath async {
    return await FileHelper.getFilePath(_csvFileName);
  }

  /// Save todos to local CSV file
  Future<void> saveTodos(List<Todo> todos) async {
    try {
      final filePath = await _localFilePath;
      final StringBuffer buffer = StringBuffer();

      // Add header
      buffer.writeln(_csvHeader);

      // Add todos
      for (final todo in todos) {
        buffer.writeln(todo.toCsv());
      }

      await FileHelper.writeToFile(filePath, buffer.toString());
    } catch (e) {
      AppLogger.error('Failed to save todos', e);
      rethrow;
    }
  }

  /// Load todos from local CSV file
  Future<List<Todo>> loadTodos() async {
    try {
      final filePath = await _localFilePath;

      // Return empty list if file doesn't exist
      if (!await FileHelper.fileExists(filePath)) {
        return [];
      }

      final String? contents = await FileHelper.readFromFile(filePath);
      if (contents == null) {
        return [];
      }

      return _parseCsvContent(contents);
    } catch (e) {
      AppLogger.error('Failed to load todos', e);
      return [];
    }
  }

  /// Parse CSV content into Todo objects
  List<Todo> _parseCsvContent(String contents) {
    final List<String> lines = contents.split('\n');

    // Skip header line if present
    final startIndex =
        lines.isNotEmpty && lines[0].contains('id,title,description') ? 1 : 0;

    // Parse CSV rows to Todo objects
    return lines
        .skip(startIndex)
        .where((line) => line.isNotEmpty)
        .map((line) => Todo.fromCsv(line))
        .toList();
  }

  /// Create CSV content from todo list
  String _createCsvContent(List<Todo> todos) {
    final StringBuffer buffer = StringBuffer();
    buffer.writeln(_csvHeader);

    for (final todo in todos) {
      buffer.writeln(todo.toCsv());
    }

    return buffer.toString();
  }

  /// Export todos to CSV file
  Future<String> exportTodosToCSV(List<Todo> todos) async {
    try {
      final String csvContent = _createCsvContent(todos);
      final String fileName = FileHelper.generateUniqueFilename('csv');

      // Always use folder picker for all platforms
      return await ExportService.exportWithPicker(fileName, csvContent);
    } catch (e) {
      AppLogger.error('CSV export failed', e);
      return 'Export failed: ${e.toString()}';
    }
  }

  /// Export todos to JSON file
  Future<String> exportTodosToJSON(List<Todo> todos) async {
    try {
      // Convert todos to JSON
      final jsonData = todos.map((todo) => todo.toJson()).toList();
      final jsonString = json.encode(jsonData);
      final fileName = FileHelper.generateUniqueFilename('json');

      return await ExportService.exportWithPicker(fileName, jsonString);
    } catch (e) {
      AppLogger.error('JSON export failed', e);
      return 'Export failed: ${e.toString()}';
    }
  }

  /// Import todos from JSON file
  Future<List<Todo>> importTodosFromJson() async {
    try {
      // Request storage permission for Android devices
      if (Platform.isAndroid) {
        if (!await PermissionService.requestStoragePermission()) {
          return [];
        }
      }

      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result == null || result.files.isEmpty) {
        return [];
      }

      // Read file
      final filePath = result.files.single.path!;
      final String? contents = await FileHelper.readFromFile(filePath);
      if (contents == null) {
        return [];
      }

      final List<dynamic> jsonList = json.decode(contents);

      // Load existing todos
      final List<Todo> existingTodos = await loadTodos();
      final Set<String> existingIds =
          existingTodos.map((todo) => todo.id).toSet();

      // Convert JSON to Todo objects, filtering out duplicates by ID
      return jsonList
          .map<Todo>((json) => Todo.fromJson(json))
          .where((todo) => !existingIds.contains(todo.id))
          .toList();
    } catch (e) {
      AppLogger.error('JSON import failed', e);
      return [];
    }
  }

  /// Import todos from CSV file
  Future<List<Todo>> importTodosFromCsv() async {
    try {
      // Request storage permission for Android devices
      if (Platform.isAndroid) {
        if (!await PermissionService.requestStoragePermission()) {
          return [];
        }
      }

      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );

      if (result == null || result.files.isEmpty) {
        return [];
      }

      // Read file
      final filePath = result.files.single.path!;
      final String? contents = await FileHelper.readFromFile(filePath);
      if (contents == null) {
        return [];
      }

      final List<Todo> importedTodos = _parseCsvContent(contents);

      // Load existing todos
      final List<Todo> existingTodos = await loadTodos();
      final Set<String> existingIds =
          existingTodos.map((todo) => todo.id).toSet();

      // Filter out duplicates by ID
      return importedTodos
          .where((todo) => !existingIds.contains(todo.id))
          .toList();
    } catch (e) {
      AppLogger.error('CSV import failed', e);
      return [];
    }
  }
}
