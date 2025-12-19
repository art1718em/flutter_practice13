import 'package:flutter_practice13/domain/entities/vehicle_info.dart';
import 'package:flutter_practice13/domain/repositories/vehicle_catalog_repository.dart';

class GetVehicleVariableValuesUseCase {
  final VehicleCatalogRepository repository;

  GetVehicleVariableValuesUseCase(this.repository);

  Future<List<VariableValue>> call(String variableName) async {
    return repository.getVehicleVariableValuesList(variableName);
  }
}

