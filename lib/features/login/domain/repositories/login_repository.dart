import 'package:student_app/core/error/failure.dart';
import 'package:student_app/features/login/domain/entities/login_response.dart';
import 'package:dartz/dartz.dart';

abstract class LoginRepository {
  Future<Either<Failure, LoginResponse>> loginUser(
    String username,
    String password,
  );
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, bool>> checkLoginStatus();
}
