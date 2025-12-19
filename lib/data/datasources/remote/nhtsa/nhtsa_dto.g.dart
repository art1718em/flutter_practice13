part of 'nhtsa_dto.dart';

ManufacturerDto _$ManufacturerDtoFromJson(Map<String, dynamic> json) =>
    ManufacturerDto(
      country: json['Country'] as String?,
      commonName: json['Mfr_CommonName'] as String?,
      id: json['Mfr_ID'] as int?,
      name: json['Mfr_Name'] as String?,
    );

Map<String, dynamic> _$ManufacturerDtoToJson(ManufacturerDto instance) =>
    <String, dynamic>{
      'Country': instance.country,
      'Mfr_CommonName': instance.commonName,
      'Mfr_ID': instance.id,
      'Mfr_Name': instance.name,
    };

ManufacturersResponseDto _$ManufacturersResponseDtoFromJson(
        Map<String, dynamic> json) =>
    ManufacturersResponseDto(
      count: json['Count'] as int?,
      message: json['Message'] as String?,
      searchCriteria: json['SearchCriteria'] as String?,
      results: (json['Results'] as List<dynamic>?)
          ?.map((e) => ManufacturerDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ManufacturersResponseDtoToJson(
        ManufacturersResponseDto instance) =>
    <String, dynamic>{
      'Count': instance.count,
      'Message': instance.message,
      'SearchCriteria': instance.searchCriteria,
      'Results': instance.results,
    };

MakeDto _$MakeDtoFromJson(Map<String, dynamic> json) => MakeDto(
      makeId: json['Make_ID'] as int?,
      makeName: json['Make_Name'] as String?,
      mfrName: json['Mfr_Name'] as String?,
      mfrId: json['Mfr_ID'] as int?,
    );

Map<String, dynamic> _$MakeDtoToJson(MakeDto instance) => <String, dynamic>{
      'Make_ID': instance.makeId,
      'Make_Name': instance.makeName,
      'Mfr_Name': instance.mfrName,
      'Mfr_ID': instance.mfrId,
    };

MakesResponseDto _$MakesResponseDtoFromJson(Map<String, dynamic> json) =>
    MakesResponseDto(
      count: json['Count'] as int?,
      message: json['Message'] as String?,
      searchCriteria: json['SearchCriteria'] as String?,
      results: (json['Results'] as List<dynamic>?)
          ?.map((e) => MakeDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MakesResponseDtoToJson(MakesResponseDto instance) =>
    <String, dynamic>{
      'Count': instance.count,
      'Message': instance.message,
      'SearchCriteria': instance.searchCriteria,
      'Results': instance.results,
    };

ModelDto _$ModelDtoFromJson(Map<String, dynamic> json) => ModelDto(
      makeId: json['Make_ID'] as int?,
      makeName: json['Make_Name'] as String?,
      modelId: json['Model_ID'] as int?,
      modelName: json['Model_Name'] as String?,
    );

Map<String, dynamic> _$ModelDtoToJson(ModelDto instance) => <String, dynamic>{
      'Make_ID': instance.makeId,
      'Make_Name': instance.makeName,
      'Model_ID': instance.modelId,
      'Model_Name': instance.modelName,
    };

ModelsResponseDto _$ModelsResponseDtoFromJson(Map<String, dynamic> json) =>
    ModelsResponseDto(
      count: json['Count'] as int?,
      message: json['Message'] as String?,
      searchCriteria: json['SearchCriteria'] as String?,
      results: (json['Results'] as List<dynamic>?)
          ?.map((e) => ModelDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ModelsResponseDtoToJson(ModelsResponseDto instance) =>
    <String, dynamic>{
      'Count': instance.count,
      'Message': instance.message,
      'SearchCriteria': instance.searchCriteria,
      'Results': instance.results,
    };

VinDecodeDto _$VinDecodeDtoFromJson(Map<String, dynamic> json) =>
    VinDecodeDto(
      value: json['Value'] as String?,
      valueId: json['ValueId'] as String?,
      variable: json['Variable'] as String?,
      variableId: json['VariableId'] as int?,
    );

Map<String, dynamic> _$VinDecodeDtoToJson(VinDecodeDto instance) =>
    <String, dynamic>{
      'Value': instance.value,
      'ValueId': instance.valueId,
      'Variable': instance.variable,
      'VariableId': instance.variableId,
    };

VinDecodeResponseDto _$VinDecodeResponseDtoFromJson(
        Map<String, dynamic> json) =>
    VinDecodeResponseDto(
      count: json['Count'] as int?,
      message: json['Message'] as String?,
      searchCriteria: json['SearchCriteria'] as String?,
      results: (json['Results'] as List<dynamic>?)
          ?.map((e) => VinDecodeDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$VinDecodeResponseDtoToJson(
        VinDecodeResponseDto instance) =>
    <String, dynamic>{
      'Count': instance.count,
      'Message': instance.message,
      'SearchCriteria': instance.searchCriteria,
      'Results': instance.results,
    };

VehicleTypeDto _$VehicleTypeDtoFromJson(Map<String, dynamic> json) =>
    VehicleTypeDto(
      vehicleTypeId: json['VehicleTypeId'] as int?,
      vehicleTypeName: json['VehicleTypeName'] as String?,
    );

Map<String, dynamic> _$VehicleTypeDtoToJson(VehicleTypeDto instance) =>
    <String, dynamic>{
      'VehicleTypeId': instance.vehicleTypeId,
      'VehicleTypeName': instance.vehicleTypeName,
    };

VehicleTypesResponseDto _$VehicleTypesResponseDtoFromJson(
        Map<String, dynamic> json) =>
    VehicleTypesResponseDto(
      count: json['Count'] as int?,
      message: json['Message'] as String?,
      searchCriteria: json['SearchCriteria'] as String?,
      results: (json['Results'] as List<dynamic>?)
          ?.map((e) => VehicleTypeDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$VehicleTypesResponseDtoToJson(
        VehicleTypesResponseDto instance) =>
    <String, dynamic>{
      'Count': instance.count,
      'Message': instance.message,
      'SearchCriteria': instance.searchCriteria,
      'Results': instance.results,
    };



