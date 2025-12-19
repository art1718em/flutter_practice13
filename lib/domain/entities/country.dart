import 'package:equatable/equatable.dart';

class Country extends Equatable {
  final String name;
  final String? officialName;
  final String? countryCode;
  final String? countryCode3;
  final String? capital;
  final String? region;
  final String? subregion;
  final List<String> timezones;
  final String? currency;
  final String? currencySymbol;
  final List<String> languages;
  final List<String> borders;
  final String? phonePrefix;
  final String? flagUrl;

  const Country({
    required this.name,
    this.officialName,
    this.countryCode,
    this.countryCode3,
    this.capital,
    this.region,
    this.subregion,
    this.timezones = const [],
    this.currency,
    this.currencySymbol,
    this.languages = const [],
    this.borders = const [],
    this.phonePrefix,
    this.flagUrl,
  });

  @override
  List<Object?> get props => [
        name,
        officialName,
        countryCode,
        countryCode3,
        capital,
        region,
        subregion,
        timezones,
        currency,
        currencySymbol,
        languages,
        borders,
        phonePrefix,
        flagUrl,
      ];
}

