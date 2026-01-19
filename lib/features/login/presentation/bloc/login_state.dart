part of 'login_bloc.dart';

abstract class LoginState extends Equatable {}

class LoginStateEmpty extends LoginState {
  @override
  List<Object> get props => [];
}

class LoginStateLoading extends LoginState {
  @override
  List<Object> get props => [];
}

class LoginStateFailure extends LoginState {
  final String message;

  LoginStateFailure(this.message);

  @override
  List<Object> get props => [message];
}

class LoginStateSuccess extends LoginState {
  final LoginResponse response;

  LoginStateSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

class LogoutSuccess extends LoginState {
  @override
  List<Object> get props => [];
}

class LoginStateAuthenticated extends LoginState {
  @override
  List<Object?> get props => [];
}

class LoginStateUnauthenticated extends LoginState {
  @override
  List<Object?> get props => [];
}
