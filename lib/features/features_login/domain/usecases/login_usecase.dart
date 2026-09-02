import 'package:ketabto_test/core/entities/user_entity.dart';
import 'package:ketabto_test/features/features_login/domain/entities/login_params.dart';
import 'package:ketabto_test/features/features_login/domain/repositories/login_repository.dart';

class LoginUseCase {
  final LoginRepository repository;

  LoginUseCase(this.repository);

  Future<UserEntity> call(
  LoginParams params,
) {
  return repository.login(params);
}
}