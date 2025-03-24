import 'package:flutter/material.dart';
import '../models/todo_model.dart';

class TodoItem extends StatelessWidget {
  final Todo todo;
  final VoidCallback onDelete;
  final Function(String) onStatusChange;

  const TodoItem({
    super.key,
    required this.todo,
    required this.onDelete,
    required this.onStatusChange,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: InkWell(
        onTap: () => _showTodoDetails(context),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      todo.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                  const SizedBox(width: 8),
                  _buildStatusChip(context),
                ],
              ),
              if (todo.description.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  todo.description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 14,
                        color: colorScheme.onSurfaceVariant.withAlpha(179),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatDate(todo.createdAt),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant.withAlpha(179),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.edit_outlined,
                          color: colorScheme.primary,
                          size: 20,
                        ),
                        onPressed: () => _showStatusChangeDialog(context),
                        tooltip: 'Change Status',
                        visualDensity: VisualDensity.compact,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      const SizedBox(width: 16),
                      IconButton(
                        icon: Icon(
                          Icons.delete_outline,
                          color: colorScheme.error,
                          size: 20,
                        ),
                        onPressed: () => _showDeleteConfirmation(context),
                        tooltip: 'Delete',
                        visualDensity: VisualDensity.compact,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(BuildContext context) {
    Color chipColor;
    IconData statusIcon;

    switch (todo.status) {
      case 'ready':
        chipColor = Colors.blue;
        statusIcon = Icons.play_arrow_rounded;
        break;
      case 'pending':
        chipColor = Colors.orange;
        statusIcon = Icons.hourglass_empty;
        break;
      case 'completed':
        chipColor = Colors.green;
        statusIcon = Icons.check_circle_outline;
        break;
      default:
        chipColor = Colors.grey;
        statusIcon = Icons.circle_outlined;
    }

    return GestureDetector(
      onTap: () => _showStatusChangeDialog(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: chipColor.withAlpha(26),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: chipColor.withAlpha(128)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(statusIcon, size: 16, color: chipColor),
            const SizedBox(width: 4),
            Text(
              todo.status,
              style: TextStyle(
                color: chipColor,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showStatusChangeDialog(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Change Status'),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildStatusOption(
                  context,
                  'ready',
                  Colors.blue,
                  Icons.play_arrow_rounded,
                ),
                _buildStatusOption(
                  context,
                  'pending',
                  Colors.orange,
                  Icons.hourglass_empty,
                ),
                _buildStatusOption(
                  context,
                  'completed',
                  Colors.green,
                  Icons.check_circle_outline,
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
          ),
    );
  }

  void _showTodoDetails(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Task Details',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const Divider(),
                const SizedBox(height: 8),
                Text(
                  'Title',
                  style: TextStyle(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(todo.title, style: Theme.of(context).textTheme.bodyLarge),
                const SizedBox(height: 16),
                Text(
                  'Description',
                  style: TextStyle(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  todo.description.isEmpty
                      ? 'No description provided'
                      : todo.description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Text(
                      'Status: ',
                      style: TextStyle(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    _buildStatusChip(context),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Created on: ${_formatDateFull(todo.createdAt)}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _showStatusChangeDialog(context);
                      },
                      icon: const Icon(Icons.edit),
                      label: const Text('Change Status'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: colorScheme.onPrimaryContainer,
                        backgroundColor: colorScheme.primaryContainer,
                      ),
                    ),
                    OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _showDeleteConfirmation(context);
                      },
                      icon: Icon(Icons.delete, color: colorScheme.error),
                      label: Text(
                        'Delete',
                        style: TextStyle(color: colorScheme.error),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: colorScheme.error),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Task'),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            content: Text('Are you sure you want to delete "${todo.title}"?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: colorScheme.primary),
                ),
              ),
              TextButton(
                onPressed: () {
                  onDelete();
                  Navigator.pop(context);
                },
                child: Text(
                  'Delete',
                  style: TextStyle(color: colorScheme.error),
                ),
              ),
            ],
          ),
    );
  }

  Widget _buildStatusOption(
    BuildContext context,
    String status,
    Color color,
    IconData icon,
  ) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        status,
        style: TextStyle(
          fontWeight:
              todo.status == status ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      onTap: () {
        onStatusChange(status);
        Navigator.pop(context);
      },
      tileColor: todo.status == status ? color.withAlpha(26) : null,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }

  String _formatDate(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatDateFull(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return '${date.day}/${date.month}/${date.year} at ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
