import 'package:flutter_practice13/domain/entities/vehicle_info.dart';

abstract class VehicleCatalogRepository {
  Future<List<VehicleMake>> getAllMakes();
  Future<List<VehicleModel>> getModelsForMake(String makeName);
  Future<List<VehicleType>> getVehicleTypesForMake(String makeName);
  Future<List<VehicleVariable>> getVehicleVariableList();
  Future<List<VariableValue>> getVehicleVariableValuesList(String variableName);
}



