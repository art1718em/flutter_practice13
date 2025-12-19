import 'package:flutter_practice13/core/api/countries/countries_api_client.dart';
import 'package:flutter_practice13/data/datasources/countries/countries_mapper.dart';
import 'package:flutter_practice13/domain/entities/country.dart';

class CountriesDataSource {
  final CountriesApiClient _apiClient;

  CountriesDataSource(this._apiClient);

  Future<List<Country>> getAllCountries() async {
    final response = await _apiClient.getAllCountries();
    return response.map(CountriesMapper.toEntity).toList();
  }

  Future<List<Country>> getCountryByName(String name) async {
    final response = await _apiClient.getCountryByName(name);
    return response.map(CountriesMapper.toEntity).toList();
  }

  Future<Country> getCountryByCode(String code) async {
    final response = await _apiClient.getCountryByCode(code);
    return CountriesMapper.toEntity(response);
  }

  Future<List<Country>> getCountryByCapital(String capital) async {
    final response = await _apiClient.getCountryByCapital(capital);
    return response.map(CountriesMapper.toEntity).toList();
  }

  Future<List<Country>> getCountriesByRegion(String region) async {
    final response = await _apiClient.getCountriesByRegion(region);
    return response.map(CountriesMapper.toEntity).toList();
  }
}
