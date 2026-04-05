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
    // Logic for scheduling at the 3 specific intervals (8 AM, 1 PM, 8 PM)
    // requires the 'timezone' package as per industry best practices.
  }
}