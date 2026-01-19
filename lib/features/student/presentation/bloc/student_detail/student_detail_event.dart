import 'package:equatable/equatable.dart';

abstract class StudentDetailEvent extends Equatable {
  const StudentDetailEvent();

  @override
  List<Object?> get props => [];
}

class GetStudentDetailRequested extends StudentDetailEvent {
  final String nisn;

  const GetStudentDetailRequested(this.nisn);

  @override
  List<Object?> get props => [nisn];
}
