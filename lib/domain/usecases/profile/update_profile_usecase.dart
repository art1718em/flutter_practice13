import 'package:flutter_practice13/core/models/user_profile_model.dart';
import 'package:flutter_practice13/domain/repositories/profile_repository.dart';

class UpdateProfileUseCase {
  final ProfileRepository repository;

  UpdateProfileUseCase(this.repository);

  Future<void> call(UserProfileModel profile) {
    return repository.updateProfile(profile);
  }
}

