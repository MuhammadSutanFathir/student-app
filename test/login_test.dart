import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:student_app/core/network/network_info_impl.dart';
import 'package:student_app/features/login/data/datasources/local_datasource.dart';
import 'package:student_app/features/login/data/datasources/offline_datasource.dart';
import 'package:student_app/features/login/data/datasources/remote_datasource.dart';
import 'package:student_app/features/login/data/models/login_response_model.dart';
import 'package:student_app/features/login/data/repositories/login_repository_implementation.dart';

class MockRemoteDatasource extends Mock implements RemoteDatasource {}

class MockOfflineDatasource extends Mock implements OfflineDatasource {}

class MockLocalDatasource extends Mock implements LocalDatasource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late LoginRepositoryImplementation repository;
  late MockRemoteDatasource remoteDatasource;
  late MockOfflineDatasource offlineDatasource;
  late MockLocalDatasource localDatasource;
  late MockNetworkInfo networkInfo;

  setUp(() {
    remoteDatasource = MockRemoteDatasource();
    offlineDatasource = MockOfflineDatasource();
    localDatasource = MockLocalDatasource();
    networkInfo = MockNetworkInfo();

    repository = LoginRepositoryImplementation(
      remoteDatasource: remoteDatasource,
      offlineDatasource: offlineDatasource,
      localDataSource: localDatasource,
      networkInfo: networkInfo,
    );
  });

  test('Login ONLINE berhasil', () async {
    const response = LoginResponseModel(
      code: 200,
      status: 'success',
      message: 'Login berhasil',
    );

    when(
      () => remoteDatasource.loginUser('admin', 'admin123'),
    ).thenAnswer((_) async => response);
    when(() => networkInfo.isConnected).thenAnswer((_) async => true);
    when(() => localDatasource.saveLoginStatus(true)).thenAnswer((_) async {});

    final result = await repository.loginUser('admin', 'admin123');

    expect(result.isRight(), true);

    result.fold((l) => fail('Harusnya login berhasil'), (r) {
      expect(r.code, 200);
      expect(r.status, 'success');
      expect(r.message, 'Login berhasil');
    });

    verify(() => localDatasource.saveLoginStatus(true)).called(1);
  });

  test('Login ONLINE gagal (password salah)', () async {
    const response = LoginResponseModel(
      code: 401,
      status: 'error',
      message: 'Username atau password salah',
    );

    when(
      () => remoteDatasource.loginUser('admin', 'salah'),
    ).thenAnswer((_) async => response);
    when(() => networkInfo.isConnected).thenAnswer((_) async => true);
    when(() => localDatasource.saveLoginStatus(false)).thenAnswer((_) async {});

    final result = await repository.loginUser('admin', 'salah');

    expect(result.isRight(), true);

    result.fold((l) => fail('Response harus Right'), (r) {
      expect(r.code, 401);
      expect(r.status, 'error');
      expect(r.message, 'Username atau password salah');
    });

    verify(() => localDatasource.saveLoginStatus(false)).called(1);
  });

  test('Login ONLINE gagal (username & password kosong)', () async {
    const response = LoginResponseModel(
      code: 400,
      status: 'error',
      message: 'Username dan password wajib diisi',
    );

    when(
      () => remoteDatasource.loginUser('', ''),
    ).thenAnswer((_) async => response);
    when(() => networkInfo.isConnected).thenAnswer((_) async => true);
    when(() => localDatasource.saveLoginStatus(false)).thenAnswer((_) async {});

    final result = await repository.loginUser('', '');

    expect(result.isRight(), true);

    result.fold((l) => fail('Response harus Right'), (r) {
      expect(r.code, 400);
      expect(r.status, 'error');
      expect(r.message, 'Username dan password wajib diisi');
    });

    verify(() => localDatasource.saveLoginStatus(false)).called(1);
  });

  test('Login OFFLINE berhasil', () async {
    const response = LoginResponseModel(
      code: 200,
      status: 'success',
      message: 'Login berhasil (Offline)',
    );

    when(
      () => offlineDatasource.loginUser('admin', 'admin123'),
    ).thenAnswer((_) async => response);
    when(() => networkInfo.isConnected).thenAnswer((_) async => false);
    when(() => localDatasource.saveLoginStatus(true)).thenAnswer((_) async {});

    final result = await repository.loginUser('admin', 'admin123');

    expect(result.isRight(), true);

    result.fold((l) => fail('Harusnya login offline berhasil'), (r) {
      expect(r.code, 200);
      expect(r.status, 'success');
      expect(r.message, 'Login berhasil (Offline)');
    });

    verify(() => localDatasource.saveLoginStatus(true)).called(1);
  });

  test('Login OFFLINE gagal (password salah)', () async {
    when(() => offlineDatasource.loginUser('admin', 'salah')).thenAnswer(
      (_) async => const LoginResponseModel(
        code: 401,
        status: 'error',
        message: 'Username atau password salah',
      ),
    );
    when(() => networkInfo.isConnected).thenAnswer((_) async => false);

    when(() => localDatasource.saveLoginStatus(false)).thenAnswer((_) async {});

    final result = await repository.loginUser('admin', 'salah');

    expect(result.isRight(), true);

    result.fold((l) => fail('Response harus Right'), (r) {
      expect(r.code, 401);
      expect(r.status, 'error');
      expect(r.message, 'Username atau password salah');
    });

    verify(() => localDatasource.saveLoginStatus(false)).called(1);
  });

  test('Login OFFLINE gagal (username & password kosong)', () async {
    when(() => offlineDatasource.loginUser('', '')).thenAnswer(
      (_) async => const LoginResponseModel(
        code: 400,
        status: 'error',
        message: 'Username dan password wajib diisi',
      ),
    );
    when(() => networkInfo.isConnected).thenAnswer((_) async => false);

    when(() => localDatasource.saveLoginStatus(false)).thenAnswer((_) async {});

    final result = await repository.loginUser('', '');

    expect(result.isRight(), true);

    result.fold((l) => fail('Response harus Right'), (r) {
      expect(r.code, 400);
      expect(r.status, 'error');
      expect(r.message, 'Username dan password wajib diisi');
    });

    verify(() => localDatasource.saveLoginStatus(false)).called(1);
  });

  test('Login lalu logout flow', () async {
    when(() => networkInfo.isConnected).thenAnswer((_) async => true);

    when(() => remoteDatasource.loginUser('admin', 'admin123')).thenAnswer(
      (_) async => const LoginResponseModel(
        code: 200,
        status: 'success',
        message: 'Login berhasil',
      ),
    );

    when(() => localDatasource.saveLoginStatus(true)).thenAnswer((_) async {});

    when(() => localDatasource.clearLoginStatus()).thenAnswer((_) async {});

    final loginResult = await repository.loginUser('admin', 'admin123');
    expect(loginResult.isRight(), true);

    final logoutResult = await repository.logout();
    expect(logoutResult.isRight(), true);

    verify(() => localDatasource.saveLoginStatus(true)).called(1);
    verify(() => localDatasource.clearLoginStatus()).called(1);
  });
}
