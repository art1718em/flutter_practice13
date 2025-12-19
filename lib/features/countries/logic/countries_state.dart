import 'package:equatable/equatable.dart';
import 'package:flutter_practice13/domain/entities/country.dart';

class CountriesState extends Equatable {
  final List<Country> countries;
  final bool isLoading;
  final String? error;
  final String? selectedRegion;

  const CountriesState({
    this.countries = const [],
    this.isLoading = false,
    this.error,
    this.selectedRegion,
  });

  CountriesState copyWith({
    List<Country>? countries,
    bool? isLoading,
    String? error,
    String? selectedRegion,
    bool clearSelectedRegion = false,
  }) {
    return CountriesState(
      countries: countries ?? this.countries,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      selectedRegion: clearSelectedRegion ? null : (selectedRegion ?? this.selectedRegion),
    );
  }

  @override
  List<Object?> get props => [countries, isLoading, error, selectedRegion];
}

