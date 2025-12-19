import 'package:flutter_practice13/core/models/app_settings_model.dart';
import 'package:flutter_practice13/domain/repositories/settings_repository.dart';

class UpdateSettingsUseCase {
  final SettingsRepository repository;

  UpdateSettingsUseCase(this.repository);

  Future<void> call(AppSettingsModel settings) {
    return repository.updateSettings(settings);
  }
}

