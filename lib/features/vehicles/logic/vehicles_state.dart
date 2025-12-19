import 'package:equatable/equatable.dart';
import 'package:flutter_practice13/core/models/vehicle_model.dart';

class VehiclesState extends Equatable {
  final List<VehicleModel> vehicles;
  final VehicleModel? activeVehicle;
  final bool isLoading;
  final String? errorMessage;

  const VehiclesState({
    this.vehicles = const [],
    this.activeVehicle,
    this.isLoading = false,
    this.errorMessage,
  });

  VehiclesState copyWith({
    List<VehicleModel>? vehicles,
    VehicleModel? activeVehicle,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
    bool clearActiveVehicle = false,
  }) {
    return VehiclesState(
      vehicles: vehicles ?? this.vehicles,
      activeVehicle: clearActiveVehicle ? null : activeVehicle ?? this.activeVehicle,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [vehicles, activeVehicle, isLoading, errorMessage];
}


