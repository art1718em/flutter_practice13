import 'package:flutter_practice13/core/models/service_record_model.dart';
import 'package:flutter_practice13/data/datasources/service/service_record_dto.dart';

extension ServiceRecordMapper on ServiceRecordDto {
  ServiceRecordModel toModel() {
    return ServiceRecordModel(
      id: id,
      vehicleId: vehicleId,
      title: title,
      type: ServiceType.values.firstWhere((e) => e.name == type),
      date: DateTime.parse(date),
      mileage: mileage,
      worksDone: worksDone,
      serviceCenter: serviceCenter,
      notes: notes,
      nextServiceDate: nextServiceDate != null ? DateTime.parse(nextServiceDate!) : null,
    );
  }
}

extension ServiceRecordModelMapper on ServiceRecordModel {
  ServiceRecordDto toDto() {
    return ServiceRecordDto(
      id: id,
      vehicleId: vehicleId,
      title: title,
      type: type.name,
      date: date.toIso8601String(),
      mileage: mileage,
      worksDone: worksDone,
      serviceCenter: serviceCenter,
      notes: notes,
      nextServiceDate: nextServiceDate?.toIso8601String(),
    );
  }
}

