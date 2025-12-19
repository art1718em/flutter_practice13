import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_practice13/domain/usecases/vehicle_catalog/get_all_makes_usecase.dart';
import 'package:flutter_practice13/domain/usecases/vehicle_catalog/get_models_for_make_usecase.dart';
import 'package:flutter_practice13/domain/usecases/vehicle_catalog/decode_vin_usecase.dart';
import 'package:flutter_practice13/domain/usecases/vehicle_catalog/get_vehicle_types_for_make_usecase.dart';
import 'package:flutter_practice13/features/vehicle_catalog/logic/vehicle_catalog_state.dart';

class VehicleCatalogCubit extends Cubit<VehicleCatalogState> {
  final GetAllMakesUseCase _getAllMakesUseCase;
  final GetModelsForMakeUseCase _getModelsForMakeUseCase;
  final DecodeVinUseCase _decodeVinUseCase;
  final GetVehicleTypesForMakeUseCase _getVehicleTypesForMakeUseCase;

  VehicleCatalogCubit({
    required GetAllMakesUseCase getAllMakesUseCase,
    required GetModelsForMakeUseCase getModelsForMakeUseCase,
    required DecodeVinUseCase decodeVinUseCase,
    required GetVehicleTypesForMakeUseCase getVehicleTypesForMakeUseCase,
  })  : _getAllMakesUseCase = getAllMakesUseCase,
        _getModelsForMakeUseCase = getModelsForMakeUseCase,
        _decodeVinUseCase = decodeVinUseCase,
        _getVehicleTypesForMakeUseCase = getVehicleTypesForMakeUseCase,
        super(const VehicleCatalogState());

  Future<void> loadAllMakes() async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final makes = await _getAllMakesUseCase();
      emit(state.copyWith(
        makes: makes,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: 'Не удалось загрузить марки: $e',
      ));
    }
  }

  Future<void> loadModelsForMake(String make) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final models = await _getModelsForMakeUseCase(make);
      emit(state.copyWith(
        models: models,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: 'Не удалось загрузить модели: $e',
      ));
    }
  }

  Future<void> decodeVin(String vin) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final result = await _decodeVinUseCase(vin);
      emit(state.copyWith(
        vinDecodeResult: result,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: 'Не удалось декодировать VIN: $e',
      ));
    }
  }

  Future<void> loadVehicleTypesForMake(String make) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final types = await _getVehicleTypesForMakeUseCase(make);
      emit(state.copyWith(
        vehicleTypes: types,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: 'Не удалось загрузить типы транспортных средств: $e',
      ));
    }
  }

  void clearError() {
    emit(state.clearError());
  }

  void clearModelsAndTypes() {
    emit(state.copyWith(
      models: [],
      vehicleTypes: [],
    ));
  }
}



