import 'package:flutter_practice13/core/models/user_model.dart';
import 'package:flutter_practice13/domain/repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<UserModel> call(String email, String password, String name) {
    return repository.register(email, password, name);
  }
}

