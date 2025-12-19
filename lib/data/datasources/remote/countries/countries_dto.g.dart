part of 'countries_dto.dart';

CountryNameDto _$CountryNameDtoFromJson(Map<String, dynamic> json) =>
    CountryNameDto(
      common: json['common'] as String?,
      official: json['official'] as String?,
    );

Map<String, dynamic> _$CountryNameDtoToJson(CountryNameDto instance) =>
    <String, dynamic>{
      'common': instance.common,
      'official': instance.official,
    };

CountryDto _$CountryDtoFromJson(Map<String, dynamic> json) => CountryDto(
      name: json['name'] == null
          ? null
          : CountryNameDto.fromJson(json['name'] as Map<String, dynamic>),
      countryCode: json['cca2'] as String?,
      countryCode3: json['cca3'] as String?,
      capital: json['capital'],
      region: json['region'] as String?,
      subregion: json['subregion'] as String?,
      timezones: json['timezones'],
      currencies: json['currencies'] as Map<String, dynamic>?,
      languages: json['languages'] as Map<String, dynamic>?,
      borders: json['borders'],
      idd: json['idd'] as Map<String, dynamic>?,
      flags: json['flags'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$CountryDtoToJson(CountryDto instance) =>
    <String, dynamic>{
      'name': instance.name?.toJson(),
      'cca2': instance.countryCode,
      'cca3': instance.countryCode3,
      'capital': instance.capital,
      'region': instance.region,
      'subregion': instance.subregion,
      'timezones': instance.timezones,
      'currencies': instance.currencies,
      'languages': instance.languages,
      'borders': instance.borders,
      'idd': instance.idd,
      'flags': instance.flags,
    };

