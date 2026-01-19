import 'package:student_app/features/notifikasi/domain/entities/notifikasi_entity.dart';

import 'package:student_app/features/notifikasi/domain/repositories/notifikasi_repository.dart';

class ListenNotificationUseCase {
  final NotifikasiRepository repository;

  ListenNotificationUseCase(this.repository);

  Stream<NotifikasiEntity> call() {
    return repository.notificationStream();
  }
}
