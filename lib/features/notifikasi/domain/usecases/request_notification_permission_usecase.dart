
import 'package:student_app/features/notifikasi/domain/repositories/notifikasi_repository.dart';

class RequestNotificationPermissionUseCase {
  final NotifikasiRepository repository;

  RequestNotificationPermissionUseCase(this.repository);

  Future<void> call() async {
    await repository.requestPermission();
  }
}
