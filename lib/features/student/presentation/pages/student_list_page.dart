import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_app/features/login/presentation/bloc/login_bloc.dart';
import 'package:student_app/features/login/presentation/pages/login_page.dart';
import 'package:student_app/features/notifikasi/presentation/bloc/notifikasi_bloc.dart';
import 'package:student_app/features/notifikasi/presentation/bloc/notifikasi_event.dart';
import 'package:student_app/features/notifikasi/presentation/pages/notifikasi_page.dart';
import 'package:student_app/features/student/presentation/bloc/student_add/student_add_bloc.dart';
import 'package:student_app/features/student/presentation/bloc/student_detail/student_detail_bloc.dart';
import 'package:student_app/features/student/presentation/bloc/student_detail/student_detail_event.dart';
import 'package:student_app/features/student/presentation/pages/add_student_page.dart';
import 'package:student_app/features/student/presentation/pages/student_detail_page.dart';
import 'package:student_app/features/student/presentation/widgets/student_list_card.dart';
import 'package:student_app/features/tema/domain/entities/theme_entity.dart';
import 'package:student_app/features/tema/presentation/bloc/tema_bloc.dart';
import 'package:student_app/injection.dart';
import '../bloc/student_list/student_list_bloc.dart';
import '../bloc/student_list/student_list_event.dart';
import '../bloc/student_list/student_list_state.dart';

class StudentListPage extends StatefulWidget {
  const StudentListPage({super.key});

  @override
  State<StudentListPage> createState() => _StudentListPageState();
}

class _StudentListPageState extends State<StudentListPage> {
  @override
  void initState() {
    super.initState();
    context.read<StudentListBloc>().add(const GetStudentsRequested());
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: colorScheme.primary,
        title: Text(
          'Daftar Siswa',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: colorScheme.onPrimary,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.notifications_rounded,
              color: colorScheme.onPrimary,
            ),
            tooltip: 'Notifikasi',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: context.read<NotifikasiBloc>(),
                    child: const NotifikasiPage(),
                  ),
                ),
              );
            },
          ),

          IconButton(
            icon: Icon(Icons.logout_rounded, color: colorScheme.onPrimary),
            tooltip: 'Logout',
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  backgroundColor: colorScheme.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  title: Text(
                    'Konfirmasi Logout',
                    style: TextStyle(color: colorScheme.onSurface),
                  ),
                  content: Text(
                    'Apakah Anda yakin ingin keluar?',
                    style: TextStyle(color: colorScheme.onSurface),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: Text(
                        'Batal',
                        style: TextStyle(color: colorScheme.primary),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        context.read<NotifikasiBloc>().add(LogoutEvent());
                        context.read<TemaBloc>().add(ResetThemeEvent());
                        context.read<LoginBloc>().add(LogoutRequested());

                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => const LoginPage()),
                          (_) => false,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.error,
                        foregroundColor: colorScheme.onError,
                      ),
                      child: const Text('Logout'),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider(
                create: (_) => myinjection<StudentAddBloc>(),
                child: const AddStudentPage(),
              ),
            ),
          );

          if (result == true) {
            context.read<StudentListBloc>().add(const GetStudentsRequested());
          }
        },
        icon: const Icon(Icons.add_rounded),
        label: const Text('Tambah Siswa'),
        elevation: 4,
      ),
      body: Stack(
        children: [
          BlocBuilder<StudentListBloc, StudentListState>(
            builder: (context, state) {
              if (state is StudentListLoading) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Memuat data siswa...',
                        style: TextStyle(
                          fontSize: 16,
                          color: colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                );
              }

              if (state is StudentListLoaded) {
                if (state.students.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.school_outlined,
                          size: 100,
                          color: colorScheme.onSurface.withValues(alpha: 0.2),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Belum ada data siswa',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tekan tombol + untuk menambah siswa',
                          style: TextStyle(
                            fontSize: 14,
                            color: colorScheme.onSurface.withValues(alpha: 0.4),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.students.length,
                  itemBuilder: (context, index) {
                    final student = state.students[index];

                    return StudentListCard(
                      student: student,
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BlocProvider(
                              create: (_) => myinjection<StudentDetailBloc>()
                                ..add(GetStudentDetailRequested(student.nisn)),
                              child: const StudentDetailPage(),
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              }

              if (state is StudentListFailure) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline_rounded,
                        size: 80,
                        color: colorScheme.error.withValues(alpha: 0.6),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Terjadi Kesalahan',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Text(
                          state.message,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: () {
                          context.read<StudentListBloc>().add(
                            const GetStudentsRequested(),
                          );
                        },
                        icon: const Icon(Icons.refresh_rounded),
                        label: const Text('Coba Lagi'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.primary,
                          foregroundColor: colorScheme.onPrimary,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }

              return const SizedBox();
            },
          ),
          Positioned(
            left: 16,
            bottom: 16,
            child: BlocBuilder<TemaBloc, TemaState>(
              builder: (context, state) {
                final isDark =
                    state is TemaLoaded &&
                    state.themeEntity.themeType == ThemeType.dark;

                return ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark
                        ? colorScheme.primary
                        : Colors.black87,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
                  label: Text(isDark ? 'Light' : 'Dark'),
                  onPressed: () {
                    final newTheme = ThemeEntity(
                      themeType: isDark ? ThemeType.light : ThemeType.dark,
                    );
                    context.read<TemaBloc>().add(SaveThemeEvent(newTheme));
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
