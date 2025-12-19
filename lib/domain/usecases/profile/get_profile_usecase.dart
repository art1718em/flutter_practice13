import 'package:flutter_practice13/core/models/user_profile_model.dart';
import 'package:flutter_practice13/domain/repositories/profile_repository.dart';

class GetProfileUseCase {
  final ProfileRepository repository;

  GetProfileUseCase(this.repository);

  Future<UserProfileModel?> call() {
    return repository.getProfile();
  }
}

