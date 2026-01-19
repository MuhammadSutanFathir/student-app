import 'package:equatable/equatable.dart';
import '../../domain/entities/notifikasi_entity.dart';

abstract class NotifikasiState extends Equatable {
  const NotifikasiState();

  @override
  List<Object?> get props => [];
}

class NotifikasiInitial extends NotifikasiState {}

class NotifikasiPermissionGranted extends NotifikasiState {}

class NotifikasiListening extends NotifikasiState {}

class NotifikasiReceived extends NotifikasiState {
  final NotifikasiEntity notification;

  const NotifikasiReceived(this.notification);

  @override
  List<Object?> get props => [notification];
}

class NotifikasiStopped extends NotifikasiState {}

class NotifikasiError extends NotifikasiState {
  final String message;

  const NotifikasiError(this.message);

  @override
  List<Object?> get props => [message];
}

class NotifikasiStatusLoaded extends NotifikasiState {
  final bool isActive;

  const NotifikasiStatusLoaded(this.isActive);

  @override
  List<Object?> get props => [isActive];
}
