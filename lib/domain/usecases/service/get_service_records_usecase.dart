import 'package:flutter_practice13/core/models/service_record_model.dart';
import 'package:flutter_practice13/domain/repositories/service_repository.dart';

class GetServiceRecordsUseCase {
  final ServiceRepository repository;

  GetServiceRecordsUseCase(this.repository);

  Future<List<ServiceRecordModel>> call() {
    return repository.getServiceRecords();
  }
}

