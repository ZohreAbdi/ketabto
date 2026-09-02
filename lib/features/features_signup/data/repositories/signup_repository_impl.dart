import 'package:ketabto_test/core/models/user_model.dart';
import 'package:ketabto_test/features/features_signup/data/data_source/signup_datasource.dart';
import '../../domain/entities/signup_params.dart';
import '../../domain/repositories/signup_repository.dart';

class SignupRepositoryImpl implements SignupRepository {
  final SignupRemoteDataSource remoteDataSource;

  SignupRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> signup(SignupParams params) async {
    final model = UserModel(
      name: params.name,
      phoneNumber: params.phoneNumber,
      email: params.email,
      password: params.password,
      token: '',
    );

    final result = await remoteDataSource.signup(model);

    if (result['success'] != true) {
      throw Exception(result['message']);
    }
  }
}
