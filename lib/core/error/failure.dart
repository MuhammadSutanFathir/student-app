import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

class NotFoundFailure extends Failure {
  const NotFoundFailure([String message = 'Data tidak ditemukan'])
    : super(message);
}

class ValidationFailure extends Failure {
  const ValidationFailure(String message) : super(message);
}

class CacheFailure extends Failure {
  const CacheFailure([String message = 'Gagal mengakses penyimpanan lokal'])
    : super(message);
}

class NetworkFailure extends Failure {
  const NetworkFailure([String message = 'Tidak ada koneksi internet'])
    : super(message);
}

class NotificationFailure extends Failure {
  const NotificationFailure([String message = 'Gagal memproses notifikasi'])
    : super(message);
}

class AuthFailure extends Failure {
  const AuthFailure([String message = 'Autentikasi gagal']) : super(message);
}
