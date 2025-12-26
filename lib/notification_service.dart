import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'yes_api.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static const String _lastPostIdKey = 'last_post_id';
  static bool _initialized = false;

  /// Initialize notification service
  static Future<void> initialize() async {
    if (_initialized) return;

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    final linuxSettings = LinuxInitializationSettings(
      defaultActionName: 'Open notification',
      defaultIcon: AssetsLinuxIcon('assets/icons/icon.png')
    );

    const windowsSettings = WindowsInitializationSettings(appName: 'YES-App', appUserModelId: 'it.zac06.yessite_app', guid: '{B1A5F7FC-3A0A-4F89-9EB7-A5A3B01DAD0A}',);

    final initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
      linux: linuxSettings,
      windows: windowsSettings
    );

    await _notifications.initialize(initSettings);
    _initialized = true;
  }

  /// Request notification permissions (especially important for iOS/Android 13+)
  static Future<bool> requestPermissions() async {
    await initialize();
    
    final android = _notifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    
    if (android != null) {
      await android.requestNotificationsPermission();
    }

    final ios = _notifications
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
    
    if (ios != null) {
      await ios.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    }

    return true;
  }

  /// Get the last checked post ID
  static Future<int?> getLastPostId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_lastPostIdKey);
  }

  /// Save the last checked post ID
  static Future<void> saveLastPostId(int postId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_lastPostIdKey, postId);
  }

  /// Check for new posts and show notification if found
  static Future<void> checkForNewPosts() async {
    try {
      await initialize();

      // Fetch the latest posts
      final posts = await YESApi.fetchPosts(page: 1, perPage: 5);
      if (posts.isEmpty) return;

      final latestPost = posts.first;
      final lastSeenId = await getLastPostId();

      // If this is first run, just save the ID without notifying
      if (lastSeenId == null) {
        await saveLastPostId(latestPost.id);
        return;
      }

      // Check if there are new posts
      if (latestPost.id > lastSeenId) {
        // Count how many new posts
        final newPosts = posts.where((p) => p.id > lastSeenId).toList();
        
        if (newPosts.length == 1) {
          // Show notification for single new post
          await _showNotification(
            title: 'New Post Available',
            body: latestPost.title,
            payload: latestPost.id.toString(),
          );
        } else {
          // Show notification for multiple new posts
          await _showNotification(
            title: 'New Posts Available',
            body: '${newPosts.length} new posts to read',
            payload: latestPost.id.toString(),
          );
        }

        // Update last seen ID
        await saveLastPostId(latestPost.id);
      }
    } catch (e) {
      print('Error checking for new posts: $e');
    }
  }

  /// Show a notification
  static Future<void> _showNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'new_posts_channel',
      'New Posts',
      channelDescription: 'Notifications for new posts',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const linuxDetails=LinuxNotificationDetails(
      urgency: LinuxNotificationUrgency.normal,
      category: LinuxNotificationCategory.email,
    );

    const windowsDetails=WindowsNotificationDetails(
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
      linux: linuxDetails,
      windows: windowsDetails
    );

    await _notifications.show(
      0, // notification id
      title,
      body,
      details,
      payload: payload,
    );
  }

  /// Manual check (for testing or pull-to-refresh)
  static Future<bool> manualCheck() async {
    await checkForNewPosts();
    return true;
  }
}