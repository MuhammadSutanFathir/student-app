import 'package:equatable/equatable.dart';
import 'package:student_app/features/student/domain/entities/student.dart';

abstract class StudentDetailState extends Equatable {
  const StudentDetailState();

  @override
  List<Object?> get props => [];
}

class StudentDetailInitial extends StudentDetailState {}

class StudentDetailLoading extends StudentDetailState {}

class StudentDetailLoaded extends StudentDetailState {
  final Student student;

  const StudentDetailLoaded(this.student);

  @override
  List<Object?> get props => [student];
}

class StudentDetailFailure extends StudentDetailState {
  final String message;

  const StudentDetailFailure(this.message);

  @override
  List<Object?> get props => [message];
}
