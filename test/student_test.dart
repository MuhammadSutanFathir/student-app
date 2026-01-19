import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:student_app/core/error/failure.dart';
import 'package:student_app/features/student/data/datasources/student_local_datasource.dart';
import 'package:student_app/features/student/data/models/student_model.dart';
import 'package:student_app/features/student/data/repositories/student_repository_implementation.dart';
import 'package:student_app/features/student/domain/entities/student.dart';

class MockStudentLocalDatasource extends Mock
    implements StudentLocalDatasource {}

void main() {
  late StudentRepositoryImplementation repository;
  late MockStudentLocalDatasource mockLocalDatasource;

  setUpAll(() {
    registerFallbackValue(
      StudentModel(
        nisn: 'dummy',
        fullName: 'dummy',
        birthDate: DateTime(2000, 1, 1),
        major: 'dummy',
      ),
    );
  });

  setUp(() {
    mockLocalDatasource = MockStudentLocalDatasource();
    repository = StudentRepositoryImplementation(
      localDatasource: mockLocalDatasource,
    );
  });

  final tStudent = Student(
    nisn: '123456',
    fullName: 'Budi Santoso',
    birthDate: DateTime(2002, 1, 1),
    major: 'RPL',
  );

  final tStudentModel = StudentModel(
    nisn: '123456',
    fullName: 'Budi Santoso',
    birthDate: DateTime(2002, 1, 1),
    major: 'RPL',
  );

  final tStudentModelList = [tStudentModel];

  group('addStudent', () {
    test('Tambah murid tetapi nisn sudah ada', () async {
      
      when(
        () => mockLocalDatasource.getStudentDetail(any()),
      ).thenAnswer((_) async => tStudentModel);

      
      final result = await repository.addStudent(tStudent);

      
      result.fold((failure) {
        expect(failure, const ValidationFailure('NISN sudah terdaftar'));
      }, (_) => fail('Should return ValidationFailure'));

      verify(
        () => mockLocalDatasource.getStudentDetail(tStudent.nisn),
      ).called(1);
      verifyNever(() => mockLocalDatasource.addStudent(any()));
    });

    test('Tambah murid berhasil', () async {
      
      when(
        () => mockLocalDatasource.getStudentDetail(any()),
      ).thenAnswer((_) async => null);

      when(
        () => mockLocalDatasource.addStudent(any()),
      ).thenAnswer((_) async {});

      
      final result = await repository.addStudent(tStudent);

      
      result.fold(
        (failure) => fail('Should return success'),
        (_) => expect(true, true),
      );

      verify(
        () => mockLocalDatasource.getStudentDetail(tStudent.nisn),
      ).called(1);
      verify(() => mockLocalDatasource.addStudent(any())).called(1);
    });
  });

  group('getStudents', () {
    test('Tampilkan list murid', () async {
      
      when(
        () => mockLocalDatasource.getStudents(),
      ).thenAnswer((_) async => tStudentModelList);

      
      final result = await repository.getStudents();

      
      result.fold((failure) => fail('Should return students'), (students) {
        expect(students, [tStudent]);
      });

      verify(() => mockLocalDatasource.getStudents()).called(1);
    });

    test('Gagal ambil list murid', () async {
      
      when(() => mockLocalDatasource.getStudents()).thenThrow(Exception());

      
      final result = await repository.getStudents();

      
      result.fold(
        (failure) => expect(failure, isA<CacheFailure>()),
        (_) => fail('Should return CacheFailure'),
      );
    });
  });

  group('getStudentDetail', () {
    test('Tampilkan Detail Murid', () async {
      
      when(
        () => mockLocalDatasource.getStudentDetail(any()),
      ).thenAnswer((_) async => tStudentModel);

      
      final result = await repository.getStudentDetail('123456');

      
      result.fold((failure) => fail('Should return student'), (student) {
        expect(student, tStudent);
      });

      verify(() => mockLocalDatasource.getStudentDetail('123456')).called(1);
    });

    test('Detail murid tidak tampil', () async {
      
      when(
        () => mockLocalDatasource.getStudentDetail(any()),
      ).thenAnswer((_) async => null);

      
      final result = await repository.getStudentDetail('999999');

      
      result.fold((failure) {
        expect(failure, const NotFoundFailure('Siswa tidak ditemukan'));
      }, (_) => fail('Should return NotFoundFailure'));
    });

    test('return CacheFailure when datasource throws', () async {
      
      when(
        () => mockLocalDatasource.getStudentDetail(any()),
      ).thenThrow(Exception());

      
      final result = await repository.getStudentDetail('123456');

      
      result.fold(
        (failure) => expect(failure, isA<CacheFailure>()),
        (_) => fail('Should return CacheFailure'),
      );
    });
  });
}
