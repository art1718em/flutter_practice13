import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:flutter_practice13/data/datasources/remote/nhtsa/nhtsa_dto.dart';

part 'nhtsa_api_client.g.dart';

@RestApi(baseUrl: 'https://vpic.nhtsa.dot.gov/api/vehicles')
abstract class NhtsaApiClient {
  factory NhtsaApiClient(Dio dio, {String baseUrl}) = _NhtsaApiClient;

  @GET('/GetAllMakes?format=json')
  Future<MakesResponseDto> getAllMakes();

  @GET('/GetModelsForMake/{make}?format=json')
  Future<ModelsResponseDto> getModelsForMake(
    @Path('make') String make,
  );

  @GET('/DecodeVin/{vin}?format=json')
  Future<VinDecodeResponseDto> decodeVin(
    @Path('vin') String vin,
  );

  @GET('/GetVehicleTypesForMake/{make}?format=json')
  Future<VehicleTypesResponseDto> getVehicleTypesForMake(
    @Path('make') String make,
  );
}



