import 'package:flutter_practice13/data/datasources/remote/nhtsa/nhtsa_api_client.dart';
import 'package:flutter_practice13/domain/entities/vehicle_info.dart';
import 'package:flutter_practice13/domain/repositories/vehicle_catalog_repository.dart';

class VehicleCatalogRepositoryImpl implements VehicleCatalogRepository {
  final NhtsaApiClient _apiClient;

  VehicleCatalogRepositoryImpl(this._apiClient);

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



