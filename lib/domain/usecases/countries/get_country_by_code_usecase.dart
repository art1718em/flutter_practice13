import 'package:flutter_practice13/domain/entities/country.dart';
import 'package:flutter_practice13/domain/repositories/countries_repository.dart';

class GetCountryByCodeUseCase {
  final CountriesRepository _repository;

  GetCountryByCodeUseCase(this._repository);

  Future<Country> call(String code) {
    return _repository.getCountryByCode(code);
  }
}


