abstract class EmailVerificationRepository {
  Future<void> resendVerificationEmail(String email);
}