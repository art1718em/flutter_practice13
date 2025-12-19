import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_practice13/domain/usecases/countries/get_country_by_code_usecase.dart';
import 'package:flutter_practice13/features/countries/logic/country_details_state.dart';

class CountryDetailsCubit extends Cubit<CountryDetailsState> {
  final GetCountryByCodeUseCase _getCountryByCodeUseCase;

  CountryDetailsCubit({
    required GetCountryByCodeUseCase getCountryByCodeUseCase,
  })  : _getCountryByCodeUseCase = getCountryByCodeUseCase,
        super(const CountryDetailsState());

  Future<void> loadCountry(String countryCode) async {
    if (countryCode.isEmpty) {
      emit(state.copyWith(
        isLoading: false,
        error: 'Неверный код страны',
      ));
      return;
    }

    emit(state.copyWith(isLoading: true, error: null));

    try {
      final country = await _getCountryByCodeUseCase(countryCode);
      emit(state.copyWith(
        country: country,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''),
      ));
    }
  }
}
