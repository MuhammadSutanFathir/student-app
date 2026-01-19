import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../models/notifikasi_model.dart';

abstract class NotifikasiRemoteDataSource {
  Future<void> requestPermission();
  Stream<NotifikasiModel> listenNotification();
  Future<void> stopListening();
}

class NotifikasiRemoteDataSourceImpl
    implements NotifikasiRemoteDataSource {
  final FirebaseMessaging firebaseMessaging;
  StreamSubscription<RemoteMessage>? _subscription;

  NotifikasiRemoteDataSourceImpl(this.firebaseMessaging);

  @override
  Future<void> requestPermission() async {
    await firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  @override
  Stream<NotifikasiModel> listenNotification() {
    final controller = StreamController<NotifikasiModel>();

    _subscription =
        FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final data = {
        'title': message.notification?.title,
        'body': message.notification?.body,
      };

      controller.add(NotifikasiModel.fromFirebase(data));
    });

    return controller.stream;
  }

  @override
  Future<void> stopListening() async {
    await _subscription?.cancel();
    _subscription = null;
  }
}
