import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_practice13/core/models/vehicle_model.dart';
import 'package:flutter_practice13/domain/usecases/vehicles/get_vehicles_usecase.dart';
import 'package:flutter_practice13/domain/usecases/vehicles/add_vehicle_usecase.dart';
import 'package:flutter_practice13/domain/usecases/vehicles/update_vehicle_usecase.dart';
import 'package:flutter_practice13/domain/usecases/vehicles/delete_vehicle_usecase.dart';
import 'vehicles_state.dart';

class VehiclesCubit extends Cubit<VehiclesState> {
  final GetVehiclesUseCase getVehiclesUseCase;
  final AddVehicleUseCase addVehicleUseCase;
  final UpdateVehicleUseCase updateVehicleUseCase;
  final DeleteVehicleUseCase deleteVehicleUseCase;

  VehiclesCubit({
    required this.getVehiclesUseCase,
    required this.addVehicleUseCase,
    required this.updateVehicleUseCase,
    required this.deleteVehicleUseCase,
  }) : super(const VehiclesState());

  Future<void> loadVehicles() async {
    try {
      final vehicles = await getVehiclesUseCase();
      final activeVehicle = vehicles.where((v) => v.isActive).firstOrNull;
      emit(state.copyWith(
        vehicles: vehicles,
        activeVehicle: activeVehicle,
      ));
    } catch (e) {
      emit(state.copyWith(vehicles: []));
    }
  }

  Future<void> addVehicle({
    required String brand,
    required String model,
    required int year,
    String? vin,
    String? licensePlate,
    String? color,
    int? mileage,
    DateTime? purchaseDate,
  }) async {
    final newVehicle = VehicleModel(
      id: '',
      brand: brand,
      model: model,
      year: year,
      vin: vin,
      licensePlate: licensePlate,
      color: color,
      mileage: mileage,
      purchaseDate: purchaseDate,
      isActive: true,
    );

    try {
      await addVehicleUseCase(newVehicle);
      await loadVehicles();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateVehicle(VehicleModel updatedVehicle) async {
    try {
      await updateVehicleUseCase(updatedVehicle);
      await loadVehicles();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteVehicle(String id) async {
    try {
      await deleteVehicleUseCase(id);
      await loadVehicles();
    } catch (e) {
      rethrow;
    }
  }

  void setActiveVehicle(String id) {
    final vehicle = state.vehicles.firstWhere((v) => v.id == id);
    
    final updatedVehicles = state.vehicles.map((v) {
      return v.copyWith(isActive: v.id == id);
    }).toList();

    emit(state.copyWith(
      vehicles: updatedVehicles,
      activeVehicle: vehicle.copyWith(isActive: true),
    ));
  }

  void clearVehicles() {
    emit(const VehiclesState());
  }
}
