import 'package:flutter/material.dart';

/// A utility class for showing consistent snackbar messages throughout the app
class AppSnackbar {
  /// Shows a snackbar message in the given context
  ///
  /// [message] - The message to display
  /// [context] - The build context
  /// [duration] - How long to show the message (default: 3 seconds)
  /// [isError] - Whether this is an error message (shows in red)
  /// [isSuccess] - Whether this is a success message (shows in green)
  static void show({
    required String message,
    required BuildContext context,
    Duration? duration,
    bool isError = false,
    bool isSuccess = false,
    VoidCallback? onAction,
    String? actionLabel,
  }) {
    if (message.isEmpty) return;

    final colorScheme = Theme.of(context).colorScheme;

    // Determine the styling based on the message type
    Color backgroundColor = colorScheme.surfaceContainerHighest;
    Color textColor = colorScheme.onSurfaceVariant;
    IconData icon = Icons.info_outline;

    if (isError) {
      backgroundColor = colorScheme.errorContainer;
      textColor = colorScheme.onErrorContainer;
      icon = Icons.error_outline;
    } else if (isSuccess) {
      backgroundColor = colorScheme.primaryContainer;
      textColor = colorScheme.onPrimaryContainer;
      icon = Icons.check_circle_outline;
    }

    // Create the snackbar
    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(icon, color: textColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      duration: duration ?? const Duration(seconds: 4),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      backgroundColor: backgroundColor,
      elevation: 3,
      dismissDirection: DismissDirection.horizontal,
      action:
          actionLabel != null && onAction != null
              ? SnackBarAction(
                label: actionLabel,
                textColor:
                    isError
                        ? colorScheme.error
                        : isSuccess
                        ? colorScheme.primary
                        : colorScheme.primary,
                onPressed: onAction,
              )
              : null,
    );

    // Show the snackbar
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  /// Shows an error snackbar
  static void showError({
    required String message,
    required BuildContext context,
    Duration? duration,
    VoidCallback? onAction,
    String? actionLabel,
  }) {
    show(
      message: message,
      context: context,
      duration: duration,
      isError: true,
      onAction: onAction,
      actionLabel: actionLabel,
    );
  }

  /// Shows a success snackbar
  static void showSuccess({
    required String message,
    required BuildContext context,
    Duration? duration,
    VoidCallback? onAction,
    String? actionLabel,
  }) {
    show(
      message: message,
      context: context,
      duration: duration,
      isSuccess: true,
      onAction: onAction,
      actionLabel: actionLabel,
    );
  }

  /// Shows an info snackbar
  static void showInfo({
    required String message,
    required BuildContext context,
    Duration? duration,
    VoidCallback? onAction,
    String? actionLabel,
  }) {
    show(
      message: message,
      context: context,
      duration: duration,
      onAction: onAction,
      actionLabel: actionLabel,
    );
  }
}
