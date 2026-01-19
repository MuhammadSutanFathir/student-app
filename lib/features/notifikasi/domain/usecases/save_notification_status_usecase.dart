import 'package:student_app/features/notifikasi/domain/repositories/notifikasi_repository.dart';

class SaveNotificationStatusUseCase {
  final NotifikasiRepository repository;

  SaveNotificationStatusUseCase(this.repository);

  Future<void> call(bool isActive) {
    return repository.saveNotificationStatus(isActive);
  }
}
