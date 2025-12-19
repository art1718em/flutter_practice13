import 'package:flutter_practice13/core/models/app_settings_model.dart';
import 'package:flutter_practice13/data/datasources/settings/app_settings_dto.dart';

extension AppSettingsMapper on AppSettingsDto {
  AppSettingsModel toModel() {
    return AppSettingsModel(
      themeMode: AppThemeMode.values.firstWhere((e) => e.name == themeMode),
      currency: Currency.values.firstWhere((e) => e.name == currency),
      distanceUnit: DistanceUnit.values.firstWhere((e) => e.name == distanceUnit),
      notificationsEnabled: notificationsEnabled,
      autoBackup: autoBackup,
    );
  }
}

extension AppSettingsModelMapper on AppSettingsModel {
  AppSettingsDto toDto() {
    return AppSettingsDto(
      themeMode: themeMode.name,
      currency: currency.name,
      distanceUnit: distanceUnit.name,
      notificationsEnabled: notificationsEnabled,
      autoBackup: autoBackup,
    );
  }
}

