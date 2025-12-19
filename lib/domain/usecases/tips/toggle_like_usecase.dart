import 'package:flutter_practice13/domain/repositories/tips_repository.dart';

class ToggleLikeUseCase {
  final TipsRepository repository;

  ToggleLikeUseCase(this.repository);

  Future<void> call(String id) {
    return repository.toggleLike(id);
  }
}

