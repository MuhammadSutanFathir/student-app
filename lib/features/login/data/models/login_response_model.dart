import 'package:student_app/features/login/domain/entities/login_response.dart';

class LoginResponseModel extends LoginResponse {
  const LoginResponseModel({
    required super.code,
    required super.status,
    required super.message,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      code: json['code'] as int,
      status: json['status'] as String,
      message: json['message'] as String,
    );
  }
  LoginResponse toEntity() {
    return LoginResponse(code: code, status: status, message: message);
  }

  Map<String, dynamic> toJson() {
    return {'code': code, 'status': status, 'message': message};
  }
}
