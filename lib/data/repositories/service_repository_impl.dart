import 'package:flutter_practice13/core/models/service_record_model.dart';
import 'package:flutter_practice13/data/datasources/service/service_local_datasource.dart';
import 'package:flutter_practice13/domain/repositories/service_repository.dart';

class ServiceRepositoryImpl implements ServiceRepository {
  final ServiceLocalDataSource localDataSource;

  ServiceRepositoryImpl(this.localDataSource);

  @override
  Future<List<ServiceRecordModel>> getServiceRecords() {
    return localDataSource.getServiceRecords();
  }

  @override
  Future<List<ServiceRecordModel>> getServiceRecordsByVehicle(String vehicleId) {
    return localDataSource.getServiceRecordsByVehicle(vehicleId);
  }

  @override
  Future<void> addServiceRecord(ServiceRecordModel record) {
    return localDataSource.addServiceRecord(record);
  }

  @override
  Future<void> deleteServiceRecord(String id) {
    return localDataSource.deleteServiceRecord(id);
  }
}

