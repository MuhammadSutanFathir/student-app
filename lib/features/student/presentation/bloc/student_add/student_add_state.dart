import 'package:equatable/equatable.dart';

abstract class StudentAddState extends Equatable {
  const StudentAddState();

  @override
  List<Object?> get props => [];
}

class StudentAddInitial extends StudentAddState {}

class StudentAddLoading extends StudentAddState {}

class StudentAddSuccess extends StudentAddState {}

class StudentAddFailure extends StudentAddState {
  final String message;

  const StudentAddFailure(this.message);

  @override
  List<Object?> get props => [message];
}
