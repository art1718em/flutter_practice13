import 'package:flutter_practice13/core/models/user_model.dart';
import 'package:flutter_practice13/domain/repositories/auth_repository.dart';

class GetCurrentUserUseCase {
  final AuthRepository repository;

  GetCurrentUserUseCase(this.repository);

  Future<UserModel?> call() async {
    return await repository.getCurrentUser();
  }
}

