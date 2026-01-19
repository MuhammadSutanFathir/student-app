import 'package:student_app/features/notifikasi/domain/entities/notifikasi_entity.dart';

abstract class NotifikasiRepository {
  Future<void> requestPermission();

  Stream<NotifikasiEntity> notificationStream();

  Future<void> stopListening();

  Future<void> showLocalNotification(NotifikasiEntity notification);

  Future<void> saveNotificationStatus(bool isActive);

  Future<bool> getNotificationStatus();
  Future<void> clearNotificationStatus();
}
