import 'package:flutter_practice13/core/api/nhtsa/nhtsa_dto.dart';
import 'package:flutter_practice13/domain/entities/vehicle_info.dart';

class VehicleCatalogMapper {
  static VehicleMake makeToEntity(MakeDto dto) {
    return VehicleMake(
      id: dto.makeId!,
      name: dto.makeName!,
      manufacturerName: dto.mfrName,
      manufacturerId: dto.mfrId,
    );
  }

  static VehicleModel modelToEntity(ModelDto dto) {
    return VehicleModel(
      id: dto.modelId!,
      name: dto.modelName!,
      makeId: dto.makeId!,
      makeName: dto.makeName!,
    );
  }

  static VehicleType typeToEntity(VehicleTypeDto dto) {
    return VehicleType(
      id: dto.vehicleTypeId!,
      name: dto.vehicleTypeName!,
    );
  }

  static VehicleVariable variableToEntity(VehicleVariableDto dto) {
    return VehicleVariable(
      id: dto.id!,
      name: dto.name!,
      description: dto.description,
    );
  }

  static VariableValue variableValueToEntity(VariableValueDto dto) {
    return VariableValue(name: dto.name!);
  }
}
