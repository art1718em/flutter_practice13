import 'package:flutter_practice13/domain/entities/country.dart';
import 'package:flutter_practice13/domain/repositories/countries_repository.dart';

class GetCountryByNameUseCase {
  final CountriesRepository _repository;

  GetCountryByNameUseCase(this._repository);

  Future<List<Country>> call(String name) {
    return _repository.getCountryByName(name);
  }
}

