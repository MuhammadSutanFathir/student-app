import 'package:equatable/equatable.dart';
import 'package:student_app/features/student/domain/entities/student.dart';

abstract class StudentAddEvent extends Equatable {
  const StudentAddEvent();

  @override
  List<Object?> get props => [];
}

class AddStudentRequested extends StudentAddEvent {
  final Student student;

  const AddStudentRequested(this.student);

  @override
  List<Object?> get props => [student];
}
