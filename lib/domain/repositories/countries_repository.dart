import 'package:flutter_practice13/domain/entities/country.dart';

abstract class CountriesRepository {
  Future<List<Country>> getAllCountries();
  Future<List<Country>> getCountryByName(String name);
  Future<Country> getCountryByCode(String code);
  Future<List<Country>> getCountryByCapital(String capital);
  Future<List<Country>> getCountriesByRegion(String region);
}

