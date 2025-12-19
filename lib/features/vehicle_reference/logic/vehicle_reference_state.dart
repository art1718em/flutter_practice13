import 'package:equatable/equatable.dart';
import 'package:flutter_practice13/domain/entities/vehicle_info.dart';

class VehicleReferenceState extends Equatable {
  final List<VehicleVariable> variables;
  final List<VariableValue> values;
  final bool isLoadingVariables;
  final bool isLoadingValues;
  final String? error;

  const VehicleReferenceState({
    this.variables = const [],
    this.values = const [],
    this.isLoadingVariables = false,
    this.isLoadingValues = false,
    this.error,
  });

  VehicleReferenceState copyWith({
    List<VehicleVariable>? variables,
    List<VariableValue>? values,
    bool? isLoadingVariables,
    bool? isLoadingValues,
    String? error,
  }) {
    return VehicleReferenceState(
      variables: variables ?? this.variables,
      values: values ?? this.values,
      isLoadingVariables: isLoadingVariables ?? this.isLoadingVariables,
      isLoadingValues: isLoadingValues ?? this.isLoadingValues,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
        variables,
        values,
        isLoadingVariables,
        isLoadingValues,
        error,
      ];
}

