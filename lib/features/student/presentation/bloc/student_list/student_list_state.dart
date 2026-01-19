import 'package:equatable/equatable.dart';
import 'package:student_app/features/student/domain/entities/student.dart';

abstract class StudentListState extends Equatable {
  const StudentListState();

  @override
  List<Object?> get props => [];
}

class StudentListInitial extends StudentListState {}

class StudentListLoading extends StudentListState {}

class StudentListLoaded extends StudentListState {
  final List<Student> students;

  const StudentListLoaded(this.students);

  @override
  List<Object?> get props => [students];
}

class StudentListFailure extends StudentListState {
  final String message;

  const StudentListFailure(this.message);

  @override
  List<Object?> get props => [message];
}
