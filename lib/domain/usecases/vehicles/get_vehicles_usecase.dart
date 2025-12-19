import 'package:flutter_practice13/core/models/vehicle_model.dart';
import 'package:flutter_practice13/domain/repositories/vehicles_repository.dart';

class GetVehiclesUseCase {
  final VehiclesRepository repository;

  GetVehiclesUseCase(this.repository);

  Future<List<VehicleModel>> call() {
    return repository.getVehicles();
  }
}

