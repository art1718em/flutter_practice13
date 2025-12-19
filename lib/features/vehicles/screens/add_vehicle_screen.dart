import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_practice13/features/settings/logic/settings_cubit.dart';
import 'package:flutter_practice13/features/settings/logic/settings_state.dart';
import 'package:flutter_practice13/core/models/app_settings_model.dart';
import 'package:flutter_practice13/features/vehicles/logic/vehicles_cubit.dart';
import 'package:flutter_practice13/features/vehicle_catalog/logic/vehicle_catalog_cubit.dart';

class AddVehicleScreen extends StatefulWidget {
  const AddVehicleScreen({super.key});

  @override
  State<AddVehicleScreen> createState() => _AddVehicleScreenState();
}

class _AddVehicleScreenState extends State<AddVehicleScreen> {
  final _formKey = GlobalKey<FormState>();
  final _brandController = TextEditingController();
  final _modelController = TextEditingController();
  final _yearController = TextEditingController();
  final _vinController = TextEditingController();
  final _licensePlateController = TextEditingController();
  final _colorController = TextEditingController();
  final _mileageController = TextEditingController();
  final _vehicleTypeController = TextEditingController();
  DateTime? _purchaseDate;

  bool _isDecodingVin = false;

  @override
  void initState() {
    super.initState();
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

  Future<void> _decodeVin() async {
    final vin = _vinController.text.trim();
    if (vin.length != 17) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('VIN должен содержать 17 символов')),
      );
      return;
    }

    setState(() => _isDecodingVin = true);
    await context.read<VehicleCatalogCubit>().decodeVin(vin);

    final result = context.read<VehicleCatalogCubit>().state.vinDecodeResult;
    if (result != null) {
      final errorCode = result.getAttribute('Error Code');
      final errorText = result.getAttribute('Error Text');
      final additionalError = result.getAttribute('Additional Error Text');
      
      if (errorCode != null && errorCode != '0' && errorCode.isNotEmpty) {
        setState(() => _isDecodingVin = false);
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Ошибка декодирования VIN'),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('VIN не может быть расшифрован:', 
                    style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  if (additionalError != null && additionalError.isNotEmpty)
                    Text('• $additionalError', style: const TextStyle(fontSize: 13)),
                  if (errorText != null && errorText.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text('• $errorText', style: const TextStyle(fontSize: 13)),
                    ),
                  const SizedBox(height: 12),
                  const Text('NHTSA API работает только с автомобилями, зарегистрированными для продажи в США.',
                    style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic)),
                  const SizedBox(height: 8),
                  const Text('Вы можете заполнить данные об автомобиле вручную.',
                    style: TextStyle(fontSize: 12, color: Colors.blue)),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Понятно'),
              ),
            ],
          ),
        );
        return;
      }
      
      final make = result.getAttribute('Make') ?? 
                   result.getAttribute('Manufacturer Name') ??
                   result.getAttribute('Make Name');
      final model = result.getAttribute('Model') ?? 
                    result.getAttribute('Model Name');
      final year = result.getAttribute('Model Year') ?? 
                   result.getAttribute('Year');

      setState(() {
        _isDecodingVin = false;
        
        if (make != null && make.isNotEmpty) {
          _brandController.text = make;
        }
        if (model != null && model.isNotEmpty) {
          _modelController.text = model;
        }
        if (year != null && year.isNotEmpty) {
          _yearController.text = year;
        }
      });

      final filledFields = <String>[];
      if (make != null && make.isNotEmpty) filledFields.add('Марка');
      if (model != null && model.isNotEmpty) filledFields.add('Модель');
      if (year != null && year.isNotEmpty) filledFields.add('Год');

      if (filledFields.isEmpty) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('VIN расшифрован'),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Не удалось извлечь данные из VIN.'),
                  const SizedBox(height: 16),
                  const Text('Доступные атрибуты:', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  ...result.attributes.entries.take(10).map((e) => 
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text('${e.key}: ${e.value}', style: const TextStyle(fontSize: 12)),
                    )
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } else {
      setState(() => _isDecodingVin = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Не удалось расшифровать VIN')),
      );
    }
  }

  void _saveVehicle() {
    if (_formKey.currentState!.validate()) {
      context.read<VehiclesCubit>().addVehicle(
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
            title: const Text('Добавить автомобиль'),
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
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _vinController,
                    decoration: InputDecoration(
                      labelText: 'VIN',
                      prefixIcon: const Icon(Icons.numbers),
                      border: const OutlineInputBorder(),
                      suffixIcon: _isDecodingVin
                          ? const Padding(
                              padding: EdgeInsets.all(12),
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                            )
                          : IconButton(
                              icon: const Icon(Icons.search),
                              tooltip: 'Декодировать VIN',
                              onPressed: _decodeVin,
                            ),
                    ),
                    textCapitalization: TextCapitalization.characters,
                    maxLength: 17,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _brandController,
                    decoration: const InputDecoration(
                      labelText: 'Марка *',
                      prefixIcon: Icon(Icons.directions_car),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Введите марку';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _modelController,
                    decoration: const InputDecoration(
                      labelText: 'Модель *',
                      prefixIcon: Icon(Icons.car_rental),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Введите модель';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _vehicleTypeController,
                    decoration: const InputDecoration(
                      labelText: 'Тип кузова',
                      prefixIcon: Icon(Icons.category),
                      border: OutlineInputBorder(),
                    ),
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
                        initialDate: DateTime.now(),
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
          ),
        );
      },
    );
  }
}
