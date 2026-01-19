import 'package:dartz/dartz.dart';
import 'package:student_app/core/error/failure.dart';
import 'package:student_app/features/login/domain/repositories/login_repository.dart';

class CheckLogin {
  final LoginRepository repository;

  CheckLogin(this.repository);

  Future<Either<Failure, bool>> call() async {
    return await repository.checkLoginStatus();
  }
}
