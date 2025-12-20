class CountryLocalDto {
  final String countryCode;
  final String name;
  final String? officialName;
  final String? countryCode3;
  final String? capital;
  final String? region;
  final String? subregion;
  final String timezones;
  final String? currency;
  final String? currencySymbol;
  final String languages;
  final String borders;
  final String? phonePrefix;
  final String? flagUrl;
  final String cachedAt;

  CountryLocalDto({
    required this.countryCode,
    required this.name,
    this.officialName,
    this.countryCode3,
    this.capital,
    this.region,
    this.subregion,
    required this.timezones,
    this.currency,
    this.currencySymbol,
    required this.languages,
    required this.borders,
    this.phonePrefix,
    this.flagUrl,
    required this.cachedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'countryCode': countryCode,
      'name': name,
      'officialName': officialName,
      'countryCode3': countryCode3,
      'capital': capital,
      'region': region,
      'subregion': subregion,
      'timezones': timezones,
      'currency': currency,
      'currencySymbol': currencySymbol,
      'languages': languages,
      'borders': borders,
      'phonePrefix': phonePrefix,
      'flagUrl': flagUrl,
      'cachedAt': cachedAt,
    };
  }

  factory CountryLocalDto.fromMap(Map<String, dynamic> map) {
    return CountryLocalDto(
      countryCode: map['countryCode'] as String,
      name: map['name'] as String,
      officialName: map['officialName'] as String?,
      countryCode3: map['countryCode3'] as String?,
      capital: map['capital'] as String?,
      region: map['region'] as String?,
      subregion: map['subregion'] as String?,
      timezones: map['timezones'] as String,
      currency: map['currency'] as String?,
      currencySymbol: map['currencySymbol'] as String?,
      languages: map['languages'] as String,
      borders: map['borders'] as String,
      phonePrefix: map['phonePrefix'] as String?,
      flagUrl: map['flagUrl'] as String?,
      cachedAt: map['cachedAt'] as String,
    );
  }
}
