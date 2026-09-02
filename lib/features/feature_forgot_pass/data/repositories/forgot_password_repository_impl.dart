import 'package:ketabto_test/features/feature_forgot_pass/data/data_source/forgot_password_datasource.dart';
import 'package:ketabto_test/features/feature_forgot_pass/domain/repositories/forgot_password_repository.dart';

class ForgotPasswordRepositoryImpl
    implements ForgotPasswordRepository {

  final ForgotPasswordRemoteDataSource remote;

  ForgotPasswordRepositoryImpl(this.remote);

  @override
  Future<void> forgotPassword(String email) {
    return remote.forgotPassword(email);
  }
}