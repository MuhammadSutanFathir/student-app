import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/notifikasi_bloc.dart';
import '../bloc/notifikasi_event.dart';
import '../bloc/notifikasi_state.dart';

class NotifikasiPage extends StatelessWidget {
  const NotifikasiPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifikasi'),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      body: BlocListener<NotifikasiBloc, NotifikasiState>(
        listener: (context, state) {
          if (state is NotifikasiError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: colorScheme.error,
              ),
            );
          }
        },
        child: BlocBuilder<NotifikasiBloc, NotifikasiState>(
          builder: (context, state) {
            final isActive = state is NotifikasiStatusLoaded
                ? state.isActive
                : false;

            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _StatusCard(isActive: isActive),
                  const SizedBox(height: 24),

                  ElevatedButton.icon(
                    icon: const Icon(Icons.notifications_active),
                    label: const Text('Aktifkan Notifikasi'),
                    onPressed: isActive
                        ? null
                        : () {
                            context.read<NotifikasiBloc>().add(
                              SaveNotificationStatusEvent(true),
                            );
                            context.read<NotifikasiBloc>().add(
                              InitNotificationEvent(),
                            );
                          },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),

                  OutlinedButton.icon(
                    icon: const Icon(Icons.notifications_off),
                    label: const Text('Nonaktifkan Notifikasi'),
                    onPressed: !isActive
                        ? null
                        : () {
                            context.read<NotifikasiBloc>().add(
                              SaveNotificationStatusEvent(false),
                            );
                            context.read<NotifikasiBloc>().add(
                              StopListenNotificationEvent(),
                            );
                          },
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  final bool isActive;

  const _StatusCard({required this.isActive});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Icon(
              isActive ? Icons.notifications_active : Icons.notifications_off,
              size: 40,
              color: isActive ? Colors.green : Colors.grey,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isActive ? 'Notifikasi Aktif' : 'Notifikasi Nonaktif',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isActive
                        ? 'Anda akan menerima notifikasi'
                        : 'Aktifkan untuk menerima notifikasi',
                    style: TextStyle(
                      color: colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
