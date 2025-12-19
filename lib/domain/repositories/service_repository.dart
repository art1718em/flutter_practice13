import 'package:flutter_practice13/core/models/service_record_model.dart';

abstract class ServiceRepository {
  Future<List<ServiceRecordModel>> getServiceRecords();
  Future<List<ServiceRecordModel>> getServiceRecordsByVehicle(String vehicleId);
  Future<void> addServiceRecord(ServiceRecordModel record);
  Future<void> deleteServiceRecord(String id);
}

