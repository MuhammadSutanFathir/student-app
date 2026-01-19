import 'package:dartz/dartz.dart';
import 'package:student_app/core/error/failure.dart';
import 'package:student_app/features/tema/data/datasources/theme_local_datasource.dart';
import 'package:student_app/features/tema/data/models/theme_model.dart';
import 'package:student_app/features/tema/domain/entities/theme_entity.dart';
import 'package:student_app/features/tema/domain/repositories/theme_repository.dart';

class ThemeRepositoryImplementation implements ThemeRepository {
  final ThemeLocalDatasource localDatasource;

  ThemeRepositoryImplementation({required this.localDatasource});

  @override
  Future<Either<Failure, ThemeEntity>> getTheme() async {
    try {
      final ThemeModel model = await localDatasource.getTheme();
      final entity = model.toEntity();
      return Right(entity);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> saveTheme(ThemeEntity themeEntity) async {
    try {
      final model = ThemeModel.fromEntity(themeEntity);
      await localDatasource.saveTheme(model);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure());
    }
  }
}
