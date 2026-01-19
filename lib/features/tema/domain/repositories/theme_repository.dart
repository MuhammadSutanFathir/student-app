import 'package:dartz/dartz.dart';
import 'package:student_app/core/error/failure.dart';
import 'package:student_app/features/tema/domain/entities/theme_entity.dart';

abstract class ThemeRepository {
  Future<Either<Failure, ThemeEntity>> getTheme();
  Future<Either<Failure, void>> saveTheme(ThemeEntity themEntity);
}
