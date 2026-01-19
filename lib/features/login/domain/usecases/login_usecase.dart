import 'package:dartz/dartz.dart';
import 'package:student_app/core/error/failure.dart';
import 'package:student_app/features/login/domain/entities/login_response.dart';
import 'package:student_app/features/login/domain/repositories/login_repository.dart';

class LoginUsecase {
  final LoginRepository repository;

  LoginUsecase(this.repository);

  Future<Either<Failure, LoginResponse>> call({
    required String username,
    required String password,
  }) {
    return repository.loginUser(username, password);
  }
}
