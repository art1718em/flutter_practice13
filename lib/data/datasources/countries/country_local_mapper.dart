import 'dart:convert';
import 'package:flutter_practice13/domain/entities/country.dart';
import 'country_local_dto.dart';

class CountryLocalMapper {
  static CountryLocalDto toDto(Country country) {
    return CountryLocalDto(
      countryCode: country.countryCode ?? '',
      name: country.name,
      officialName: country.officialName,
      countryCode3: country.countryCode3,
      capital: country.capital,
      region: country.region,
      subregion: country.subregion,
      timezones: jsonEncode(country.timezones),
      currency: country.currency,
      currencySymbol: country.currencySymbol,
      languages: jsonEncode(country.languages),
      borders: jsonEncode(country.borders),
      phonePrefix: country.phonePrefix,
      flagUrl: country.flagUrl,
      cachedAt: DateTime.now().toIso8601String(),
    );
  }

  static Country toEntity(CountryLocalDto dto) {
    return Country(
      name: dto.name,
      officialName: dto.officialName,
      countryCode: dto.countryCode,
      countryCode3: dto.countryCode3,
      capital: dto.capital,
      region: dto.region,
      subregion: dto.subregion,
      timezones: _decodeList(dto.timezones),
      currency: dto.currency,
      currencySymbol: dto.currencySymbol,
      languages: _decodeList(dto.languages),
      borders: _decodeList(dto.borders),
      phonePrefix: dto.phonePrefix,
      flagUrl: dto.flagUrl,
    );
  }

  static List<String> _decodeList(String jsonString) {
    try {
      final decoded = jsonDecode(jsonString);
      if (decoded is List) {
        return decoded.map((e) => e.toString()).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}
