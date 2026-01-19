import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_app/core/network/network_info_impl.dart';
import 'package:student_app/features/login/data/datasources/local_datasource.dart';
import 'package:student_app/features/login/data/datasources/offline_datasource.dart';
import 'package:student_app/features/login/data/datasources/remote_datasource.dart';
import 'package:student_app/features/login/data/repositories/login_repository_implementation.dart';
import 'package:student_app/features/login/domain/repositories/login_repository.dart';
import 'package:student_app/features/login/domain/usecases/check_login.dart';
import 'package:student_app/features/login/domain/usecases/login_usecase.dart';
import 'package:student_app/features/login/domain/usecases/logout_usecase.dart';
import 'package:student_app/features/login/presentation/bloc/login_bloc.dart';
import 'package:student_app/features/notifikasi/data/datasources/notifikasi_local_data_source.dart';
import 'package:student_app/features/notifikasi/data/datasources/notifikasi_remote_data_source.dart';
import 'package:student_app/features/notifikasi/data/repositories/notifikasi_repository_implementation.dart';
import 'package:student_app/features/notifikasi/domain/repositories/notifikasi_repository.dart';
import 'package:student_app/features/notifikasi/domain/usecases/clear_notification_status_usecase.dart';
import 'package:student_app/features/notifikasi/domain/usecases/get_notification_status_usecase.dart';
import 'package:student_app/features/notifikasi/domain/usecases/listen_notification_usecase.dart';
import 'package:student_app/features/notifikasi/domain/usecases/request_notification_permission_usecase.dart';
import 'package:student_app/features/notifikasi/domain/usecases/save_notification_status_usecase.dart';
import 'package:student_app/features/notifikasi/domain/usecases/show_local_notification_usecase.dart';
import 'package:student_app/features/notifikasi/domain/usecases/stop_notification_usecase.dart';
import 'package:student_app/features/notifikasi/presentation/bloc/notifikasi_bloc.dart';
import 'package:student_app/features/student/data/datasources/student_local_datasource.dart';
import 'package:student_app/features/student/data/repositories/student_repository_implementation.dart';
import 'package:student_app/features/student/domain/repositories/student_repository.dart';
import 'package:student_app/features/student/domain/usecases/add_student.dart';
import 'package:student_app/features/student/domain/usecases/get_student_detail.dart';
import 'package:student_app/features/student/domain/usecases/get_students.dart';
import 'package:student_app/features/student/presentation/bloc/student_add/student_add_bloc.dart';
import 'package:student_app/features/student/presentation/bloc/student_detail/student_detail_bloc.dart';
import 'package:student_app/features/student/presentation/bloc/student_list/student_list_bloc.dart';
import 'package:student_app/features/tema/data/datasources/theme_local_datasource.dart';
import 'package:student_app/features/tema/data/repositories/theme_repository_implementation.dart';
import 'package:student_app/features/tema/domain/repositories/theme_repository.dart';
import 'package:student_app/features/tema/domain/usecases/get_theme.dart';
import 'package:student_app/features/tema/domain/usecases/set_theme.dart';
import 'package:student_app/features/tema/presentation/bloc/tema_bloc.dart';

var myinjection = GetIt.instance;

