import 'package:dartz/dartz.dart';
import 'package:student_app/core/error/failure.dart';
import 'package:student_app/features/student/domain/entities/student.dart';
import 'package:student_app/features/student/domain/repositories/student_repository.dart';

class GetStudentDetail {
  final StudentRepository repository;

  GetStudentDetail(this.repository);

  Future<Either<Failure, Student>> call(String nisn) {
    return repository.getStudentDetail(nisn);
  }
}
