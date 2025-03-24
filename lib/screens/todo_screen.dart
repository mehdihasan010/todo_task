import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/todo_controller.dart';
import '../widgets/todo_item.dart';
import '../widgets/todo_form.dart';
import '../widgets/app_snackbar.dart';

class TodoScreen extends StatelessWidget {
  const TodoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the TodoController instance
    final TodoController todoController = Get.find<TodoController>();
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 2,
        title: Text(
          'My Tasks',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: colorScheme.onPrimaryContainer,
          ),
        ),
        backgroundColor: colorScheme.primaryContainer,
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.file_upload_outlined),
            onPressed: () async {
              final result = await todoController.importTodos();
              if (context.mounted) {
                AppSnackbar.show(
                  message: result,
                  context: context,
                  isSuccess: result.contains('successfully'),
                );
              }
            },
            tooltip: 'Import todos from JSON',
          ),
          IconButton(
            icon: const Icon(Icons.file_download_outlined),
            onPressed: () {
              // Show export options dialog
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    title: const Text('Export Options'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: Icon(
                            Icons.description,
                            color: colorScheme.primary,
                          ),
                          title: const Text('Export as CSV'),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          onTap: () async {
                            Navigator.pop(context);
                            final result =
                                await todoController.exportTodosToCSV();
                            if (context.mounted) {
                              AppSnackbar.show(
                                message: result,
                                context: context,
                                isSuccess: result.contains('successfully'),
                                isError: result.contains('failed'),
                              );
                            }
                          },
                        ),
                        const SizedBox(height: 8),
                        ListTile(
                          leading: Icon(Icons.code, color: colorScheme.primary),
                          title: const Text('Export as JSON'),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          onTap: () async {
                            Navigator.pop(context);
                            final result =
                                await todoController.exportTodosToJSON();
                            if (context.mounted) {
                              AppSnackbar.show(
                                message: result,
                                context: context,
                                isSuccess: result.contains('successfully'),
                                isError: result.contains('failed'),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'Cancel',
                          style: TextStyle(color: colorScheme.primary),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
            tooltip: 'Export todos',
          ),
        ],
      ),
      body: Obx(() {
        if (todoController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (todoController.todos.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.task_alt,
                  size: 80,
                  color: colorScheme.primary.withAlpha(128),
                ),
                const SizedBox(height: 16),
                Text(
                  'No tasks yet',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onSurface.withAlpha(179),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tap the + button to add a new task',
                  style: TextStyle(color: colorScheme.onSurfaceVariant),
                ),
              ],
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          child: AnimatedList(
            initialItemCount: todoController.todos.length,
            itemBuilder: (context, index, animation) {
              final todo = todoController.todos[index];
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1, 0),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutQuint,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: TodoItem(
                    todo: todo,
                    onDelete: () => todoController.deleteTodo(todo.id),
                    onStatusChange:
                        (newStatus) =>
                            todoController.updateTodoStatus(todo.id, newStatus),
                  ),
                ),
              );
            },
          ),
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showDialog(
            context: context,
            builder:
                (context) => TodoForm(
                  onSubmit:
                      (title, description, status) =>
                          todoController.addTodo(title, description, status),
                ),
          );
        },
        tooltip: 'Add Task',
        icon: const Icon(Icons.add),
        label: const Text('New Task'),
        elevation: 4,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
