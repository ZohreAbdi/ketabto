import 'package:ketabto_test/core/data_source/user_data_source.dart';
import 'package:ketabto_test/core/entities/user_entity.dart';

import '../../domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final UserLocalDataSource localDataSource;

  ProfileRepositoryImpl({
    required this.localDataSource,
  });

  @override
  Future<UserEntity> getProfile() async {
    final user = await localDataSource.getUser();

    if (user == null) {
      throw Exception('User not found.');
    }

    return user;
  }
}