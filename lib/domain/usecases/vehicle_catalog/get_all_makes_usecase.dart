import 'package:flutter_practice13/domain/entities/vehicle_info.dart';
import 'package:flutter_practice13/domain/repositories/vehicle_catalog_repository.dart';

class GetAllMakesUseCase {
  final VehicleCatalogRepository repository;

  GetAllMakesUseCase(this.repository);

  Future<List<VehicleMake>> call() {
    return repository.getAllMakes();
  }
}
