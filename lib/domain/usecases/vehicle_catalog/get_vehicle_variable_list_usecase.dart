import 'package:flutter_practice13/domain/entities/vehicle_info.dart';
import 'package:flutter_practice13/domain/repositories/vehicle_catalog_repository.dart';

class GetVehicleVariableListUseCase {
  final VehicleCatalogRepository repository;

  GetVehicleVariableListUseCase(this.repository);

  Future<List<VehicleVariable>> call() async {
    return repository.getVehicleVariableList();
  }
}


