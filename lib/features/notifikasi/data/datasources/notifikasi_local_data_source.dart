import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/notifikasi_model.dart';

abstract class NotifikasiLocalDataSource {
  Future<void> showNotification(NotifikasiModel model);
  Future<void> saveNotificationStatus(bool isActive);

  Future<bool> getNotificationStatus();
  Future<void> clearNotificationStatus();
}

class NotifikasiLocalDataSourceImpl implements NotifikasiLocalDataSource {
  static const _notificationStatusKey = 'notification_status';

  final FlutterLocalNotificationsPlugin plugin;
  final SharedPreferences sharedPreferences;

  NotifikasiLocalDataSourceImpl(this.plugin, this.sharedPreferences);

  @override
  Future<void> showNotification(NotifikasiModel model) async {
    const androidDetails = AndroidNotificationDetails(
      'default_channel',
      'Default',
      importance: Importance.max,
      priority: Priority.high,
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    await plugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      model.title,
      model.body,
      notificationDetails,
    );
  }

  @override
  Future<void> saveNotificationStatus(bool isActive) async {
    await sharedPreferences.setBool(_notificationStatusKey, isActive);
  }

  @override
  Future<bool> getNotificationStatus() async {
    return sharedPreferences.getBool(_notificationStatusKey) ?? false;
  }

  @override
  Future<void> clearNotificationStatus() async {
    await sharedPreferences.remove(_notificationStatusKey);
  }
}
