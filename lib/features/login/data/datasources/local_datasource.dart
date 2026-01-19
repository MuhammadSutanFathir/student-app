import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalDatasource {
  Future<void> saveLoginStatus(bool isLoggedIn);
  Future<bool> getLoginStatus();
  Future<void> clearLoginStatus();
}

class LocalDatasourceImplementation implements LocalDatasource {
  static const String _loginKey = 'is_logged_in';

  @override
  Future<void> saveLoginStatus(bool isLoggedIn) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_loginKey, isLoggedIn);
  }

  @override
  Future<bool> getLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_loginKey) ?? false;
  }

  @override
  Future<void> clearLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_loginKey);
  }
}
