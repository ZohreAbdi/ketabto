import 'package:ketabto_test/core/entities/user_entity.dart';

abstract class ProfileRepository {
  Future<UserEntity> getProfile();
}