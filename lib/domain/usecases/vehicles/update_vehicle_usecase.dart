import 'package:flutter_practice13/core/models/vehicle_model.dart';
import 'package:flutter_practice13/domain/repositories/vehicles_repository.dart';

class UpdateVehicleUseCase {
  final VehiclesRepository repository;

  UpdateVehicleUseCase(this.repository);

  Future<void> call(VehicleModel vehicle) {
    return repository.updateVehicle(vehicle);
  }
}

