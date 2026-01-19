import 'package:equatable/equatable.dart';
import '../../domain/entities/notifikasi_entity.dart';

abstract class NotifikasiEvent extends Equatable {
  const NotifikasiEvent();

  @override
  List<Object?> get props => [];
}

class InitNotificationEvent extends NotifikasiEvent {}

class StopListenNotificationEvent extends NotifikasiEvent {}

class ShowLocalNotificationEvent extends NotifikasiEvent {
  final NotifikasiEntity notification;

  const ShowLocalNotificationEvent(this.notification);

  @override
  List<Object?> get props => [notification];
}

class LoadNotificationStatusEvent extends NotifikasiEvent {}

class SaveNotificationStatusEvent extends NotifikasiEvent {
  final bool isActive;

  const SaveNotificationStatusEvent(this.isActive);

  @override
  List<Object?> get props => [isActive];
}

class LogoutEvent extends NotifikasiEvent {}
