import 'package:ketabto_test/features/feature_email_verify/domain/repositories/email_verify_repository.dart';

class ResendVerificationEmailUseCase {
  final EmailVerificationRepository repository;

  ResendVerificationEmailUseCase(this.repository);

  Future<void> call(String email) {
    return repository.resendVerificationEmail(email);
  }
}