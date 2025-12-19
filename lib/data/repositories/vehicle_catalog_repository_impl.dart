import 'package:flutter_practice13/domain/entities/vehicle_info.dart';
import 'package:flutter_practice13/domain/repositories/vehicle_catalog_repository.dart';
import '../datasources/vehicle_catalog/vehicle_catalog_datasource.dart';

class VehicleCatalogRepositoryImpl implements VehicleCatalogRepository {
  final VehicleCatalogDataSource _dataSource;

  VehicleCatalogRepositoryImpl(this._dataSource);

  @override
  Future<List<VehicleMake>> getAllMakes() async {
    return _dataSource.getAllMakes();
  }

  @override
  Future<List<VehicleModel>> getModelsForMake(String makeName) async {
    return _dataSource.getModelsForMake(makeName);
  }

  @override
  Future<List<VehicleType>> getVehicleTypesForMake(String makeName) async {
    return _dataSource.getVehicleTypesForMake(makeName);
  }

  @override
  Future<List<VehicleVariable>> getVehicleVariableList() async {
    return _dataSource.getVehicleVariableList();
  }

  @override
  Future<List<VariableValue>> getVehicleVariableValuesList(String variableName) async {
    return _dataSource.getVehicleVariableValuesList(variableName);
  }
}



