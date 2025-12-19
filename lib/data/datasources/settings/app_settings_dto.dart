class AppSettingsDto {
  final String themeMode;
  final String currency;
  final String distanceUnit;
  final bool notificationsEnabled;
  final bool autoBackup;

  AppSettingsDto({
    required this.themeMode,
    required this.currency,
    required this.distanceUnit,
    required this.notificationsEnabled,
    required this.autoBackup,
  });

  Map<String, dynamic> toJson() => {
    'themeMode': themeMode,
    'currency': currency,
    'distanceUnit': distanceUnit,
    'notificationsEnabled': notificationsEnabled,
    'autoBackup': autoBackup,
  };

  factory AppSettingsDto.fromJson(Map<String, dynamic> json) => AppSettingsDto(
    themeMode: json['themeMode'] as String,
    currency: json['currency'] as String,
    distanceUnit: json['distanceUnit'] as String,
    notificationsEnabled: json['notificationsEnabled'] as bool,
    autoBackup: json['autoBackup'] as bool,
  );
}
