import 'package:student_app/features/tema/domain/entities/theme_entity.dart';

class ThemeModel extends ThemeEntity {
  final String themeValue;

  const ThemeModel({required this.themeValue})
    : super(themeType: themeValue == 'dark' ? ThemeType.dark : ThemeType.light);

  factory ThemeModel.fromEntity(ThemeEntity entity) {
    return ThemeModel(
      themeValue: entity.themeType == ThemeType.dark ? 'dark' : 'light',
    );
  }

  ThemeEntity toEntity() {
    return ThemeEntity(
      themeType: themeValue == 'dark' ? ThemeType.dark : ThemeType.light,
    );
  }
}
