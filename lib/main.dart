import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'screens/todo_screen.dart';
import 'controllers/todo_controller.dart';
import 'services/permission_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Request storage permissions on app start (Android only)
  if (Platform.isAndroid) {
    await PermissionService.requestStoragePermission();
  }

  // Initialize GetX controllers
  Get.put(TodoController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Task Master',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF3F51B5), // Indigo
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        appBarTheme: const AppBarTheme(centerTitle: false, elevation: 0),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontWeight: FontWeight.bold),
          titleMedium: TextStyle(fontWeight: FontWeight.w600),
          bodyLarge: TextStyle(fontSize: 16),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          floatingLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
          isDense: true,
          contentPadding: const EdgeInsets.all(16),
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF3F51B5), // Indigo
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        cardTheme: CardTheme(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        appBarTheme: const AppBarTheme(centerTitle: false, elevation: 0),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontWeight: FontWeight.bold),
          titleMedium: TextStyle(fontWeight: FontWeight.w600),
          bodyLarge: TextStyle(fontSize: 16),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          floatingLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
          isDense: true,
          contentPadding: const EdgeInsets.all(16),
        ),
      ),
      themeMode: ThemeMode.system,
      home: const TodoScreen(),
    );
  }
}
