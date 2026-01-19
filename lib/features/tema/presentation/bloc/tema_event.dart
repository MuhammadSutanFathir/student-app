part of 'tema_bloc.dart';

abstract class TemaEvent extends Equatable {
  const TemaEvent();

  @override
  List<Object?> get props => [];
}

class GetThemeEvent extends TemaEvent {}

class SaveThemeEvent extends TemaEvent {
  final ThemeEntity themeEntity;

  const SaveThemeEvent(this.themeEntity);

  @override
  List<Object?> get props => [themeEntity];
}

class ResetThemeEvent extends TemaEvent {}
