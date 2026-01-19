import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:student_app/features/notifikasi/data/repositories/notifikasi_repository_implementation.dart';
import 'package:student_app/features/notifikasi/data/datasources/notifikasi_remote_data_source.dart';
import 'package:student_app/features/notifikasi/data/datasources/notifikasi_local_data_source.dart';
import 'package:student_app/features/notifikasi/data/models/notifikasi_model.dart';
import 'package:student_app/features/notifikasi/domain/entities/notifikasi_entity.dart';

class MockNotifikasiRemoteDataSource extends Mock
    implements NotifikasiRemoteDataSource {}

class MockNotifikasiLocalDataSource extends Mock
    implements NotifikasiLocalDataSource {}

void main() {
  setUpAll(() {
    registerFallbackValue(NotifikasiModel(title: '', body: ''));
  });

  late NotifikasiRepositoryImplementation repository;
  late MockNotifikasiRemoteDataSource mockRemoteDataSource;
  late MockNotifikasiLocalDataSource mockLocalDataSource;

  setUp(() {
    mockRemoteDataSource = MockNotifikasiRemoteDataSource();
    mockLocalDataSource = MockNotifikasiLocalDataSource();

    repository = NotifikasiRepositoryImplementation(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  group('requestPermission', () {
    test('harus memanggil requestPermission dari remote data source', () async {
      
      when(
        () => mockRemoteDataSource.requestPermission(),
      ).thenAnswer((_) async {});

      
      await repository.requestPermission();

      
      verify(() => mockRemoteDataSource.requestPermission()).called(1);
      verifyNoMoreInteractions(mockRemoteDataSource);
    });
  });

  group('notificationStream', () {
    test(
      'harus mengembalikan stream NotifikasiEntity hasil mapping dari NotifikasiModel',
      () {
        
        final model = NotifikasiModel(title: 'Test Title', body: 'Test Body');

        when(
          () => mockRemoteDataSource.listenNotification(),
        ).thenAnswer((_) => Stream.value(model));

        
        final result = repository.notificationStream();

        
        expectLater(
          result,
          emits(
            NotifikasiEntity(
              title: 'Test Title',
              body: 'Test Body',
              isActive: true,
            ),
          ),
        );
      },
    );
  });

  group('stopListening', () {
    test('harus memanggil stopListening dari remote data source', () async {
      
      when(() => mockRemoteDataSource.stopListening()).thenAnswer((_) async {});

      
      await repository.stopListening();

      
      verify(() => mockRemoteDataSource.stopListening()).called(1);
    });
  });

  group('showLocalNotification', () {
    test(
      'harus memanggil showNotification pada local data source dengan model hasil mapping',
      () async {
        
        final entity = NotifikasiEntity(
          title: 'Local Title',
          body: 'Local Body',
          isActive: true,
        );

        when(
          () => mockLocalDataSource.showNotification(any()),
        ).thenAnswer((_) async {});

        
        await repository.showLocalNotification(entity);

        
        final capturedModel =
            verify(
                  () => mockLocalDataSource.showNotification(captureAny()),
                ).captured.single
                as NotifikasiModel;

        expect(capturedModel.title, entity.title);
        expect(capturedModel.body, entity.body);
      },
    );
  });
}
