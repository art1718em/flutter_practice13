import 'package:flutter_practice13/domain/entities/vehicle_info.dart';
import 'package:flutter_practice13/domain/repositories/vehicle_catalog_repository.dart';

class GetModelsForMakeUseCase {
  final VehicleCatalogRepository repository;

  GetModelsForMakeUseCase(this.repository);

  Future<List<VehicleModel>> call(String makeName) {
    return repository.getModelsForMake(makeName);
  }
}
