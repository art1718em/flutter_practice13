import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:flutter_practice13/data/datasources/remote/nhtsa/nhtsa_dto.dart';

part 'nhtsa_api_client.g.dart';

@RestApi(baseUrl: 'https://vpic.nhtsa.dot.gov/api/vehicles')
abstract class NhtsaApiClient {
  factory NhtsaApiClient(Dio dio, {String baseUrl}) = _NhtsaApiClient;

  @GET('/GetAllMakes?format=json')
  Future<MakesResponseDto> getAllMakes();

  @GET('/GetModelsForMake/{makeName}?format=json')
  Future<ModelsResponseDto> getModelsForMake(
    @Path('makeName') String makeName,
  );

  @GET('/GetVehicleTypesForMake/{makeName}?format=json')
  Future<VehicleTypesResponseDto> getVehicleTypesForMake(
    @Path('makeName') String makeName,
  );

  @GET('/GetVehicleVariableList?format=json')
  Future<VehicleVariableListResponseDto> getVehicleVariableList();

  @GET('/GetVehicleVariableValuesList/{variableName}?format=json')
  Future<VehicleVariableValuesResponseDto> getVehicleVariableValuesList(
    @Path('variableName') String variableName,
  );
}
