import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    
    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    
    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    
    await _notifications.initialize(settings);
    _initialized = true;
  }

  Future<void> scheduleDailyReminders(bool enabled) async {
    if (!enabled) {
      await _notifications.cancelAll();
      return;
    }
    
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'habit_reminders_channel',
      'Habit Reminders',
      channelDescription: 'Notifications to remind you of your daily habits',
      importance: Importance.max,
      priority: Priority.high,
    );
    
    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
    );
    
    await _notifications.show(
      0,
      'Habit Reminder',
      'Check your schedule and complete your tasks today!',
      details,
    );
  }
}