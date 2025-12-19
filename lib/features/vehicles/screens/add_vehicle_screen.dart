import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_practice13/features/settings/logic/settings_cubit.dart';
import 'package:flutter_practice13/features/settings/logic/settings_state.dart';
import 'package:flutter_practice13/core/models/app_settings_model.dart';
import 'package:flutter_practice13/features/vehicles/logic/vehicles_cubit.dart';

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
  DateTime? _purchaseDate;

  @override
  void dispose() {
    _brandController.dispose();
    _modelController.dispose();
    _yearController.dispose();
    _vinController.dispose();
    _licensePlateController.dispose();
    _colorController.dispose();
    _mileageController.dispose();
    super.dispose();
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
