import 'package:student_app/features/login/data/models/login_response_model.dart';

abstract class OfflineDatasource {
  Future<LoginResponseModel> loginUser(String username, String password);
}

class OfflineDatasourceImplementation implements OfflineDatasource {
  static const _username = 'admin';
  static const _password = 'admin123';

  @override
  Future<LoginResponseModel> loginUser(String username, String password) async {
    await Future.delayed(const Duration(milliseconds: 300));

    if (username.isEmpty || password.isEmpty) {
      return const LoginResponseModel(
        code: 400,
        status: 'error',
        message: 'Username dan password wajib diisi',
      );
    }

    if (username == _username && password == _password) {
      return const LoginResponseModel(
        code: 200,
        status: 'success',
        message: 'Login berhasil (Offline)',
      );
    }

    return const LoginResponseModel(
      code: 401,
      status: 'error',
      message: 'Username atau password salah',
    );
  }
}
