import 'package:flutter_practice13/domain/entities/country.dart';
import 'package:flutter_practice13/domain/repositories/countries_repository.dart';

class GetCountriesByRegionUseCase {
  final CountriesRepository _repository;

  GetCountriesByRegionUseCase(this._repository);

  Future<List<Country>> call(String region) {
    return _repository.getCountriesByRegion(region);
  }
}


