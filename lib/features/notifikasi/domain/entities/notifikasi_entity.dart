import 'package:equatable/equatable.dart';

class NotifikasiEntity extends Equatable {
  final String title;
  final String body;
  final bool isActive;

  const NotifikasiEntity({
    required this.title,
    required this.body,
    required this.isActive,
  });

  @override
  List<Object?> get props => [title, body, isActive];
}
