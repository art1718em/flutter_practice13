import 'package:json_annotation/json_annotation.dart';

part 'countries_dto.g.dart';

@JsonSerializable()
class CountryNameDto {
  final String? common;
  final String? official;

  CountryNameDto({
    this.common,
    this.official,
  });

  factory CountryNameDto.fromJson(Map<String, dynamic> json) =>
      _$CountryNameDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CountryNameDtoToJson(this);
}

@JsonSerializable(explicitToJson: true)
class CountryDto {
  final CountryNameDto? name;
  
  @JsonKey(name: 'cca2')
  final String? countryCode;
  
  @JsonKey(name: 'cca3')
  final String? countryCode3;
  
  final dynamic capital;
  
  final String? region;
  
  final String? subregion;
  
  final dynamic timezones;
  
  final Map<String, dynamic>? currencies;
  
  final Map<String, dynamic>? languages;
  
  final dynamic borders;
  
  final Map<String, dynamic>? idd;
  
  final Map<String, dynamic>? flags;

  CountryDto({
    this.name,
    this.countryCode,
    this.countryCode3,
    this.capital,
    this.region,
    this.subregion,
    this.timezones,
    this.currencies,
    this.languages,
    this.borders,
    this.idd,
    this.flags,
  });

  factory CountryDto.fromJson(Map<String, dynamic> json) =>
      _$CountryDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CountryDtoToJson(this);
}

