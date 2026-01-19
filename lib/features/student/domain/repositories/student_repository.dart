import 'package:dartz/dartz.dart';
import 'package:student_app/core/error/failure.dart';
import 'package:student_app/features/student/domain/entities/student.dart';

abstract class StudentRepository {
  Future<Either<Failure, void>> addStudent(Student student);
  Future<Either<Failure, List<Student>>> getStudents();
  Future<Either<Failure, Student>> getStudentDetail(String nisn);
}
