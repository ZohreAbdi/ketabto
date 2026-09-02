import '../entities/signup_params.dart';
import '../repositories/signup_repository.dart';

class SignupUseCase {
  final SignupRepository repository;

  SignupUseCase(this.repository);

  Future<void> call(SignupParams params) {
    return repository.signup(params);
  }
}