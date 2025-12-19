import 'package:flutter_practice13/data/datasources/remote/countries/countries_api_client.dart';
import 'package:flutter_practice13/data/datasources/remote/countries/countries_dto.dart';
import 'package:flutter_practice13/domain/entities/country.dart';
import 'package:flutter_practice13/domain/repositories/countries_repository.dart';

class CountriesRepositoryImpl implements CountriesRepository {
  final CountriesApiClient _apiClient;

  CountriesRepositoryImpl(this._apiClient);

  Country _mapDtoToEntity(CountryDto dto) {
    // Парсинг валюты
    String? currency;
    String? currencySymbol;
    if (dto.currencies != null && dto.currencies!.isNotEmpty) {
      try {
        final firstCurrency = dto.currencies!.values.first;
        if (firstCurrency is Map) {
          currency = firstCurrency['name'] as String?;
          currencySymbol = firstCurrency['symbol'] as String?;
        }
      } catch (e) {
        print('Ошибка при парсинге валюты: $e');
      }
    }

    // Парсинг языков
    final languages = dto.languages?.values.map((e) => e.toString()).toList() ?? [];

    // Парсинг телефонного префикса
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
      } catch (e) {
        print('Ошибка при парсинге телефонного префикса: $e');
      }
    }

    // Парсинг столицы
    String? capital;
    if (dto.capital != null) {
      try {
        if (dto.capital is List && (dto.capital as List).isNotEmpty) {
          capital = (dto.capital as List).first.toString();
        } else if (dto.capital is String) {
          capital = dto.capital as String;
        }
      } catch (e) {
        print('Ошибка при парсинге столицы: $e');
      }
    }

    // Парсинг часовых поясов
    List<String> timezones = [];
    if (dto.timezones != null) {
      try {
        if (dto.timezones is List) {
          timezones = (dto.timezones as List).map((e) => e.toString()).toList();
        }
      } catch (e) {
        print('Ошибка при парсинге часовых поясов: $e');
      }
    }

    // Парсинг границ
    List<String> borders = [];
    if (dto.borders != null) {
      try {
        if (dto.borders is List) {
          borders = (dto.borders as List).map((e) => e.toString()).toList();
        }
      } catch (e) {
        print('Ошибка при парсинге границ: $e');
      }
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

  @override
  Future<List<Country>> getAllCountries() async {
    try {
      final response = await _apiClient.getAllCountries();
      return response.map(_mapDtoToEntity).toList();
    } catch (e) {
      print('Ошибка при загрузке списка стран: $e');
      rethrow;
    }
  }

  @override
  Future<List<Country>> getCountryByName(String name) async {
    try {
      final response = await _apiClient.getCountryByName(name);
      return response.map(_mapDtoToEntity).toList();
    } catch (e) {
      print('Ошибка при поиске страны по имени "$name": $e');
      rethrow;
    }
  }

  @override
  Future<Country> getCountryByCode(String code) async {
    try {
      final response = await _apiClient.getCountryByCode(code);
      return _mapDtoToEntity(response);
    } catch (e) {
      print('Ошибка при загрузке страны по коду "$code": $e');
      rethrow;
    }
  }

  @override
  Future<List<Country>> getCountryByCapital(String capital) async {
    try {
      final response = await _apiClient.getCountryByCapital(capital);
      return response.map(_mapDtoToEntity).toList();
    } catch (e) {
      print('Ошибка при поиске страны по столице "$capital": $e');
      rethrow;
    }
  }

  @override
  Future<List<Country>> getCountriesByRegion(String region) async {
    try {
      final response = await _apiClient.getCountriesByRegion(region);
      return response.map(_mapDtoToEntity).toList();
    } catch (e) {
      print('Ошибка при загрузке стран региона "$region": $e');
      rethrow;
    }
  }
}

