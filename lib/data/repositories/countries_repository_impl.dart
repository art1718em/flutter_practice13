
import 'package:flutter_practice13/domain/entities/country.dart';
import 'package:flutter_practice13/domain/repositories/countries_repository.dart';

import '../datasources/countries/countries_datasource.dart';

class CountriesRepositoryImpl implements CountriesRepository {
  final CountriesDataSource _dataSource;

  CountriesRepositoryImpl(this._dataSource);

  @override
  Future<List<Country>> getAllCountries() async {
    return _dataSource.getAllCountries();
  }

  @override
  Future<List<Country>> getCountryByName(String name) async {
    return _dataSource.getCountryByName(name);
  }

  @override
  Future<Country> getCountryByCode(String code) async {
    return _dataSource.getCountryByCode(code);
  }

  @override
  Future<List<Country>> getCountryByCapital(String capital) async {
    return _dataSource.getCountryByCapital(capital);
  }

  @override
  Future<List<Country>> getCountriesByRegion(String region) async {
    return _dataSource.getCountriesByRegion(region);
  }
}

