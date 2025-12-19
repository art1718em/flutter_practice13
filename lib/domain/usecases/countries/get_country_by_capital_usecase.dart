import 'package:flutter_practice13/domain/entities/country.dart';
import 'package:flutter_practice13/domain/repositories/countries_repository.dart';

class GetCountryByCapitalUseCase {
  final CountriesRepository _repository;

  GetCountryByCapitalUseCase(this._repository);

  Future<List<Country>> call(String capital) {
    return _repository.getCountryByCapital(capital);
  }
}

