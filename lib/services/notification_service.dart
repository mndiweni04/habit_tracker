import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings settings = InitializationSettings(android: androidSettings);
    await _notifications.initialize(settings);
    _initialized = true;
  }

  Future<void> scheduleDailyReminders(bool enabled) async {
    if (!enabled) {
      await _notifications.cancelAll();
      return;
    }

    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'habit_reminders',
      'Habit Reminders',
      importance: Importance.high,
      priority: Priority.high,
    );
    const NotificationDetails platformDetails = NotificationDetails(android: androidDetails);

    // Initial logic implemented for manual trigger testing. 
    // Implementation of timezone-specific scheduling requires integration of the 'timezone' package.
    await _notifications.show(
      0,
      'Habit Reminder',
      'Time to check your habits for the day.',
      platformDetails,
    );
  }
}