import 'package:equatable/equatable.dart';

enum ThemeType { dark, light }

class ThemeEntity extends Equatable {
  final ThemeType themeType;

  const ThemeEntity({required this.themeType});

  @override
  List<Object?> get props => [themeType];
}
