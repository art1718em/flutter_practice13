import 'package:flutter_practice13/domain/entities/vehicle_info.dart';
import 'package:flutter_practice13/domain/repositories/vehicle_catalog_repository.dart';

class GetWMIsForManufacturerUseCase {
  final VehicleCatalogRepository repository;

  GetWMIsForManufacturerUseCase(this.repository);

  Future<List<Wmi>> call(String manufacturer) async {
    return repository.getWMIsForManufacturer(manufacturer);
  }
}