Future<void> init() async {
  // HTTP
  myinjection.registerLazySingleton(() => http.Client());
  myinjection.registerLazySingleton(() => Connectivity());
  myinjection.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(myinjection()),
  );
  final sharedPreferences = await SharedPreferences.getInstance();
  myinjection.registerLazySingleton(() => sharedPreferences);

  myinjection.registerLazySingleton(() => FirebaseMessaging.instance);
  myinjection.registerLazySingleton(() => FlutterLocalNotificationsPlugin());

  // BLOC
  myinjection.registerFactory(
    () => LoginBloc(
      loginUseCase: myinjection(),
      logoutUseCase: myinjection(),
      checkLogin: myinjection(),
    ),
  );

  myinjection.registerFactory(
    () => NotifikasiBloc(
      listenUseCase: myinjection(),
      permissionUseCase: myinjection(),
      showLocalUseCase: myinjection(),
      stopUseCase: myinjection(),
      getStatusUseCase: myinjection(),
      saveStatusUseCase: myinjection(),
      clearNotificationStatusUseCase: myinjection(),
    ),
  );

  myinjection.registerFactory(
    () => StudentListBloc(getStudents: myinjection()),
  );

  myinjection.registerFactory(
    () => StudentDetailBloc(getStudentDetail: myinjection()),
  );

  myinjection.registerFactory(() => StudentAddBloc(addStudent: myinjection()));

  myinjection.registerFactory(
    () => TemaBloc(
      getThemeUsecase: myinjection(),
      saveThemeUsecase: myinjection(),
    ),
  );

  // USECASE
  myinjection.registerLazySingleton(() => LoginUsecase(myinjection()));
  myinjection.registerLazySingleton(() => LogoutUsecase(myinjection()));
  myinjection.registerLazySingleton(() => CheckLogin(myinjection()));

  myinjection.registerLazySingleton(() => AddStudent(myinjection()));
  myinjection.registerLazySingleton(() => GetStudents(myinjection()));
  myinjection.registerLazySingleton(() => GetStudentDetail(myinjection()));

  myinjection.registerLazySingleton(() => GetTheme(myinjection()));
  myinjection.registerLazySingleton(() => SaveTheme(myinjection()));

  myinjection.registerLazySingleton(
    () => ListenNotificationUseCase(myinjection()),
  );

  myinjection.registerLazySingleton(
    () => RequestNotificationPermissionUseCase(myinjection()),
  );

  myinjection.registerLazySingleton(
    () => ShowLocalNotificationUseCase(myinjection()),
  );

  myinjection.registerLazySingleton(
    () => StopNotificationUseCase(myinjection()),
  );

  myinjection.registerLazySingleton(
    () => GetNotificationStatusUseCase(myinjection()),
  );

  myinjection.registerLazySingleton(
    () => SaveNotificationStatusUseCase(myinjection()),
  );

  myinjection.registerLazySingleton(
    () => ClearNotificationStatusUseCase(myinjection()),
  );
  // REPOSITORY
  myinjection.registerLazySingleton<LoginRepository>(
    () => LoginRepositoryImplementation(
      remoteDatasource: myinjection(),
      offlineDatasource: myinjection(),
      localDataSource: myinjection(),
      networkInfo: myinjection(),
    ),
  );

  myinjection.registerLazySingleton<StudentRepository>(
    () => StudentRepositoryImplementation(localDatasource: myinjection()),
  );

  myinjection.registerLazySingleton<ThemeRepository>(
    () => ThemeRepositoryImplementation(localDatasource: myinjection()),
  );

  myinjection.registerLazySingleton<NotifikasiRepository>(
    () => NotifikasiRepositoryImplementation(
      remoteDataSource: myinjection(),
      localDataSource: myinjection(),
    ),
  );

  // DATA SOURCE
  myinjection.registerLazySingleton<LocalDatasource>(
    () => LocalDatasourceImplementation(),
  );
  myinjection.registerLazySingleton<RemoteDatasource>(
    () => RemoteDatasourceImplementation(client: myinjection()),
  );
  myinjection.registerLazySingleton<OfflineDatasource>(
    () => OfflineDatasourceImplementation(),
  );

  myinjection.registerLazySingleton<StudentLocalDatasource>(
    () => StudentLocalDatasourceImplementation(),
  );

  myinjection.registerLazySingleton<ThemeLocalDatasource>(
    () => ThemeLocalDatasourceImplementation(sharedPreferences: myinjection()),
  );
  myinjection.registerLazySingleton<NotifikasiRemoteDataSource>(
    () => NotifikasiRemoteDataSourceImpl(myinjection()),
  );

  myinjection.registerLazySingleton<NotifikasiLocalDataSource>(
    () => NotifikasiLocalDataSourceImpl(myinjection(), myinjection()),
  );
}
