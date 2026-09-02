import 'package:ketabto_test/core/data_source/user_data_source.dart';
import 'package:ketabto_test/core/entities/user_entity.dart';
import 'package:ketabto_test/features/features_login/data/data_source/login_datasource.dart';
import 'package:ketabto_test/features/features_login/domain/entities/login_params.dart';
import 'package:ketabto_test/features/features_login/domain/repositories/login_repository.dart';

class LoginRepositoryImpl implements LoginRepository {
  final LoginRemoteDataSource remoteDataSource;
  final UserLocalDataSource localDataSource;

  LoginRepositoryImpl(
    this.remoteDataSource,
    this.localDataSource,
  );

  @override
  Future<UserEntity> login(LoginParams params) async {
    final user = await remoteDataSource.login(
      params.email,
      params.password,
    );

    await localDataSource.saveUser(user);

    return user;
  }
}