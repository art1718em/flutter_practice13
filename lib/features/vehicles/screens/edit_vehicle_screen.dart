import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_practice13/features/settings/logic/settings_cubit.dart';
import 'package:flutter_practice13/features/settings/logic/settings_state.dart';
import 'package:flutter_practice13/core/models/app_settings_model.dart';
import 'package:flutter_practice13/features/vehicles/logic/vehicles_cubit.dart';
import 'package:flutter_practice13/features/vehicles/logic/vehicles_state.dart';
import 'package:flutter_practice13/features/vehicle_catalog/logic/vehicle_catalog_cubit.dart';
import 'package:flutter_practice13/features/vehicle_catalog/logic/vehicle_catalog_state.dart';

class EditVehicleScreen extends StatefulWidget {
  final String vehicleId;

  const EditVehicleScreen({
    super.key,
    required this.vehicleId,
  });

  @override
  State<EditVehicleScreen> createState() => _EditVehicleScreenState();
}

class _EditVehicleScreenState extends State<EditVehicleScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _brandController;
  late TextEditingController _modelController;
  late TextEditingController _yearController;
  late TextEditingController _vinController;
  late TextEditingController _licensePlateController;
  late TextEditingController _colorController;
  late TextEditingController _mileageController;
  late TextEditingController _vehicleTypeController;
  DateTime? _purchaseDate;
  String? _selectedBrand;

  @override
  void initState() {
    super.initState();
    final vehicle = context.read<VehiclesCubit>().state.vehicles.firstWhere(
          (v) => v.id == widget.vehicleId,
        );

    _brandController = TextEditingController(text: vehicle.brand);
    _modelController = TextEditingController(text: vehicle.model);
    _yearController = TextEditingController(text: vehicle.year.toString());
    _vinController = TextEditingController(text: vehicle.vin ?? '');
    _licensePlateController = TextEditingController(text: vehicle.licensePlate ?? '');
    _colorController = TextEditingController(text: vehicle.color ?? '');
    _mileageController = TextEditingController(text: vehicle.mileage?.toString() ?? '');
    _vehicleTypeController = TextEditingController(text: vehicle.vehicleType ?? '');
    _purchaseDate = vehicle.purchaseDate;
    _selectedBrand = vehicle.brand;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VehicleCatalogCubit>().loadAllMakes();
      if (vehicle.brand.isNotEmpty) {
        context.read<VehicleCatalogCubit>().loadModelsForMake(vehicle.brand);
        context.read<VehicleCatalogCubit>().loadVehicleTypesForMake(vehicle.brand);
      }
    });

    _brandController.addListener(() {
      final brand = _brandController.text.trim();
      if (brand.isNotEmpty && brand != _selectedBrand) {
        _selectedBrand = brand;
        context.read<VehicleCatalogCubit>().loadModelsForMake(brand);
        context.read<VehicleCatalogCubit>().loadVehicleTypesForMake(brand);
      }
    });
  }

  @override
  void dispose() {
    _brandController.dispose();
    _modelController.dispose();
    _yearController.dispose();
    _vinController.dispose();
    _licensePlateController.dispose();
    _colorController.dispose();
    _mileageController.dispose();
    _vehicleTypeController.dispose();
    super.dispose();
  }

  void _saveVehicle() {
    if (_formKey.currentState!.validate()) {
      final vehicle = context.read<VehiclesCubit>().state.vehicles.firstWhere(
            (v) => v.id == widget.vehicleId,
          );

      final updatedVehicle = vehicle.copyWith(
        brand: _brandController.text.trim(),
        model: _modelController.text.trim(),
        year: int.parse(_yearController.text),
        vin: _vinController.text.trim().isNotEmpty ? _vinController.text.trim() : null,
        licensePlate: _licensePlateController.text.trim().isNotEmpty
            ? _licensePlateController.text.trim()
            : null,
        color: _colorController.text.trim().isNotEmpty ? _colorController.text.trim() : null,
        mileage: _mileageController.text.trim().isNotEmpty
            ? int.tryParse(_mileageController.text)
            : null,
        purchaseDate: _purchaseDate,
        vehicleType: _vehicleTypeController.text.trim().isNotEmpty 
            ? _vehicleTypeController.text.trim() 
            : null,
      );

      context.read<VehiclesCubit>().updateVehicle(updatedVehicle);
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, settingsState) {
        final distanceUnit = settingsState.settings.distanceUnit;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Редактировать автомобиль'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.pop(),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.save),
                onPressed: _saveVehicle,
              ),
            ],
          ),
          body: BlocBuilder<VehiclesCubit, VehiclesState>(
            builder: (context, state) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      BlocBuilder<VehicleCatalogCubit, VehicleCatalogState>(
                        builder: (context, catalogState) {
                          final makes = catalogState.makes.map((m) => m.name).toList();
                          return Autocomplete<String>(
                            initialValue: TextEditingValue(text: _brandController.text),
                            optionsBuilder: (textEditingValue) {
                              if (textEditingValue.text.isEmpty) {
                                return makes;
                              }
                              return makes.where((make) =>
                                  make.toLowerCase().contains(textEditingValue.text.toLowerCase()));
                            },
                            onSelected: (selection) {
                              _brandController.text = selection;
                            },
                            fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                              return TextFormField(
                                controller: controller,
                                focusNode: focusNode,
                                decoration: InputDecoration(
                                  labelText: 'Марка *',
                                  prefixIcon: const Icon(Icons.directions_car),
                                  border: const OutlineInputBorder(),
                                  suffixIcon: catalogState.isLoading
                                      ? const Padding(
                                          padding: EdgeInsets.all(12),
                                          child: SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(strokeWidth: 2),
                                          ),
                                        )
                                      : null,
                                ),
                                onChanged: (value) {
                                  _brandController.text = value;
                                },
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Введите марку';
                                  }
                                  return null;
                                },
                              );
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      BlocBuilder<VehicleCatalogCubit, VehicleCatalogState>(
                        builder: (context, catalogState) {
                          final models = catalogState.models.map((m) => m.name).toList();
                          return Autocomplete<String>(
                            initialValue: TextEditingValue(text: _modelController.text),
                            optionsBuilder: (textEditingValue) {
                              if (textEditingValue.text.isEmpty) {
                                return models;
                              }
                              return models.where((model) =>
                                  model.toLowerCase().contains(textEditingValue.text.toLowerCase()));
                            },
                            onSelected: (selection) {
                              _modelController.text = selection;
                            },
                            fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                              return TextFormField(
                                controller: controller,
                                focusNode: focusNode,
                                decoration: InputDecoration(
                                  labelText: 'Модель *',
                                  prefixIcon: const Icon(Icons.car_rental),
                                  border: const OutlineInputBorder(),
                                  hintText: _brandController.text.isEmpty
                                      ? 'Сначала выберите марку'
                                      : 'Начните вводить модель',
                                ),
                                enabled: _brandController.text.isNotEmpty,
                                onChanged: (value) {
                                  _modelController.text = value;
                                },
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Введите модель';
                                  }
                                  return null;
                                },
                              );
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      BlocBuilder<VehicleCatalogCubit, VehicleCatalogState>(
                        builder: (context, catalogState) {
                          final types = catalogState.vehicleTypes.map((t) => t.name).toList();
                          return Autocomplete<String>(
                            initialValue: TextEditingValue(text: _vehicleTypeController.text),
                            optionsBuilder: (textEditingValue) {
                              if (textEditingValue.text.isEmpty) {
                                return types;
                              }
                              return types.where((type) =>
                                  type.toLowerCase().contains(textEditingValue.text.toLowerCase()));
                            },
                            onSelected: (selection) {
                              _vehicleTypeController.text = selection;
                            },
                            fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                              return TextFormField(
                                controller: controller,
                                focusNode: focusNode,
                                decoration: InputDecoration(
                                  labelText: 'Тип кузова',
                                  prefixIcon: const Icon(Icons.category),
                                  border: const OutlineInputBorder(),
                                  hintText: _brandController.text.isEmpty
                                      ? 'Сначала выберите марку'
                                      : 'Начните вводить тип',
                                ),
                                enabled: _brandController.text.isNotEmpty,
                                onChanged: (value) {
                                  _vehicleTypeController.text = value;
                                },
                              );
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _yearController,
                        decoration: const InputDecoration(
                          labelText: 'Год выпуска *',
                          prefixIcon: Icon(Icons.calendar_today),
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Введите год выпуска';
                          }
                          final year = int.tryParse(value);
                          if (year == null) {
                            return 'Введите корректный год';
                          }
                          final currentYear = DateTime.now().year;
                          if (year < 1900 || year > currentYear + 1) {
                            return 'Введите год от 1900 до $currentYear';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _vinController,
                        decoration: const InputDecoration(
                          labelText: 'VIN',
                          prefixIcon: Icon(Icons.numbers),
                          border: OutlineInputBorder(),
                        ),
                        textCapitalization: TextCapitalization.characters,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _licensePlateController,
                        decoration: const InputDecoration(
                          labelText: 'Гос. номер',
                          prefixIcon: Icon(Icons.pin),
                          border: OutlineInputBorder(),
                        ),
                        textCapitalization: TextCapitalization.characters,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _colorController,
                        decoration: const InputDecoration(
                          labelText: 'Цвет',
                          prefixIcon: Icon(Icons.palette),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _mileageController,
                        decoration: InputDecoration(
                          labelText: 'Пробег (${distanceUnit.abbreviation})',
                          prefixIcon: const Icon(Icons.speed),
                          border: const OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value != null && value.trim().isNotEmpty) {
                            final mileage = int.tryParse(value);
                            if (mileage == null || mileage < 0) {
                              return 'Введите корректный пробег';
                            }
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.event),
                        title: Text(
                          _purchaseDate == null
                              ? 'Дата покупки (не выбрана)'
                              : 'Дата покупки: ${_purchaseDate!.day}.${_purchaseDate!.month}.${_purchaseDate!.year}',
                        ),
                        trailing: const Icon(Icons.calendar_month),
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: _purchaseDate ?? DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          );
                          if (date != null) {
                            setState(() {
                              _purchaseDate = date;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: _saveVehicle,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text(
                          'Сохранить',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
