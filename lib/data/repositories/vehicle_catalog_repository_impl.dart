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
      throw Exception('Не удалось загрузить марки: $e');
    }
  }

  @override
  Future<List<VehicleModel>> getModelsForMake(String make) async {
    try {
      final response = await _apiClient.getModelsForMake(make);
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
      throw Exception('Не удалось загрузить модели: $e');
    }
  }

  @override
  Future<VinDecodeResult> decodeVin(String vin) async {
    try {
      final response = await _apiClient.decodeVin(vin);
      final attributes = <String, String>{};

      for (final item in response.results ?? []) {
        if (item.variable != null && item.value != null && item.value!.isNotEmpty) {
          attributes[item.variable!] = item.value!;
        }
      }

      return VinDecodeResult(
        vin: vin,
        attributes: attributes,
      );
    } catch (e) {
      throw Exception('Не удалось декодировать VIN: $e');
    }
  }

  @override
  Future<List<VehicleType>> getVehicleTypesForMake(String make) async {
    try {
      final response = await _apiClient.getVehicleTypesForMake(make);
      return (response.results ?? [])
          .where((dto) => dto.vehicleTypeId != null && dto.vehicleTypeName != null)
          .map((dto) => VehicleType(
                id: dto.vehicleTypeId!,
                name: dto.vehicleTypeName!,
              ))
          .toList();
    } catch (e) {
      throw Exception('Не удалось загрузить типы транспортных средств: $e');
    }
  }

  @override
  Future<List<Wmi>> getWMIsForManufacturer(String manufacturer) async {
    try {
      final response = await _apiClient.getWMIsForManufacturer(manufacturer);
      return (response.results ?? [])
          .where((dto) => dto.wmi != null)
          .map((dto) => Wmi(
                code: dto.wmi!,
                country: dto.country,
                name: dto.name,
                vehicleType: dto.vehicleType,
              ))
          .toList();
    } catch (e) {
      throw Exception('Не удалось загрузить WMI коды: $e');
    }
  }

  @override
  Future<List<VehicleSpecification>> getCanadianVehicleSpecifications({
    required int year,
    required String make,
    required String model,
  }) async {
    try {
      final response = await _apiClient.getCanadianVehicleSpecifications(
        year,
        make,
        model,
      );
      
      final List<VehicleSpecification> specs = [];
      
      for (final result in response.results ?? []) {
        for (final spec in result.specs ?? []) {
          if (spec.name != null && 
              spec.value != null && 
              spec.value!.isNotEmpty &&
              spec.name!.trim().isNotEmpty) {
            specs.add(VehicleSpecification(
              name: spec.name!,
              value: spec.value!,
            ));
          }
        }
      }
      
      return specs;
    } catch (e) {
      throw Exception('Не удалось загрузить технические характеристики: $e');
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



