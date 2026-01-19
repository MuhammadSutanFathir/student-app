import 'package:dartz/dartz.dart';
import 'package:student_app/core/error/failure.dart';
import 'package:student_app/features/student/data/datasources/student_local_datasource.dart';
import 'package:student_app/features/student/data/models/student_model.dart';
import 'package:student_app/features/student/domain/entities/student.dart';
import 'package:student_app/features/student/domain/repositories/student_repository.dart';

class StudentRepositoryImplementation implements StudentRepository {
  final StudentLocalDatasource localDatasource;

  StudentRepositoryImplementation({required this.localDatasource});

  @override
  Future<Either<Failure, void>> addStudent(Student student) async {
    try {
      final existingStudent = await localDatasource.getStudentDetail(
        student.nisn,
      );

      if (existingStudent != null) {
        return const Left(ValidationFailure('NISN sudah terdaftar'));
      }
      final model = StudentModel.fromEntity(student);

      await localDatasource.addStudent(model);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<Student>>> getStudents() async {
    try {
      final result = await localDatasource.getStudents();

      final students = result.map((e) => e.toEntity()).toList();
      return Right(students);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, Student>> getStudentDetail(String nisn) async {
    try {
      final student = await localDatasource.getStudentDetail(nisn);

      if (student == null) {
        return Left(NotFoundFailure('Siswa tidak ditemukan'));
      }

      return Right(student.toEntity());
    } catch (e) {
      return Left(CacheFailure());
    }
  }
}
