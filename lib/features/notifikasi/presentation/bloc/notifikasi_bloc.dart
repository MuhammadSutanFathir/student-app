import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_app/features/notifikasi/domain/usecases/clear_notification_status_usecase.dart';
import 'package:student_app/features/notifikasi/domain/usecases/get_notification_status_usecase.dart';
import 'package:student_app/features/notifikasi/domain/usecases/save_notification_status_usecase.dart';
import 'notifikasi_event.dart';
import 'notifikasi_state.dart';
import '../../domain/usecases/listen_notification_usecase.dart';
import '../../domain/usecases/request_notification_permission_usecase.dart';
import '../../domain/usecases/show_local_notification_usecase.dart';
import '../../domain/usecases/stop_notification_usecase.dart';

class NotifikasiBloc extends Bloc<NotifikasiEvent, NotifikasiState> {
  final ListenNotificationUseCase listenUseCase;
  final RequestNotificationPermissionUseCase permissionUseCase;
  final ShowLocalNotificationUseCase showLocalUseCase;
  final StopNotificationUseCase stopUseCase;
  final GetNotificationStatusUseCase getStatusUseCase;
  final SaveNotificationStatusUseCase saveStatusUseCase;
  final ClearNotificationStatusUseCase clearNotificationStatusUseCase;

  StreamSubscription? _subscription;

  NotifikasiBloc({
    required this.listenUseCase,
    required this.permissionUseCase,
    required this.showLocalUseCase,
    required this.stopUseCase,
    required this.getStatusUseCase,
    required this.saveStatusUseCase,
    required this.clearNotificationStatusUseCase,
  }) : super(NotifikasiInitial()) {
    on<InitNotificationEvent>(_onInitNotification);
    on<StopListenNotificationEvent>(_onStopListening);
    on<ShowLocalNotificationEvent>(_onShowLocalNotification);
    on<LoadNotificationStatusEvent>(_onLoadStatus);
    on<SaveNotificationStatusEvent>(_onSaveStatus);
    on<LogoutEvent>((event, emit) async {
      await _subscription?.cancel();
      await stopUseCase();
      await clearNotificationStatusUseCase();

      emit(const NotifikasiStatusLoaded(false));
    });
  }

  Future<void> _onInitNotification(
    InitNotificationEvent event,
    Emitter<NotifikasiState> emit,
  ) async {
    try {
      await permissionUseCase();
      _subscription?.cancel();

      _subscription = listenUseCase().listen((notification) {
        add(ShowLocalNotificationEvent(notification));
      });
    } catch (e) {
      emit(NotifikasiError(e.toString()));
    }
  }

  Future<void> _onShowLocalNotification(
    ShowLocalNotificationEvent event,
    Emitter<NotifikasiState> emit,
  ) async {
    await showLocalUseCase(event.notification);
  }

  Future<void> _onStopListening(
    StopListenNotificationEvent event,
    Emitter<NotifikasiState> emit,
  ) async {
    await _subscription?.cancel();
    await stopUseCase();
  }

  Future<void> _onLoadStatus(
    LoadNotificationStatusEvent event,
    Emitter<NotifikasiState> emit,
  ) async {
    final isActive = await getStatusUseCase();
    emit(NotifikasiStatusLoaded(isActive));
    if (isActive) {
      add(InitNotificationEvent());
    }
  }

  Future<void> _onSaveStatus(
    SaveNotificationStatusEvent event,
    Emitter<NotifikasiState> emit,
  ) async {
    await saveStatusUseCase(event.isActive);

    emit(NotifikasiStatusLoaded(event.isActive));
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
