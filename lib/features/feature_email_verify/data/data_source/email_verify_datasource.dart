abstract class EmailVerificationRemoteDataSource {
  Future<void> resendVerificationEmail(String email);
}