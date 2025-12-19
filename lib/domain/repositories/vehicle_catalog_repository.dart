import 'package:flutter_practice13/domain/entities/vehicle_info.dart';

abstract class VehicleCatalogRepository {
  Future<List<VehicleMake>> getAllMakes();
  Future<List<VehicleModel>> getModelsForMake(String make);
  Future<VinDecodeResult> decodeVin(String vin);
  Future<List<VehicleType>> getVehicleTypesForMake(String make);
  Future<List<Wmi>> getWMIsForManufacturer(String manufacturer);
}



