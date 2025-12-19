import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_practice13/domain/usecases/vehicle_catalog/get_vehicle_variable_list_usecase.dart';
import 'package:flutter_practice13/domain/usecases/vehicle_catalog/get_vehicle_variable_values_usecase.dart';
import 'package:flutter_practice13/features/vehicle_reference/logic/vehicle_reference_state.dart';

class VehicleReferenceCubit extends Cubit<VehicleReferenceState> {
  final GetVehicleVariableListUseCase _getVehicleVariableListUseCase;
  final GetVehicleVariableValuesUseCase _getVehicleVariableValuesUseCase;

  VehicleReferenceCubit({
    required GetVehicleVariableListUseCase getVehicleVariableListUseCase,
    required GetVehicleVariableValuesUseCase getVehicleVariableValuesUseCase,
  })  : _getVehicleVariableListUseCase = getVehicleVariableListUseCase,
        _getVehicleVariableValuesUseCase = getVehicleVariableValuesUseCase,
        super(const VehicleReferenceState());

  Future<void> loadVariableList() async {
    emit(state.copyWith(isLoadingVariables: true, error: null));
    try {
      final variables = await _getVehicleVariableListUseCase();
      emit(state.copyWith(
        variables: variables,
        isLoadingVariables: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoadingVariables: false,
        error: 'Не удалось загрузить справочник: $e',
      ));
    }
  }

  Future<void> loadVariableValues(String variableName) async {
    emit(state.copyWith(isLoadingValues: true, error: null));
    try {
      final values = await _getVehicleVariableValuesUseCase(variableName);
      emit(state.copyWith(
        values: values,
        isLoadingValues: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoadingValues: false,
        error: 'Не удалось загрузить значения: $e',
      ));
    }
  }

  void clearValues() {
    emit(state.copyWith(values: []));
  }
}


