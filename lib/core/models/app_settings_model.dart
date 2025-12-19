import 'package:equatable/equatable.dart';

enum AppThemeMode {
  light,
  dark,
  system,
}

enum Currency {
  rub,
  usd,
  eur,
}

enum DistanceUnit {
  kilometers,
  miles,
}

extension AppThemeModeExtension on AppThemeMode {
  String get displayName {
    switch (this) {
      case AppThemeMode.light:
        return 'Светлая';
      case AppThemeMode.dark:
        return 'Темная';
      case AppThemeMode.system:
        return 'Системная';
    }
  }
}

extension CurrencyExtension on Currency {
  String get displayName {
    switch (this) {
      case Currency.rub:
        return 'Рубль (₽)';
      case Currency.usd:
        return 'Доллар (\$)';
      case Currency.eur:
        return 'Евро (€)';
    }
  }

  String get symbol {
    switch (this) {
      case Currency.rub:
        return '₽';
      case Currency.usd:
        return '\$';
      case Currency.eur:
        return '€';
    }
  }
}

extension DistanceUnitExtension on DistanceUnit {
  String get displayName {
    switch (this) {
      case DistanceUnit.kilometers:
        return 'Километры (км)';
      case DistanceUnit.miles:
        return 'Мили (mi)';
    }
  }

  String get abbreviation {
    switch (this) {
      case DistanceUnit.kilometers:
        return 'км';
      case DistanceUnit.miles:
        return 'mi';
    }
  }
}

class AppSettingsModel extends Equatable {
  final AppThemeMode themeMode;
  final Currency currency;
  final DistanceUnit distanceUnit;
  final bool notificationsEnabled;
  final bool autoBackup;

  const AppSettingsModel({
    this.themeMode = AppThemeMode.system,
    this.currency = Currency.rub,
    this.distanceUnit = DistanceUnit.kilometers,
    this.notificationsEnabled = true,
    this.autoBackup = false,
  });

  AppSettingsModel copyWith({
    AppThemeMode? themeMode,
    Currency? currency,
    DistanceUnit? distanceUnit,
    bool? notificationsEnabled,
    bool? autoBackup,
  }) {
    return AppSettingsModel(
      themeMode: themeMode ?? this.themeMode,
      currency: currency ?? this.currency,
      distanceUnit: distanceUnit ?? this.distanceUnit,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      autoBackup: autoBackup ?? this.autoBackup,
    );
  }

  @override
  List<Object?> get props => [
        themeMode,
        currency,
        distanceUnit,
        notificationsEnabled,
        autoBackup,
      ];
}
