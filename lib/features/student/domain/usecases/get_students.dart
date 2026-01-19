import 'package:dartz/dartz.dart';
import 'package:student_app/core/error/failure.dart';
import 'package:student_app/features/student/domain/entities/student.dart';
import 'package:student_app/features/student/domain/repositories/student_repository.dart';

class GetStudents {
  final StudentRepository repository;

  GetStudents(this.repository);

  Future<Either<Failure, List<Student>>> call() {
    return repository.getStudents();
  }
}
