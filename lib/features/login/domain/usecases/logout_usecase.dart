import 'package:dartz/dartz.dart';
import 'package:student_app/core/error/failure.dart';
import 'package:student_app/features/login/domain/repositories/login_repository.dart';

class LogoutUsecase {
  final LoginRepository repository;

  LogoutUsecase(this.repository);

  Future<Either<Failure, void>> call() {
    return repository.logout();
  }
}
