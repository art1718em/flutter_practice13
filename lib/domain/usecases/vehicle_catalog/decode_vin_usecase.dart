import 'package:flutter_practice13/domain/entities/vehicle_info.dart';
import 'package:flutter_practice13/domain/repositories/vehicle_catalog_repository.dart';

class DecodeVinUseCase {
  final VehicleCatalogRepository repository;

  DecodeVinUseCase(this.repository);

  Future<VinDecodeResult> call(String vin) {
    return repository.decodeVin(vin);
  }
}

