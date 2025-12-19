import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_practice13/features/service_history/logic/service_history_cubit.dart';
import 'package:flutter_practice13/core/models/service_record_model.dart';
import 'package:flutter_practice13/features/settings/logic/settings_cubit.dart';
import 'package:flutter_practice13/features/settings/logic/settings_state.dart';
import 'package:flutter_practice13/core/models/app_settings_model.dart';
import 'package:flutter_practice13/features/vehicles/logic/vehicles_cubit.dart';
import 'package:flutter_practice13/shared/utils/format_helpers.dart';
import 'package:go_router/go_router.dart';

class AddServiceRecordScreen extends StatefulWidget {
  const AddServiceRecordScreen({super.key});

  @override
  State<AddServiceRecordScreen> createState() => _AddServiceRecordScreenState();
}

class _AddServiceRecordScreenState extends State<AddServiceRecordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _mileageController = TextEditingController();
  final _serviceCenterController = TextEditingController();
  final _notesController = TextEditingController();
  final _workItemController = TextEditingController();
  
  ServiceType _selectedType = ServiceType.maintenance;
  DateTime _selectedDate = DateTime.now();
  DateTime? _nextServiceDate;
  final List<String> _worksDone = [];

  @override
  void dispose() {
    _titleController.dispose();
    _mileageController.dispose();
    _serviceCenterController.dispose();
    _notesController.dispose();
    _workItemController.dispose();
    super.dispose();
  }

  void _addWorkItem() {
    if (_workItemController.text.trim().isNotEmpty) {
      setState(() {
        _worksDone.add(_workItemController.text.trim());
        _workItemController.clear();
      });
    }
  }

  void _removeWorkItem(int index) {
    setState(() {
      _worksDone.removeAt(index);
    });
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      final activeVehicle = context.read<VehiclesCubit>().state.activeVehicle;
      if (activeVehicle == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Нет активного автомобиля')),
        );
        return;
      }

      context.read<ServiceHistoryCubit>().addServiceRecord(
            vehicleId: activeVehicle.id,
            title: _titleController.text.trim(),
            type: _selectedType,
            date: _selectedDate,
            mileage: _mileageController.text.trim().isNotEmpty
                ? int.tryParse(_mileageController.text)
                : null,
            worksDone: _worksDone,
            serviceCenter: _serviceCenterController.text.trim().isNotEmpty
                ? _serviceCenterController.text.trim()
                : null,
            notes: _notesController.text.trim().isNotEmpty
                ? _notesController.text.trim()
                : null,
            nextServiceDate: _nextServiceDate,
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
            title: const Text('Добавить запись о ТО'),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.pop(),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.save),
                onPressed: _saveForm,
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
                  // Тип обслуживания
                  DropdownButtonFormField<ServiceType>(
                    value: _selectedType,
                    decoration: const InputDecoration(
                      labelText: 'Тип обслуживания *',
                      prefixIcon: Icon(Icons.category),
                      border: OutlineInputBorder(),
                    ),
                    items: ServiceType.values.map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Row(
                          children: [
                            Text(type.icon, style: const TextStyle(fontSize: 20)),
                            const SizedBox(width: 8),
                            Text(type.displayName),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedType = value;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 16),

                  // Название
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Название *',
                      prefixIcon: Icon(Icons.title),
                      border: OutlineInputBorder(),
                      hintText: 'Например: Замена масла',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Введите название';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Дата
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.calendar_today),
                    title: Text(
                      'Дата обслуживания: ${_selectedDate.day}.${_selectedDate.month}.${_selectedDate.year}',
                    ),
                    trailing: const Icon(Icons.edit),
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                      );
                      if (date != null) {
                        setState(() {
                          _selectedDate = date;
                        });
                      }
                    },
                  ),
                  const Divider(),

                  // Пробег
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

                  // СТО
                  TextFormField(
                    controller: _serviceCenterController,
                    decoration: const InputDecoration(
                      labelText: 'СТО / Сервис',
                      prefixIcon: Icon(Icons.build),
                      border: OutlineInputBorder(),
                      hintText: 'Название сервисного центра',
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Выполненные работы
                  const Text(
                    'Выполненные работы',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _workItemController,
                          decoration: const InputDecoration(
                            hintText: 'Добавить работу',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.add_task),
                          ),
                          onSubmitted: (_) => _addWorkItem(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.add_circle),
                        color: Theme.of(context).primaryColor,
                        onPressed: _addWorkItem,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (_worksDone.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Список работ пуст',
                        style: TextStyle(color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    )
                  else
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _worksDone.length,
                        separatorBuilder: (context, index) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          return ListTile(
                            dense: true,
                            leading: const Icon(Icons.check_circle, color: Colors.green),
                            title: Text(_worksDone[index]),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _removeWorkItem(index),
                            ),
                          );
                        },
                      ),
                    ),
                  const SizedBox(height: 16),

                  // Следующее ТО
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.event_available),
                    title: Text(
                      _nextServiceDate == null
                          ? 'Следующее ТО (не указано)'
                          : 'Следующее ТО: ${_nextServiceDate!.day}.${_nextServiceDate!.month}.${_nextServiceDate!.year}',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (_nextServiceDate != null)
                          IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                _nextServiceDate = null;
                              });
                            },
                          ),
                        const Icon(Icons.calendar_month),
                      ],
                    ),
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: _nextServiceDate ?? DateTime.now().add(const Duration(days: 180)),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 3650)),
                      );
                      if (date != null) {
                        setState(() {
                          _nextServiceDate = date;
                        });
                      }
                    },
                  ),
                  const Divider(),

                  // Заметки
                  TextFormField(
                    controller: _notesController,
                    decoration: const InputDecoration(
                      labelText: 'Заметки',
                      prefixIcon: Icon(Icons.note),
                      border: OutlineInputBorder(),
                      hintText: 'Дополнительная информация',
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 24),

                  // Кнопка сохранения
                  ElevatedButton(
                    onPressed: _saveForm,
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
