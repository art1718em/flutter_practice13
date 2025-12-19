import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_practice13/core/models/service_record_model.dart';
import 'package:flutter_practice13/domain/usecases/service/get_service_records_usecase.dart';
import 'package:flutter_practice13/domain/usecases/service/add_service_record_usecase.dart';
import 'service_history_state.dart';

class ServiceHistoryCubit extends Cubit<ServiceHistoryState> {
  final GetServiceRecordsUseCase getServiceRecordsUseCase;
  final AddServiceRecordUseCase addServiceRecordUseCase;

  ServiceHistoryCubit({
    required this.getServiceRecordsUseCase,
    required this.addServiceRecordUseCase,
  }) : super(const ServiceHistoryState());

  Future<void> loadServiceRecords() async {
    try {
      final records = await getServiceRecordsUseCase();
      emit(state.copyWith(serviceRecords: records));
    } catch (e) {
      emit(state.copyWith(serviceRecords: []));
    }
  }

  Future<void> addServiceRecord({
    required String vehicleId,
    required String title,
    required ServiceType type,
    required DateTime date,
    int? mileage,
    List<String>? worksDone,
    String? serviceCenter,
    String? notes,
    DateTime? nextServiceDate,
  }) async {
    final newRecord = ServiceRecordModel(
      id: '',
      vehicleId: vehicleId,
      title: title,
      type: type,
      date: date,
      mileage: mileage,
      worksDone: worksDone ?? [],
      serviceCenter: serviceCenter,
      notes: notes,
      nextServiceDate: nextServiceDate,
    );

    try {
      await addServiceRecordUseCase(newRecord);
      await loadServiceRecords();
    } catch (e) {
      rethrow;
    }
  }

  void deleteServiceRecord(String id) {
    final updatedRecords = state.serviceRecords.where((r) => r.id != id).toList();
    emit(state.copyWith(serviceRecords: updatedRecords));
  }

  void clearServiceHistory() {
    emit(const ServiceHistoryState());
  }
}
