import 'package:equatable/equatable.dart';

class Student extends Equatable {
  final String nisn;
  final String fullName;
  final DateTime birthDate;
  final String major;

  const Student({
    required this.nisn,
    required this.fullName,
    required this.birthDate,
    required this.major,
  });

  @override
  List<Object?> get props => [nisn, fullName, birthDate, major];
}
