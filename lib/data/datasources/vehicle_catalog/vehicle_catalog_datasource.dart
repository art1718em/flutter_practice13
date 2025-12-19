import 'package:flutter_practice13/core/api/nhtsa/nhtsa_api_client.dart';
import 'package:flutter_practice13/data/datasources/vehicle_catalog/vehicle_catalog_mapper.dart';
import 'package:flutter_practice13/domain/entities/vehicle_info.dart';

class VehicleCatalogDataSource {
  final NhtsaApiClient _apiClient;

  VehicleCatalogDataSource(this._apiClient);

  Future<List<VehicleMake>> getAllMakes() async {
    final response = await _apiClient.getAllMakes();
    return (response.results ?? [])
        .where((dto) => dto.makeId != null && dto.makeName != null)
        .map(VehicleCatalogMapper.makeToEntity)
        .toList();
  }

  Future<List<VehicleModel>> getModelsForMake(String makeName) async {
    final response = await _apiClient.getModelsForMake(makeName);
    return (response.results ?? [])
        .where((dto) =>
            dto.modelId != null &&
            dto.modelName != null &&
            dto.makeId != null &&
            dto.makeName != null)
        .map(VehicleCatalogMapper.modelToEntity)
        .toList();
  }

  Future<List<VehicleType>> getVehicleTypesForMake(String makeName) async {
    final response = await _apiClient.getVehicleTypesForMake(makeName);
    return (response.results ?? [])
        .where((dto) => dto.vehicleTypeId != null && dto.vehicleTypeName != null)
        .map(VehicleCatalogMapper.typeToEntity)
        .toList();
  }

  Future<List<VehicleVariable>> getVehicleVariableList() async {
    final response = await _apiClient.getVehicleVariableList();
    return (response.results ?? [])
        .where((dto) => dto.id != null && dto.name != null)
        .map(VehicleCatalogMapper.variableToEntity)
        .toList();
  }

  Future<List<VariableValue>> getVehicleVariableValuesList(String variableName) async {
    final response = await _apiClient.getVehicleVariableValuesList(variableName);
    return (response.results ?? [])
        .where((dto) => dto.name != null && dto.name!.isNotEmpty)
        .map(VehicleCatalogMapper.variableValueToEntity)
        .toList();
  }
}
