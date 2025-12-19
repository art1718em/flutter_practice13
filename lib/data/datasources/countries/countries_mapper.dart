import 'package:flutter_practice13/core/api/countries/countries_dto.dart';
import 'package:flutter_practice13/domain/entities/country.dart';

class CountriesMapper {
  static Country toEntity(CountryDto dto) {
    String? currency;
    String? currencySymbol;
    if (dto.currencies != null && dto.currencies!.isNotEmpty) {
      try {
        final firstCurrency = dto.currencies!.values.first;
        if (firstCurrency is Map) {
          currency = firstCurrency['name'] as String?;
          currencySymbol = firstCurrency['symbol'] as String?;
        }
      } catch (_) {}
    }

    final languages = dto.languages?.values.map((e) => e.toString()).toList() ?? [];

    String? phonePrefix;
    if (dto.idd != null) {
      try {
        final root = dto.idd!['root'] as String?;
        final suffixesRaw = dto.idd!['suffixes'];
        List? suffixes;
        
        if (suffixesRaw is List) {
          suffixes = suffixesRaw;
        } else if (suffixesRaw is String) {
          suffixes = [suffixesRaw];
        }
        
        if (root != null && suffixes != null && suffixes.isNotEmpty) {
          phonePrefix = '$root${suffixes[0]}';
        }
      } catch (_) {}
    }

    String? capital;
    if (dto.capital != null) {
      try {
        if (dto.capital is List && (dto.capital as List).isNotEmpty) {
          capital = (dto.capital as List).first.toString();
        } else if (dto.capital is String) {
          capital = dto.capital as String;
        }
      } catch (_) {}
    }

    List<String> timezones = [];
    if (dto.timezones != null) {
      try {
        if (dto.timezones is List) {
          timezones = (dto.timezones as List).map((e) => e.toString()).toList();
        }
      } catch (_) {}
    }

    List<String> borders = [];
    if (dto.borders != null) {
      try {
        if (dto.borders is List) {
          borders = (dto.borders as List).map((e) => e.toString()).toList();
        }
      } catch (_) {}
    }

    return Country(
      name: dto.name?.common ?? '',
      officialName: dto.name?.official,
      countryCode: dto.countryCode,
      countryCode3: dto.countryCode3,
      capital: capital,
      region: dto.region,
      subregion: dto.subregion,
      timezones: timezones,
      currency: currency,
      currencySymbol: currencySymbol,
      languages: languages,
      borders: borders,
      phonePrefix: phonePrefix,
      flagUrl: dto.flags?['png'] as String?,
    );
  }
}
