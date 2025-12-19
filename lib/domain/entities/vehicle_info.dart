import 'package:equatable/equatable.dart';

class Manufacturer extends Equatable {
  final int id;
  final String name;
  final String? commonName;
  final String? country;

  const Manufacturer({
    required this.id,
    required this.name,
    this.commonName,
    this.country,
  });

  @override
  List<Object?> get props => [id, name, commonName, country];
}

class VehicleMake extends Equatable {
  final int id;
  final String name;
  final String? manufacturerName;
  final int? manufacturerId;

  const VehicleMake({
    required this.id,
    required this.name,
    this.manufacturerName,
    this.manufacturerId,
  });

  @override
  List<Object?> get props => [id, name, manufacturerName, manufacturerId];
}

class VehicleModel extends Equatable {
  final int id;
  final String name;
  final int makeId;
  final String makeName;

  const VehicleModel({
    required this.id,
    required this.name,
    required this.makeId,
    required this.makeName,
  });

  @override
  List<Object?> get props => [id, name, makeId, makeName];
}

class VehicleType extends Equatable {
  final int id;
  final String name;

  const VehicleType({
    required this.id,
    required this.name,
  });

  @override
  List<Object?> get props => [id, name];
}

class VinDecodeResult extends Equatable {
  final String vin;
  final Map<String, String> attributes;

  const VinDecodeResult({
    required this.vin,
    required this.attributes,
  });

  String? getAttribute(String key) => attributes[key];

  @override
  List<Object?> get props => [vin, attributes];
}

class Wmi extends Equatable {
  final String code;
  final String? country;
  final String? name;
  final String? vehicleType;

  const Wmi({
    required this.code,
    this.country,
    this.name,
    this.vehicleType,
  });

  @override
  List<Object?> get props => [code, country, name, vehicleType];
}

class VehicleSpecification extends Equatable {
  final String name;
  final String value;

  const VehicleSpecification({
    required this.name,
    required this.value,
  });

  @override
  List<Object?> get props => [name, value];
}



