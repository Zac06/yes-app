import 'package:flutter/material.dart';
import 'services/notification_service.dart';
import 'services/background_task_service.dart';
import 'layout/app_shell.dart';
import 'params/appcolors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize notification service
  await NotificationService.initialize();
  await NotificationService.requestPermissions();

  // Initialize background tasks
  await BackgroundTaskService.initialize();
  await BackgroundTaskService.registerPeriodicCheck(
    frequency: const Duration(minutes: 15), // Android minimum is 15 minutes
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YES-App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromRGBO(0x20, 0x2f, 0x5b, 1.0),
        ),
        fontFamily: 'MontSerrat',
        appBarTheme: const AppBarTheme(toolbarHeight: 72, centerTitle: true),
        snackBarTheme: const SnackBarThemeData(
          backgroundColor: AppColors.primary,
        ),
      ),
      home: const AppShell(title: 'App'),
    );
  }
}

