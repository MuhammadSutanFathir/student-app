import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:student_app/features/login/domain/entities/login_response.dart';
import 'package:student_app/features/login/domain/usecases/check_login.dart';
import 'package:student_app/features/login/domain/usecases/login_usecase.dart';
import 'package:student_app/features/login/domain/usecases/logout_usecase.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUsecase loginUseCase;
  final LogoutUsecase logoutUseCase;
  final CheckLogin checkLogin;

  LoginBloc({
    required this.loginUseCase,
    required this.logoutUseCase,
    required this.checkLogin,
  }) : super(LoginStateEmpty()) {
    on<LoginSubmitted>((event, emit) async {
      emit(LoginStateLoading());

      final result = await loginUseCase(
        username: event.username,
        password: event.password,
      );

      result.fold(
        (failure) {
          emit(LoginStateFailure(failure.toString()));
        },
        (response) {
          if (response.code == 200) {
            emit(LoginStateAuthenticated());
          } else {
            emit(LoginStateFailure(response.message));
          }
        },
      );
    });

    on<LogoutRequested>((event, emit) async {
      emit(LoginStateLoading());

      final result = await logoutUseCase();

      result.fold(
        (failure) {
          emit(LoginStateFailure('Logout gagal'));
        },
        (_) {
          emit(LogoutSuccess());
          emit(LoginStateUnauthenticated());
        },
      );
    });

    on<CheckLoginStatusRequested>((event, emit) async {
      emit(LoginStateLoading());

      final result = await checkLogin();

      result.fold(
        (failure) {
          emit(LoginStateUnauthenticated());
        },
        (isLoggedIn) {
          if (isLoggedIn) {
            emit(LoginStateAuthenticated());
          } else {
            emit(LoginStateUnauthenticated());
          }
        },
      );
    });
  }
}
