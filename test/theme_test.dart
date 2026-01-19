import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:student_app/core/error/failure.dart';
import 'package:student_app/features/tema/data/datasources/theme_local_datasource.dart';
import 'package:student_app/features/tema/data/models/theme_model.dart';
import 'package:student_app/features/tema/data/repositories/theme_repository_implementation.dart';
import 'package:student_app/features/tema/domain/entities/theme_entity.dart';


class MockThemeLocalDatasource extends Mock implements ThemeLocalDatasource {}

void main() {
  late ThemeRepositoryImplementation repository;
  late MockThemeLocalDatasource mockLocalDatasource;

  setUp(() {
    mockLocalDatasource = MockThemeLocalDatasource();
    repository = ThemeRepositoryImplementation(
      localDatasource: mockLocalDatasource,
    );
  });

  group('getTheme', () {
    final tThemeModel = ThemeModel(themeValue: 'dark');
    final tThemeEntity = tThemeModel.toEntity();

    test(
      'Harus mengembalikan ThemeEntity ketika pengambilan data dari local datasource berhasil',
      () async {
        
        when(
          () => mockLocalDatasource.getTheme(),
        ).thenAnswer((_) async => tThemeModel);

        
        final result = await repository.getTheme();

        
        verify(() => mockLocalDatasource.getTheme()).called(1);
        expect(result, equals(Right(tThemeEntity)));
      },
    );

    test(
      'Harus mengembalikan CacheFailure ketika pengambilan data dari local datasource gagal (Exception)',
      () async {
        
        when(() => mockLocalDatasource.getTheme()).thenThrow(Exception());

        
        final result = await repository.getTheme();

        
        verify(() => mockLocalDatasource.getTheme()).called(1);
        expect(result, equals(Left(CacheFailure())));
      },
    );
  });

  group('saveTheme', () {
    const tThemeEntity = ThemeEntity(themeType: ThemeType.light);
    
    setUpAll(() {
      registerFallbackValue(ThemeModel.fromEntity(tThemeEntity));
    });

    test(
      'Harus memanggil local datasource untuk menyimpan tema dan mengembalikan Right(null) jika berhasil',
      () async {
        
        when(
          () => mockLocalDatasource.saveTheme(any()),
        ).thenAnswer((_) async => Future.value());

        
        final result = await repository.saveTheme(tThemeEntity);

        
        verify(
          () => mockLocalDatasource.saveTheme(
            any(
              that: isA<ThemeModel>().having(
                (m) => m.themeValue,
                'themeValue', 
                'light',
              ),
            ),
          ),
        ).called(1);

        expect(result, equals(const Right(null)));
      },
    );

    test(
      'Harus mengembalikan CacheFailure ketika proses penyimpanan ke local datasource gagal (Exception)',
      () async {
        
        when(() => mockLocalDatasource.saveTheme(any())).thenThrow(Exception());

        
        final result = await repository.saveTheme(tThemeEntity);

        
        verify(() => mockLocalDatasource.saveTheme(any())).called(1);
        expect(result, equals(Left(CacheFailure())));
      },
    );
  });
}
