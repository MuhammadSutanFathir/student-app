import 'package:dartz/dartz.dart';
import 'package:student_app/core/error/failure.dart';
import 'package:student_app/features/tema/domain/entities/theme_entity.dart';
import 'package:student_app/features/tema/domain/repositories/theme_repository.dart';

class GetTheme {
  final ThemeRepository themeRepository;

  GetTheme(this.themeRepository);

  Future<Either<Failure, ThemeEntity>> call() {
    return themeRepository.getTheme();
  }
}
