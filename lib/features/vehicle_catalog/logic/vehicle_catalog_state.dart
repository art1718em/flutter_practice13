import 'package:equatable/equatable.dart';
import 'package:flutter_practice13/domain/entities/vehicle_info.dart';

class VehicleCatalogState extends Equatable {
  final List<VehicleMake> makes;
  final List<VehicleModel> models;
  final List<VehicleType> vehicleTypes;
  final bool isLoading;
  final String? error;

  const VehicleCatalogState({
    this.makes = const [],
    this.models = const [],
    this.vehicleTypes = const [],
    this.isLoading = false,
    this.error,
  });

  VehicleCatalogState copyWith({
    List<VehicleMake>? makes,
    List<VehicleModel>? models,
    List<VehicleType>? vehicleTypes,
    bool? isLoading,
    String? error,
  }) {
    return VehicleCatalogState(
      makes: makes ?? this.makes,
      models: models ?? this.models,
      vehicleTypes: vehicleTypes ?? this.vehicleTypes,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  VehicleCatalogState clearError() {
    return copyWith(error: null);
  }

  @override
  List<Object?> get props => [
        makes,
        models,
        vehicleTypes,
        isLoading,
        error,
      ];
}



