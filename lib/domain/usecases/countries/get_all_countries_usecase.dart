import 'package:flutter_practice13/domain/entities/country.dart';
import 'package:flutter_practice13/domain/repositories/countries_repository.dart';

class GetAllCountriesUseCase {
  final CountriesRepository _repository;

  GetAllCountriesUseCase(this._repository);

  Future<List<Country>> call() {
    return _repository.getAllCountries();
  }
}

