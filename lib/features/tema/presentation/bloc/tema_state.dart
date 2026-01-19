part of 'tema_bloc.dart';

abstract class TemaState extends Equatable {
  const TemaState();

  @override
  List<Object?> get props => [];
}

class TemaInitial extends TemaState {}

class TemaLoading extends TemaState {}

class TemaLoaded extends TemaState {
  final ThemeEntity themeEntity;

  const TemaLoaded(this.themeEntity);

  @override
  List<Object?> get props => [themeEntity];
}

class ThemeError extends TemaState {
  final String message;

  const ThemeError(this.message);

  @override
  List<Object?> get props => [message];
}
