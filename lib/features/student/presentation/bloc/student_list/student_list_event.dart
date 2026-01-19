import 'package:equatable/equatable.dart';

abstract class StudentListEvent extends Equatable {
  const StudentListEvent();

  @override
  List<Object?> get props => [];
}

class GetStudentsRequested extends StudentListEvent {
  const GetStudentsRequested();
}
