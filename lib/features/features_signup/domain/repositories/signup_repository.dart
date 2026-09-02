import '../entities/signup_params.dart';

abstract class SignupRepository {
  Future<void> signup(SignupParams params);
}