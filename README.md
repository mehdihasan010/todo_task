# Todo App

A Flutter-based Todo application that allows users to manage their tasks efficiently. The app provides basic CRUD (Create, Read, Update, Delete) operations and stores todos in a CSV file on the device's local storage with JSON import/export capabilities.

## Features

- **Create, Read, Update, and Delete Todos**: Manage tasks with a user-friendly interface
- **Local Storage**: Todos are stored in a CSV file on the device's local storage
- **JSON Import/Export**: Import todos from JSON files and export your current todos to JSON
- **Status Management**: Track todo status as 'ready', 'pending', or 'completed'
- **State Management**: Uses GetX for efficient state management

## Architecture

The app follows a clean architecture approach with the following structure:

- **Models**: Contains the Todo data model with CSV and JSON conversion capabilities
- **Services**:
  - StorageService: Handles reading/writing to CSV and JSON import/export
  - PermissionService: Manages file access permissions
  - ExportService: Handles exporting todos to JSON files
- **Controllers**: Implements GetX controllers for state management
- **Screens**: Contains the main TodoScreen that displays and manages todos
- **Widgets**: Includes reusable components like TodoItem and input forms
- **Utils**: Helper functions and utilities

## Technical Details

1. **CSV Storage**: Todos are stored in a CSV file in the app's documents directory
2. **File Selection**: Uses the file_picker package to select JSON files for import/export
3. **UUID Generation**: Generates unique IDs for each todo using the uuid package
4. **GetX State Management**: Efficiently manages application state with GetX
5. **Material Design**: Implements Flutter Material Design for a modern UI experience
6. **Permissions Handling**: Uses permission_handler to manage storage permissions

## Dependencies

- **path_provider**: ^2.1.5 - For accessing the device's file system and document directory
- **file_picker**: ^9.2.1 - To enable picking JSON files from the device
- **uuid**: ^4.5.1 - For generating unique IDs for todos
- **permission_handler**: ^11.4.0 - To manage file system permissions
- **get**: ^4.6.6 - For state management

## How to Use

1. **Add a Todo**: Tap the floating action button (+ button) to add a new todo. Fill out the form with title, description, and status
2. **Update a Todo**: Tap on a todo to edit its details
3. **Delete a Todo**: Tap the delete (trash) icon on a todo card to remove it
4. **Import Todos**: Use the import option to select and import todos from a JSON file
5. **Export Todos**: Use the export option to save your todos as a JSON file

## JSON Format

The JSON import/export uses the following structure:

```json
[
  {
    "id": "some-unique-id",
    "title": "Todo Title",
    "description": "Todo Description",
    "createdAt": 1616976000000,
    "status": "pending"
  }
]
```

## Installation

1. Clone the repository
2. Run `flutter pub get` to install dependencies
3. Run `flutter run` to launch the app

## Requirements

- Flutter SDK: ^3.7.0
- Dart SDK: ^3.7.0

## License

This project is licensed under the MIT License.
