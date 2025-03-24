import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/todo_controller.dart';

class TodoForm extends StatelessWidget {
  final Function(String title, String description, String status) onSubmit;

  const TodoForm({super.key, required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TodoController>();
    final colorScheme = Theme.of(context).colorScheme;

    void submitForm() {
      if (controller.validateForm()) {
        onSubmit(
          controller.titleController.text,
          controller.descriptionController.text,
          controller.status.value,
        );
        controller.clearForm();
        Navigator.of(context).pop();
      }
    }

    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.add_task, color: colorScheme.primary, size: 28),
          const SizedBox(width: 12),
          Text(
            'Add New Task',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: Form(
        key: controller.formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'What task would you like to add?',
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: controller.titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  hintText: 'Enter task title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.title),
                  filled: true,
                  fillColor: colorScheme.surfaceContainerHighest.withAlpha(26),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
                textInputAction: TextInputAction.next,
                autofocus: true,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: controller.descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  hintText: 'Enter task details',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.description),
                  filled: true,
                  fillColor: colorScheme.surfaceContainerHighest.withAlpha(26),
                ),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
              ),
              const SizedBox(height: 20),
              Text(
                'Task Status',
                style: TextStyle(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Obx(
                () => Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: colorScheme.outline.withAlpha(128),
                    ),
                  ),
                  child: Column(
                    children: [
                      _buildStatusRadioOption(
                        context,
                        controller,
                        'ready',
                        Colors.blue,
                        Icons.play_arrow_rounded,
                        'Ready to start',
                      ),
                      Divider(
                        height: 1,
                        color: colorScheme.outline.withAlpha(51),
                      ),
                      _buildStatusRadioOption(
                        context,
                        controller,
                        'pending',
                        Colors.orange,
                        Icons.hourglass_empty,
                        'In progress',
                      ),
                      Divider(
                        height: 1,
                        color: colorScheme.outline.withAlpha(51),
                      ),
                      _buildStatusRadioOption(
                        context,
                        controller,
                        'completed',
                        Colors.green,
                        Icons.check_circle_outline,
                        'Completed',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            controller.clearForm();
            Navigator.of(context).pop();
          },
          child: Text('Cancel', style: TextStyle(color: colorScheme.primary)),
        ),
        FilledButton.icon(
          onPressed: submitForm,
          icon: const Icon(Icons.add),
          label: const Text('Add Task'),
          style: FilledButton.styleFrom(
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
      actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }

  Widget _buildStatusRadioOption(
    BuildContext context,
    TodoController controller,
    String status,
    Color color,
    IconData icon,
    String label,
  ) {
    return Obx(
      () => InkWell(
        onTap: () => controller.updateStatus(status),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      status,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Radio<String>(
                value: status,
                groupValue: controller.status.value,
                onChanged: (value) => controller.updateStatus(value),
                activeColor: color,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
