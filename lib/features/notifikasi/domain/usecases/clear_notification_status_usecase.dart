import 'package:student_app/features/notifikasi/domain/repositories/notifikasi_repository.dart';

class ClearNotificationStatusUseCase {
  final NotifikasiRepository repository;

  ClearNotificationStatusUseCase(this.repository);

  Future<void> call() {
    return repository.clearNotificationStatus();
  }
}
