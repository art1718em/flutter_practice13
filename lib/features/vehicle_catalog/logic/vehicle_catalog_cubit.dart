import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_practice13/domain/usecases/vehicle_catalog/decode_vin_usecase.dart';
import 'package:flutter_practice13/features/vehicle_catalog/logic/vehicle_catalog_state.dart';

class VehicleCatalogCubit extends Cubit<VehicleCatalogState> {
  final DecodeVinUseCase _decodeVinUseCase;

  VehicleCatalogCubit({
    required DecodeVinUseCase decodeVinUseCase,
  })  : _decodeVinUseCase = decodeVinUseCase,
        super(const VehicleCatalogState());

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

  void clearError() {
    emit(state.clearError());
  }
}



