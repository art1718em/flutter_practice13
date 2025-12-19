import 'package:flutter_practice13/data/datasources/remote/nhtsa/nhtsa_api_client.dart';
import 'package:flutter_practice13/domain/entities/vehicle_info.dart';
import 'package:flutter_practice13/domain/repositories/vehicle_catalog_repository.dart';

class VehicleCatalogRepositoryImpl implements VehicleCatalogRepository {
  final NhtsaApiClient _apiClient;

  VehicleCatalogRepositoryImpl(this._apiClient);

  @override
  Future<List<VehicleMake>> getAllMakes() async {
    try {
      final response = await _apiClient.getAllMakes();
      return (response.results ?? [])
          .where((dto) => dto.makeId != null && dto.makeName != null)
          .map((dto) => VehicleMake(
                id: dto.makeId!,
                name: dto.makeName!,
                manufacturerName: dto.mfrName,
                manufacturerId: dto.mfrId,
              ))
          .toList();
    } catch (e) {
      throw Exception('Не удалось загрузить марки автомобилей: $e');
    }
  }

  @override
  Future<List<VehicleModel>> getModelsForMake(String makeName) async {
    try {
      final response = await _apiClient.getModelsForMake(makeName);
      return (response.results ?? [])
          .where((dto) =>
              dto.modelId != null &&
              dto.modelName != null &&
              dto.makeId != null &&
              dto.makeName != null)
          .map((dto) => VehicleModel(
                id: dto.modelId!,
                name: dto.modelName!,
                makeId: dto.makeId!,
                makeName: dto.makeName!,
              ))
          .toList();
    } catch (e) {
      throw Exception('Не удалось загрузить модели для марки $makeName: $e');
    }
  }

  @override
  Future<List<VehicleType>> getVehicleTypesForMake(String makeName) async {
    try {
      final response = await _apiClient.getVehicleTypesForMake(makeName);
      return (response.results ?? [])
          .where((dto) => dto.vehicleTypeId != null && dto.vehicleTypeName != null)
          .map((dto) => VehicleType(
                id: dto.vehicleTypeId!,
                name: dto.vehicleTypeName!,
              ))
          .toList();
    } catch (e) {
      throw Exception('Не удалось загрузить типы автомобилей для марки $makeName: $e');
    }
  }

  @override
  Future<List<VehicleVariable>> getVehicleVariableList() async {
    try {
      final response = await _apiClient.getVehicleVariableList();
      return (response.results ?? [])
          .where((dto) => dto.id != null && dto.name != null)
          .map((dto) => VehicleVariable(
                id: dto.id!,
                name: dto.name!,
                description: dto.description,
              ))
          .toList();
    } catch (e) {
      throw Exception('Не удалось загрузить список характеристик: $e');
    }
  }

  @override
  Future<List<VariableValue>> getVehicleVariableValuesList(
      String variableName) async {
    try {
      final response = await _apiClient.getVehicleVariableValuesList(variableName);
      return (response.results ?? [])
          .where((dto) => dto.name != null && dto.name!.isNotEmpty)
          .map((dto) => VariableValue(name: dto.name!))
          .toList();
    } catch (e) {
      throw Exception('Не удалось загрузить значения характеристики: $e');
    }
  }
}



