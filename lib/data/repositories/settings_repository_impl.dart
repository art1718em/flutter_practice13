import 'package:flutter_practice13/core/models/app_settings_model.dart';
import 'package:flutter_practice13/data/datasources/settings/settings_local_datasource.dart';
import 'package:flutter_practice13/domain/repositories/settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDataSource localDataSource;

  SettingsRepositoryImpl(this.localDataSource);

  @override
  Future<AppSettingsModel> getSettings() {
    return localDataSource.getSettings();
  }

  @override
  Future<void> updateSettings(AppSettingsModel settings) {
    return localDataSource.updateSettings(settings);
  }
}

