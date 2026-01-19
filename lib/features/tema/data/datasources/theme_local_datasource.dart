import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_app/features/tema/data/models/theme_model.dart';

abstract class ThemeLocalDatasource {
  Future<void> saveTheme(ThemeModel model);
  Future<ThemeModel> getTheme();
}

class ThemeLocalDatasourceImplementation implements ThemeLocalDatasource {
  final SharedPreferences sharedPreferences;

  static const _key = 'theme_key';

  ThemeLocalDatasourceImplementation({required this.sharedPreferences});

  @override
  Future<void> saveTheme(ThemeModel model) async {
    await sharedPreferences.setString(_key, model.themeValue);
  }

  @override
  Future<ThemeModel> getTheme() async {
    final value = sharedPreferences.getString(_key);

    return ThemeModel(themeValue: value ?? 'light');
  }
}
