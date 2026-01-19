import 'package:dartz/dartz.dart';
import 'package:student_app/core/error/failure.dart';
import 'package:student_app/core/network/network_info_impl.dart';
import 'package:student_app/features/login/data/datasources/local_datasource.dart';
import 'package:student_app/features/login/data/datasources/offline_datasource.dart';
import 'package:student_app/features/login/data/datasources/remote_datasource.dart';
import 'package:student_app/features/login/data/models/login_response_model.dart';
import 'package:student_app/features/login/domain/entities/login_response.dart';
import 'package:student_app/features/login/domain/repositories/login_repository.dart';

class LoginRepositoryImplementation implements LoginRepository {
  final RemoteDatasource remoteDatasource;
  final OfflineDatasource offlineDatasource;
  final LocalDatasource localDataSource;
  final NetworkInfo networkInfo;

  LoginRepositoryImplementation({
    required this.remoteDatasource,
    required this.offlineDatasource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, LoginResponse>> loginUser(
    String username,
    String password,
  ) async {
    try {
      if (await networkInfo.isConnected) {
        LoginResponseModel hasil = await remoteDatasource.loginUser(
          username,
          password,
        );
        await localDataSource.saveLoginStatus(hasil.code == 200);
        return Right(hasil);
      } else {
        LoginResponseModel hasil = await offlineDatasource.loginUser(
          username,
          password,
        );
        await localDataSource.saveLoginStatus(hasil.code == 200);
        return Right(hasil.toEntity());
      }
    } catch (e) {
      return Left(AuthFailure('Gagal melakukan login'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await localDataSource.clearLoginStatus();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Gagal logout'));
    }
  }

  @override
  Future<Either<Failure, bool>> checkLoginStatus() async {
    try {
      final bool isLoggedIn = await localDataSource.getLoginStatus();
      return Right(isLoggedIn);
    } catch (e) {
      return Left(CacheFailure());
    }
  }
}
