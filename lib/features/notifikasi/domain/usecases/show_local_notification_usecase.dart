import 'package:student_app/features/notifikasi/domain/entities/notifikasi_entity.dart';

import 'package:student_app/features/notifikasi/domain/repositories/notifikasi_repository.dart';

class ShowLocalNotificationUseCase {
  final NotifikasiRepository repository;

  ShowLocalNotificationUseCase(this.repository);

  Future<void> call(NotifikasiEntity notification) async {
    await repository.showLocalNotification(notification);
  }
}
