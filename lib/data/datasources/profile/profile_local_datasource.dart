import 'package:flutter_practice13/core/models/user_profile_model.dart';
import 'package:flutter_practice13/core/storage/secure_storage_helper.dart';
import 'package:flutter_practice13/data/datasources/profile/user_profile_dto.dart';
import 'package:flutter_practice13/data/datasources/profile/user_profile_mapper.dart';

class ProfileLocalDataSource {
  final SecureStorageHelper _secureStorage;

  ProfileLocalDataSource(this._secureStorage);

  Future<UserProfileModel?> getProfile() async {
    final userId = await _secureStorage.getUserId();
    final email = await _secureStorage.getUserEmail();
    final name = await _secureStorage.getUserName();

    if (userId == null || email == null || name == null) {
      return null;
    }

    final profile = UserProfileModel(
      userId: userId,
      name: name,
      email: email,
      avatar: 'https://ui-avatars.com/api/?name=$name&size=200&background=random',
    );

    return profile;
  }

  Future<void> updateProfile(UserProfileModel profile) async {
    await _secureStorage.saveUserName(profile.name);
  }
}

