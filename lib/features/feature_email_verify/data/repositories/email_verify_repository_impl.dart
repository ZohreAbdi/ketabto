import 'package:ketabto_test/features/feature_email_verify/data/data_source/email_verify_datasource.dart';
import 'package:ketabto_test/features/feature_email_verify/domain/repositories/email_verify_repository.dart';


class EmailVerificationRepositoryImpl
    implements EmailVerificationRepository {
  final EmailVerificationRemoteDataSource remoteDataSource;

  EmailVerificationRepositoryImpl(this.remoteDataSource);



  @override
  Future<void> resendVerificationEmail(String email) {
    return remoteDataSource.resendVerificationEmail(email);
  }
}