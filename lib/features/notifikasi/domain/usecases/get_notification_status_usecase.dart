import 'package:student_app/features/notifikasi/domain/repositories/notifikasi_repository.dart';

class GetNotificationStatusUseCase {
  final NotifikasiRepository repository;

  GetNotificationStatusUseCase(this.repository);

  Future<bool> call() {
    return repository.getNotificationStatus();
  }
}
