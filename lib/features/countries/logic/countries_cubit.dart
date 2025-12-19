import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_practice13/domain/usecases/countries/get_all_countries_usecase.dart';
import 'package:flutter_practice13/domain/usecases/countries/get_country_by_name_usecase.dart';
import 'package:flutter_practice13/domain/usecases/countries/get_country_by_code_usecase.dart';
import 'package:flutter_practice13/domain/usecases/countries/get_country_by_capital_usecase.dart';
import 'package:flutter_practice13/domain/usecases/countries/get_countries_by_region_usecase.dart';
import 'package:flutter_practice13/features/countries/logic/countries_state.dart';

class CountriesCubit extends Cubit<CountriesState> {
  final GetAllCountriesUseCase _getAllCountriesUseCase;
  final GetCountryByNameUseCase _getCountryByNameUseCase;
  final GetCountryByCodeUseCase _getCountryByCodeUseCase;
  final GetCountryByCapitalUseCase _getCountryByCapitalUseCase;
  final GetCountriesByRegionUseCase _getCountriesByRegionUseCase;

  CountriesCubit({
    required GetAllCountriesUseCase getAllCountriesUseCase,
    required GetCountryByNameUseCase getCountryByNameUseCase,
    required GetCountryByCodeUseCase getCountryByCodeUseCase,
    required GetCountryByCapitalUseCase getCountryByCapitalUseCase,
    required GetCountriesByRegionUseCase getCountriesByRegionUseCase,
  })  : _getAllCountriesUseCase = getAllCountriesUseCase,
        _getCountryByNameUseCase = getCountryByNameUseCase,
        _getCountryByCodeUseCase = getCountryByCodeUseCase,
        _getCountryByCapitalUseCase = getCountryByCapitalUseCase,
        _getCountriesByRegionUseCase = getCountriesByRegionUseCase,
        super(const CountriesState());

  Future<void> loadAllCountries() async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final countries = await _getAllCountriesUseCase();
      countries.sort((a, b) => a.name.compareTo(b.name));
      emit(state.copyWith(
        countries: countries,
        isLoading: false,
        selectedRegion: null,
      ));
    } catch (e) {
      print('CountriesCubit: Ошибка загрузки всех стран: $e');
      final errorMessage = e.toString().replaceAll('Exception: ', '').replaceAll('DioException', 'Ошибка сети');
      emit(state.copyWith(
        isLoading: false,
        error: 'Не удалось загрузить страны.\n$errorMessage',
      ));
    }
  }

  Future<void> searchCountryByName(String name) async {
    if (name.isEmpty) {
      emit(state.copyWith(
        countries: [],
        isLoading: false,
        selectedRegion: null,
      ));
      return;
    }

    emit(state.copyWith(isLoading: true, error: null));
    try {
      final countries = await _getCountryByNameUseCase(name);
      emit(state.copyWith(
        countries: countries,
        isLoading: false,
        selectedRegion: null,
      ));
    } catch (e) {
      print('CountriesCubit: Ошибка поиска по названию "$name": $e');
      emit(state.copyWith(
        isLoading: false,
        error: 'Страна не найдена',
      ));
    }
  }

  Future<void> searchCountryByCapital(String capital) async {
    if (capital.isEmpty) {
      emit(state.copyWith(
        countries: [],
        isLoading: false,
        selectedRegion: null,
      ));
      return;
    }

    emit(state.copyWith(isLoading: true, error: null));
    try {
      final countries = await _getCountryByCapitalUseCase(capital);
      emit(state.copyWith(
        countries: countries,
        isLoading: false,
        selectedRegion: null,
      ));
    } catch (e) {
      print('CountriesCubit: Ошибка поиска по столице "$capital": $e');
      emit(state.copyWith(
        isLoading: false,
        error: 'Страна со столицей "$capital" не найдена',
      ));
    }
  }

  Future<void> loadCountriesByRegion(String region) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final countries = await _getCountriesByRegionUseCase(region);
      countries.sort((a, b) => a.name.compareTo(b.name));
      emit(state.copyWith(
        countries: countries,
        isLoading: false,
        selectedRegion: region,
      ));
    } catch (e) {
      print('CountriesCubit: Ошибка загрузки стран региона $region: $e');
      final errorMessage = e.toString().replaceAll('Exception: ', '').replaceAll('DioException', 'Ошибка сети');
      emit(state.copyWith(
        isLoading: false,
        error: 'Не удалось загрузить страны региона.\n$errorMessage',
      ));
    }
  }
}

