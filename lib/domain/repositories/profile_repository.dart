import 'package:flutter_practice13/core/models/user_profile_model.dart';

abstract class ProfileRepository {
  Future<UserProfileModel?> getProfile();
  Future<void> updateProfile(UserProfileModel profile);
}

