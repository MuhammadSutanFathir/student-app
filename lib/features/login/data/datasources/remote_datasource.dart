import 'dart:convert';

import 'package:student_app/features/login/data/models/login_response_model.dart';
import 'package:http/http.dart' as http;

abstract class RemoteDatasource {
  Future<LoginResponseModel> loginUser(String username, String password);
}

class RemoteDatasourceImplementation extends RemoteDatasource {
  final http.Client client;

  RemoteDatasourceImplementation({required this.client});
  @override
  Future<LoginResponseModel> loginUser(String username, String password) async {
    Uri url = Uri.parse("https://login-lemon-psi-55.vercel.app/api/login");
    final response = await client.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    final Map<String, dynamic> json = jsonDecode(response.body);

    return LoginResponseModel.fromJson(json);
  }
}
