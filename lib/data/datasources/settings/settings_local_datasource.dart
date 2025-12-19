import 'package:flutter_practice13/core/models/app_settings_model.dart';
import 'package:flutter_practice13/core/storage/preferences_helper.dart';
import 'package:flutter_practice13/data/datasources/settings/app_settings_dto.dart';
import 'package:flutter_practice13/data/datasources/settings/app_settings_mapper.dart';

class SettingsLocalDataSource {
  final PreferencesHelper _prefsHelper;

  SettingsLocalDataSource(this._prefsHelper);

  Future<AppSettingsModel> getSettings() async {
    final dto = AppSettingsDto(
      themeMode: _prefsHelper.getThemeMode(),
      currency: _prefsHelper.getCurrency(),
      distanceUnit: _prefsHelper.getDistanceUnit(),
      notificationsEnabled: _prefsHelper.getNotificationsEnabled(),
      autoBackup: _prefsHelper.getAutoBackup(),
    );

    return dto.toModel();
  }

  Future<void> updateSettings(AppSettingsModel settings) async {
    final dto = settings.toDto();

    await _prefsHelper.setThemeMode(dto.themeMode);
    await _prefsHelper.setCurrency(dto.currency);
    await _prefsHelper.setDistanceUnit(dto.distanceUnit);
    await _prefsHelper.setNotificationsEnabled(dto.notificationsEnabled);
    await _prefsHelper.setAutoBackup(dto.autoBackup);
  }
}

