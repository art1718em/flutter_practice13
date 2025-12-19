import 'package:flutter_practice13/domain/entities/vehicle_info.dart';
import 'package:flutter_practice13/domain/repositories/vehicle_catalog_repository.dart';

class GetVehicleTypesForMakeUseCase {
  final VehicleCatalogRepository repository;

  GetVehicleTypesForMakeUseCase(this.repository);

  Future<List<VehicleType>> call(String makeName) {
    return repository.getVehicleTypesForMake(makeName);
  }
}

