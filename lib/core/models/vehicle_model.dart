import 'package:equatable/equatable.dart';

class VehicleModel extends Equatable {
  final String id;
  final String brand;
  final String model;
  final int year;
  final String? vin;
  final String? licensePlate;
  final String? color;
  final int? mileage;
  final DateTime? purchaseDate;
  final bool isActive;

  const VehicleModel({
    required this.id,
    required this.brand,
    required this.model,
    required this.year,
    this.vin,
    this.licensePlate,
    this.color,
    this.mileage,
    this.purchaseDate,
    this.isActive = false,
  });

  VehicleModel copyWith({
    String? id,
    String? brand,
    String? model,
    int? year,
    String? vin,
    String? licensePlate,
    String? color,
    int? mileage,
    DateTime? purchaseDate,
    bool? isActive,
  }) {
    return VehicleModel(
      id: id ?? this.id,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      year: year ?? this.year,
      vin: vin ?? this.vin,
      licensePlate: licensePlate ?? this.licensePlate,
      color: color ?? this.color,
      mileage: mileage ?? this.mileage,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  List<Object?> get props => [
        id,
        brand,
        model,
        year,
        vin,
        licensePlate,
        color,
        mileage,
        purchaseDate,
        isActive,
      ];
}
