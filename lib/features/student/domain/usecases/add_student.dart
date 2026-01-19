import 'package:dartz/dartz.dart';
import 'package:student_app/core/error/failure.dart';
import 'package:student_app/features/student/domain/entities/student.dart';
import 'package:student_app/features/student/domain/repositories/student_repository.dart';

class AddStudent {
  final StudentRepository repository;

  AddStudent(this.repository);

  Future<Either<Failure, void>> call(Student student) {
    return repository.addStudent(student);
  }
}
