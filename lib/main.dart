import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:student_app/core/style/app_theme.dart';
import 'package:student_app/features/login/presentation/bloc/login_bloc.dart';
import 'package:student_app/features/login/presentation/pages/login_page.dart';
import 'package:student_app/features/notifikasi/presentation/bloc/notifikasi_bloc.dart';
import 'package:student_app/features/notifikasi/presentation/bloc/notifikasi_event.dart';
import 'package:student_app/features/student/data/models/student_model.dart';
import 'package:student_app/features/student/presentation/bloc/student_list/student_list_bloc.dart';
import 'package:student_app/features/tema/domain/entities/theme_entity.dart';
import 'package:student_app/features/tema/presentation/bloc/tema_bloc.dart';
import 'package:student_app/firebase_options.dart';
import 'package:student_app/injection.dart';
import 'package:student_app/observer.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(StudentModelAdapter());
  await init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Bloc.observer = MyObserver();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initLocalNotification() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidInit);

    await flutterLocalNotificationsPlugin.initialize(initSettings);
  }

  await initLocalNotification();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => myinjection<LoginBloc>()),
        BlocProvider(create: (_) => myinjection<StudentListBloc>()),

        BlocProvider(
          create: (_) => myinjection<TemaBloc>()..add(GetThemeEvent()),
        ),
        BlocProvider(
          create: (_) =>
              myinjection<NotifikasiBloc>()..add(LoadNotificationStatusEvent()),
        ),
      ],
      child: BlocBuilder<TemaBloc, TemaState>(
        builder: (context, state) {
          final isDark =
              state is TemaLoaded &&
              state.themeEntity.themeType == ThemeType.dark;

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Student App',

            theme: AppTheme.getTheme(false),
            darkTheme: AppTheme.getTheme(true),
            themeMode: isDark ? ThemeMode.dark : ThemeMode.light,

            home: const LoginPage(),
          );
        },
      ),
    );
  }
}
