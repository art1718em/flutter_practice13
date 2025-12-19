import 'package:flutter_practice13/core/models/service_record_model.dart';
import 'package:flutter_practice13/domain/repositories/service_repository.dart';

class AddServiceRecordUseCase {
  final ServiceRepository repository;

  AddServiceRecordUseCase(this.repository);

  Future<void> call(ServiceRecordModel record) {
    return repository.addServiceRecord(record);
  }
}

