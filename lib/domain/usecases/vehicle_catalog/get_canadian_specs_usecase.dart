import 'package:flutter_practice13/domain/entities/vehicle_info.dart';
import 'package:flutter_practice13/domain/repositories/vehicle_catalog_repository.dart';

class GetCanadianSpecsUseCase {
  final VehicleCatalogRepository repository;

  GetCanadianSpecsUseCase(this.repository);

  Future<List<VehicleSpecification>> call({
    required int year,
    required String make,
    required String model,
  }) async {
    return repository.getCanadianVehicleSpecifications(
      year: year,
      make: make,
      model: model,
    );
  }
}

