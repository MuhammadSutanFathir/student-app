import 'package:student_app/features/notifikasi/domain/repositories/notifikasi_repository.dart';

class StopNotificationUseCase {
  final NotifikasiRepository repository;

  StopNotificationUseCase(this.repository);

  Future<void> call() async {
    await repository.stopListening();
  }
}
