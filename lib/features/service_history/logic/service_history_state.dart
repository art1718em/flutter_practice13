import 'package:equatable/equatable.dart';
import 'package:flutter_practice13/core/models/service_record_model.dart';

class ServiceHistoryState extends Equatable {
  final List<ServiceRecordModel> serviceRecords;

  const ServiceHistoryState({
    this.serviceRecords = const [],
  });

  List<ServiceRecordModel> getRecordsByVehicle(String? vehicleId) {
    if (vehicleId == null) return [];
    return serviceRecords.where((r) => r.vehicleId == vehicleId).toList();
  }

  ServiceHistoryState copyWith({
    List<ServiceRecordModel>? serviceRecords,
  }) {
    return ServiceHistoryState(
      serviceRecords: serviceRecords ?? this.serviceRecords,
    );
  }

  @override
  List<Object> get props => [serviceRecords];
}

