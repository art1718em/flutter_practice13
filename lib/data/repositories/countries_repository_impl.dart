import 'package:flutter_practice13/domain/entities/country.dart';
import 'package:flutter_practice13/domain/repositories/countries_repository.dart';

import '../datasources/countries/countries_datasource.dart';
import '../datasources/countries/countries_local_datasource.dart';

class CountriesRepositoryImpl implements CountriesRepository {
  final CountriesDataSource _remoteDataSource;
  final CountriesLocalDataSource _localDataSource;

  CountriesRepositoryImpl(this._remoteDataSource, this._localDataSource);

  @override
  Future<List<Country>> getAllCountries() async {
    try {
      final countries = await _remoteDataSource.getAllCountries();
      await _localDataSource.cacheCountries(countries);
      return countries;
    } catch (e) {
      final cachedCountries = await _localDataSource.getCachedCountries();
      if (cachedCountries.isEmpty) {
        rethrow;
      }
      return cachedCountries;
    }
  }

  @override
  Future<List<Country>> getCountryByName(String name) async {
    return _remoteDataSource.getCountryByName(name);
  }

  @override
  Future<Country> getCountryByCode(String code) async {
    try {
      return await _remoteDataSource.getCountryByCode(code);
    } catch (e) {
      final cachedCountry = await _localDataSource.getCachedCountryByCode(code);
      if (cachedCountry == null) {
        rethrow;
      }
      return cachedCountry;
    }
  }

  @override
  Future<List<Country>> getCountryByCapital(String capital) async {
    return _remoteDataSource.getCountryByCapital(capital);
  }

  @override
  Future<List<Country>> getCountriesByRegion(String region) async {
    return _remoteDataSource.getCountriesByRegion(region);
  }
}

