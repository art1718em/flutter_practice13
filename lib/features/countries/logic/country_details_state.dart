import 'package:equatable/equatable.dart';
import 'package:flutter_practice13/domain/entities/country.dart';

class CountryDetailsState extends Equatable {
  final Country? country;
  final bool isLoading;
  final String? error;

  const CountryDetailsState({
    this.country,
    this.isLoading = false,
    this.error,
  });

  CountryDetailsState copyWith({
    Country? country,
    bool? isLoading,
    String? error,
  }) {
    return CountryDetailsState(
      country: country ?? this.country,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [country, isLoading, error];
}
