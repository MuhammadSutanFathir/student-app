import 'package:student_app/features/student/data/models/student_model.dart';
import 'package:hive/hive.dart';

abstract class StudentLocalDatasource {
  Future<void> addStudent(StudentModel student);
  Future<List<StudentModel>> getStudents();
  Future<StudentModel?> getStudentDetail(String nisn);
}

class StudentLocalDatasourceImplementation implements StudentLocalDatasource {
  static const String boxName = 'students';

  @override
  Future<void> addStudent(StudentModel student) async {
    final box = await Hive.openBox<StudentModel>(boxName);
    await box.add(student);
  }

  @override
  Future<List<StudentModel>> getStudents() async {
    final box = await Hive.openBox<StudentModel>(boxName);
    return box.values.toList().reversed.toList();
  }

  @override
  Future<StudentModel?> getStudentDetail(String nisn) async {
    final box = await Hive.openBox<StudentModel>(boxName);
    try {
      return box.values.firstWhere((student) => student.nisn == nisn);
    } catch (e) {
      return null;
    }
  }
}
