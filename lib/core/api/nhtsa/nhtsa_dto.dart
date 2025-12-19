import 'package:json_annotation/json_annotation.dart';

part 'nhtsa_dto.g.dart';

@JsonSerializable()
class ManufacturerDto {
  @JsonKey(name: 'Country')
  final String? country;
  @JsonKey(name: 'Mfr_CommonName')
  final String? commonName;
  @JsonKey(name: 'Mfr_ID')
  final int? id;
  @JsonKey(name: 'Mfr_Name')
  final String? name;

  ManufacturerDto({
    this.country,
    this.commonName,
    this.id,
    this.name,
  });

  factory ManufacturerDto.fromJson(Map<String, dynamic> json) =>
      _$ManufacturerDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ManufacturerDtoToJson(this);
}

@JsonSerializable()
class ManufacturersResponseDto {
  @JsonKey(name: 'Count')
  final int? count;
  @JsonKey(name: 'Message')
  final String? message;
  @JsonKey(name: 'SearchCriteria')
  final String? searchCriteria;
  @JsonKey(name: 'Results')
  final List<ManufacturerDto>? results;

  ManufacturersResponseDto({
    this.count,
    this.message,
    this.searchCriteria,
    this.results,
  });

  factory ManufacturersResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ManufacturersResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ManufacturersResponseDtoToJson(this);
}

@JsonSerializable()
class MakeDto {
  @JsonKey(name: 'Make_ID')
  final int? makeId;
  @JsonKey(name: 'Make_Name')
  final String? makeName;
  @JsonKey(name: 'Mfr_Name')
  final String? mfrName;
  @JsonKey(name: 'Mfr_ID')
  final int? mfrId;

  MakeDto({
    this.makeId,
    this.makeName,
    this.mfrName,
    this.mfrId,
  });

  factory MakeDto.fromJson(Map<String, dynamic> json) =>
      _$MakeDtoFromJson(json);

  Map<String, dynamic> toJson() => _$MakeDtoToJson(this);
}

@JsonSerializable()
class MakesResponseDto {
  @JsonKey(name: 'Count')
  final int? count;
  @JsonKey(name: 'Message')
  final String? message;
  @JsonKey(name: 'SearchCriteria')
  final String? searchCriteria;
  @JsonKey(name: 'Results')
  final List<MakeDto>? results;

  MakesResponseDto({
    this.count,
    this.message,
    this.searchCriteria,
    this.results,
  });

  factory MakesResponseDto.fromJson(Map<String, dynamic> json) =>
      _$MakesResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$MakesResponseDtoToJson(this);
}

@JsonSerializable()
class ModelDto {
  @JsonKey(name: 'Make_ID')
  final int? makeId;
  @JsonKey(name: 'Make_Name')
  final String? makeName;
  @JsonKey(name: 'Model_ID')
  final int? modelId;
  @JsonKey(name: 'Model_Name')
  final String? modelName;

  ModelDto({
    this.makeId,
    this.makeName,
    this.modelId,
    this.modelName,
  });

  factory ModelDto.fromJson(Map<String, dynamic> json) =>
      _$ModelDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ModelDtoToJson(this);
}

@JsonSerializable()
class ModelsResponseDto {
  @JsonKey(name: 'Count')
  final int? count;
  @JsonKey(name: 'Message')
  final String? message;
  @JsonKey(name: 'SearchCriteria')
  final String? searchCriteria;
  @JsonKey(name: 'Results')
  final List<ModelDto>? results;

  ModelsResponseDto({
    this.count,
    this.message,
    this.searchCriteria,
    this.results,
  });

  factory ModelsResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ModelsResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ModelsResponseDtoToJson(this);
}

@JsonSerializable()
class VehicleTypeDto {
  @JsonKey(name: 'VehicleTypeId')
  final int? vehicleTypeId;
  @JsonKey(name: 'VehicleTypeName')
  final String? vehicleTypeName;

  VehicleTypeDto({
    this.vehicleTypeId,
    this.vehicleTypeName,
  });

  factory VehicleTypeDto.fromJson(Map<String, dynamic> json) =>
      _$VehicleTypeDtoFromJson(json);

  Map<String, dynamic> toJson() => _$VehicleTypeDtoToJson(this);
}

@JsonSerializable()
class VehicleTypesResponseDto {
  @JsonKey(name: 'Count')
  final int? count;
  @JsonKey(name: 'Message')
  final String? message;
  @JsonKey(name: 'SearchCriteria')
  final String? searchCriteria;
  @JsonKey(name: 'Results')
  final List<VehicleTypeDto>? results;

  VehicleTypesResponseDto({
    this.count,
    this.message,
    this.searchCriteria,
    this.results,
  });

  factory VehicleTypesResponseDto.fromJson(Map<String, dynamic> json) =>
      _$VehicleTypesResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$VehicleTypesResponseDtoToJson(this);
}

@JsonSerializable()
class VehicleVariableDto {
  @JsonKey(name: 'ID')
  final int? id;
  @JsonKey(name: 'Name')
  final String? name;
  @JsonKey(name: 'Description')
  final String? description;

  VehicleVariableDto({
    this.id,
    this.name,
    this.description,
  });

  factory VehicleVariableDto.fromJson(Map<String, dynamic> json) =>
      _$VehicleVariableDtoFromJson(json);

  Map<String, dynamic> toJson() => _$VehicleVariableDtoToJson(this);
}

@JsonSerializable()
class VehicleVariableListResponseDto {
  @JsonKey(name: 'Count')
  final int? count;
  @JsonKey(name: 'Message')
  final String? message;
  @JsonKey(name: 'Results')
  final List<VehicleVariableDto>? results;

  VehicleVariableListResponseDto({
    this.count,
    this.message,
    this.results,
  });

  factory VehicleVariableListResponseDto.fromJson(Map<String, dynamic> json) =>
      _$VehicleVariableListResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$VehicleVariableListResponseDtoToJson(this);
}

@JsonSerializable()
class VariableValueDto {
  @JsonKey(name: 'Name')
  final String? name;

  VariableValueDto({this.name});

  factory VariableValueDto.fromJson(Map<String, dynamic> json) =>
      _$VariableValueDtoFromJson(json);

  Map<String, dynamic> toJson() => _$VariableValueDtoToJson(this);
}

@JsonSerializable()
class VehicleVariableValuesResponseDto {
  @JsonKey(name: 'Count')
  final int? count;
  @JsonKey(name: 'Message')
  final String? message;
  @JsonKey(name: 'Results')
  final List<VariableValueDto>? results;

  VehicleVariableValuesResponseDto({
    this.count,
    this.message,
    this.results,
  });

  factory VehicleVariableValuesResponseDto.fromJson(Map<String, dynamic> json) =>
      _$VehicleVariableValuesResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$VehicleVariableValuesResponseDtoToJson(this);
}




