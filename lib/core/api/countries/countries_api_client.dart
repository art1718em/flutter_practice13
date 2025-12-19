import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'countries_dto.dart';

part 'countries_api_client.g.dart';

@RestApi(baseUrl: 'https://restcountries.com/v3.1')
abstract class CountriesApiClient {
  factory CountriesApiClient(Dio dio, {String baseUrl}) = _CountriesApiClient;

  static const String _fields = 'name,cca2,cca3,capital,region,currencies,languages,borders,idd,flags';

  @GET('/all')
  Future<List<CountryDto>> getAllCountries({
    @Query('fields') String fields = _fields,
  });

  @GET('/name/{name}')
  Future<List<CountryDto>> getCountryByName(
    @Path('name') String name, {
    @Query('fields') String fields = _fields,
  });

  @GET('/alpha/{code}')
  Future<CountryDto> getCountryByCode(
    @Path('code') String code, {
    @Query('fields') String fields = _fields,
  });

  @GET('/capital/{capital}')
  Future<List<CountryDto>> getCountryByCapital(
    @Path('capital') String capital, {
    @Query('fields') String fields = _fields,
  });

  @GET('/region/{region}')
  Future<List<CountryDto>> getCountriesByRegion(
    @Path('region') String region, {
    @Query('fields') String fields = _fields,
  });
}

