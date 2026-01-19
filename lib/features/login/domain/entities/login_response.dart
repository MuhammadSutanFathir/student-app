import 'package:equatable/equatable.dart';

class LoginResponse extends Equatable {
  final int code;
  final String status;
  final String message;

  const LoginResponse({
    required this.code,
    required this.status,
    required this.message,
  });

  bool get isLogin => code == 200 && status == 'success';

  @override
  List<Object?> get props => [code, status, message];
}
