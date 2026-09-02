import 'package:ketabto_test/core/entities/user_entity.dart';
import 'package:ketabto_test/features/features_login/domain/entities/login_params.dart';

abstract class LoginRepository {
  Future<UserEntity> login(LoginParams params);
}
