import 'package:workmanager/workmanager.dart';
import 'notification_service.dart';

/// Background task handler - must be top-level function
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      print('Background task started: $task');
      
      // Check for new posts
      await NotificationService.checkForNewPosts();
      
      print('Background task completed successfully');
      return Future.value(true);
    } catch (e) {
      print('Background task error: $e');
      return Future.value(false);
    }
  });
}

class BackgroundTaskService {
  static const String _checkPostsTask = 'check_new_posts';

  /// Initialize background tasks
  static Future<void> initialize() async {
    await Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: false, // Set to true for debugging
    );
  }

  /// Register periodic task to check for new posts
  static Future<void> registerPeriodicCheck({
    Duration frequency = const Duration(minutes: 15),
  }) async {
    await Workmanager().registerPeriodicTask(
      _checkPostsTask,
      _checkPostsTask,
      frequency: frequency,
      initialDelay: const Duration(minutes: 1),
      constraints: Constraints(
        networkType: NetworkType.connected,
      ),
      existingWorkPolicy: ExistingPeriodicWorkPolicy.replace,
    );
    
    print('Periodic task registered: every ${frequency.inMinutes} minutes');
  }

  /// Cancel all background tasks
  static Future<void> cancelAll() async {
    await Workmanager().cancelAll();
    print('All background tasks cancelled');
  }

  /// Cancel specific task
  static Future<void> cancelPeriodicCheck() async {
    await Workmanager().cancelByUniqueName(_checkPostsTask);
    print('Periodic check task cancelled');
  }
}