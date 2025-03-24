import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import '../models/todo_model.dart';
import '../services/storage_service.dart';

class TodoController extends GetxController {
  final StorageService _storageService = StorageService();
  final RxList<Todo> todos = <Todo>[].obs;
  final RxBool isLoading = true.obs;

  // TodoForm related properties
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final status = 'pending'.obs;
  final List<String> statusOptions = ['ready', 'pending', 'completed'];
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    loadTodos();
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    super.onClose();
  }

  void updateStatus(String? value) {
    if (value != null) {
      status.value = value;
    }
  }

  bool validateForm() {
    return formKey.currentState!.validate();
  }

  void clearForm() {
    titleController.clear();
    descriptionController.clear();
    status.value = 'pending';
  }

  // Load todos from storage
  Future<void> loadTodos() async {
    isLoading.value = true;
    final loadedTodos = await _storageService.loadTodos();
    todos.value = loadedTodos;
    isLoading.value = false;
  }

  // Save todos to storage
  Future<void> saveTodos() async {
    await _storageService.saveTodos(todos);
  }

  // Add new todo
  void addTodo(String title, String description, String status) {
    final newTodo = Todo(
      id: const Uuid().v4(),
      title: title,
      description: description,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      status: status,
    );

    todos.add(newTodo);
    saveTodos();
  }

  // Delete todo
  void deleteTodo(String id) {
    todos.removeWhere((todo) => todo.id == id);
    saveTodos();
  }

  // Update todo status
  void updateTodoStatus(String id, String newStatus) {
    final todoIndex = todos.indexWhere((todo) => todo.id == id);
    if (todoIndex != -1) {
      todos[todoIndex].status = newStatus;
      todos.refresh(); // Notify observers about the change
      saveTodos();
    }
  }

  // Export todos to CSV
  Future<String> exportTodosToCSV() async {
    return await _storageService.exportTodosToCSV(todos);
  }

  // Export todos to JSON
  Future<String> exportTodosToJSON() async {
    return await _storageService.exportTodosToJSON(todos);
  }

  // Import todos from JSON
  Future<String> importTodos() async {
    final importedTodos = await _storageService.importTodosFromJson();

    if (importedTodos.isNotEmpty) {
      todos.addAll(importedTodos);
      saveTodos();
      return '${importedTodos.length} todos imported successfully';
    }
    return 'No new todos to import';
  }
}
