import 'package:flutter_practice13/core/models/user_profile_model.dart';
import 'package:flutter_practice13/data/datasources/profile/profile_local_datasource.dart';
import 'package:flutter_practice13/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileLocalDataSource localDataSource;

  ProfileRepositoryImpl(this.localDataSource);

  @override
  Future<UserProfileModel?> getProfile() {
    return localDataSource.getProfile();
  }

  @override
  Future<void> updateProfile(UserProfileModel profile) {
    return localDataSource.updateProfile(profile);
  }
}

