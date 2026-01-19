import 'package:hive/hive.dart';
import 'package:student_app/features/student/domain/entities/student.dart';

part 'student_model.g.dart';

@HiveType(typeId: 0)
class StudentModel extends Student {
  @HiveField(0)
  final String nisn;

  @HiveField(1)
  final String fullName;

  @HiveField(2)
  final DateTime birthDate;

  @HiveField(3)
  final String major;

  const StudentModel({
    required this.nisn,
    required this.fullName,
    required this.birthDate,
    required this.major,
  }) : super(
         nisn: nisn,
         fullName: fullName,
         birthDate: birthDate,
         major: major,
       );

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      nisn: json['nisn'],
      fullName: json['fullName'],
      birthDate: DateTime.parse(json['birthDate']),
      major: json['major'],
    );
  }
  Student toEntity() {
    return Student(
      nisn: nisn,
      fullName: fullName,
      birthDate: birthDate,
      major: major,
    );
  }

  factory StudentModel.fromEntity(Student student) {
    return StudentModel(
      nisn: student.nisn,
      fullName: student.fullName,
      birthDate: student.birthDate,
      major: student.major,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nisn': nisn,
      'fullName': fullName,
      'birthDate': birthDate.toIso8601String(),
      'major': major,
    };
  }
}
