part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {}

class LoginSubmitted extends LoginEvent {
  final String username;
  final String password;

  LoginSubmitted({required this.username, required this.password});

  @override
  List<Object?> get props => [username, password];
}

class LogoutRequested extends LoginEvent {
  @override
  List<Object?> get props => [];
}

class CheckLoginStatusRequested extends LoginEvent {
  @override
  List<Object?> get props => [];
}
