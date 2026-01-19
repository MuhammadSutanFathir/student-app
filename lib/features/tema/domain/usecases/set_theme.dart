import 'package:dartz/dartz.dart';
import 'package:student_app/core/error/failure.dart';
import 'package:student_app/features/tema/domain/entities/theme_entity.dart';
import 'package:student_app/features/tema/domain/repositories/theme_repository.dart';

class SaveTheme {
  final ThemeRepository themeRepository;

  SaveTheme(this.themeRepository);

  Future<Either<Failure, void>> call(ThemeEntity themeEntity) {
    return themeRepository.saveTheme(themeEntity);
  }
}
