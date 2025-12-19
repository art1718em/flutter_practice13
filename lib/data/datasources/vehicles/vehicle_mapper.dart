import 'package:flutter_practice13/core/models/vehicle_model.dart';
import 'package:flutter_practice13/data/datasources/vehicles/vehicle_dto.dart';

extension VehicleMapper on VehicleDto {
  VehicleModel toModel() {
    return VehicleModel(
      id: id,
      brand: brand,
      model: model,
      year: year,
      vin: vin,
      licensePlate: licensePlate,
      color: color,
      mileage: mileage,
      purchaseDate: purchaseDate != null ? DateTime.parse(purchaseDate!) : null,
      isActive: isActive,
    );
  }
}

extension VehicleModelMapper on VehicleModel {
  VehicleDto toDto() {
    return VehicleDto(
      id: id,
      brand: brand,
      model: model,
      year: year,
      vin: vin,
      licensePlate: licensePlate,
      color: color,
      mileage: mileage,
      purchaseDate: purchaseDate?.toIso8601String(),
      isActive: isActive,
    );
  }
}

