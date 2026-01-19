import '../../domain/entities/notifikasi_entity.dart';
import '../../domain/repositories/notifikasi_repository.dart';
import '../datasources/notifikasi_local_data_source.dart';
import '../datasources/notifikasi_remote_data_source.dart';
import '../models/notifikasi_model.dart';

class NotifikasiRepositoryImplementation implements NotifikasiRepository {
  final NotifikasiRemoteDataSource remoteDataSource;
  final NotifikasiLocalDataSource localDataSource;

  NotifikasiRepositoryImplementation({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<void> requestPermission() async {
    await remoteDataSource.requestPermission();
  }

  @override
  Stream<NotifikasiEntity> notificationStream() {
    return remoteDataSource.listenNotification().map((NotifikasiModel model) {
      return model.toEntity(isActive: true);
    });
  }

  @override
  Future<void> stopListening() async {
    await remoteDataSource.stopListening();
  }

  @override
  Future<void> showLocalNotification(NotifikasiEntity notification) async {
    final model = NotifikasiModel(
      title: notification.title,
      body: notification.body,
    );

    await localDataSource.showNotification(model);
  }

  @override
  Future<void> saveNotificationStatus(bool isActive) async {
    await localDataSource.saveNotificationStatus(isActive);
  }

  @override
  Future<bool> getNotificationStatus() async {
    return localDataSource.getNotificationStatus();
  }

  @override
  Future<void> clearNotificationStatus() async {
    await localDataSource.clearNotificationStatus();
  }
}
