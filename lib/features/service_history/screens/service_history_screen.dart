import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_practice13/features/service_history/logic/service_history_cubit.dart';
import 'package:flutter_practice13/features/service_history/logic/service_history_state.dart';
import 'package:flutter_practice13/features/settings/logic/settings_cubit.dart';
import 'package:flutter_practice13/features/settings/logic/settings_state.dart';
import 'package:flutter_practice13/features/vehicles/logic/vehicles_cubit.dart';
import 'package:flutter_practice13/features/vehicles/logic/vehicles_state.dart';
import 'package:flutter_practice13/shared/utils/format_helpers.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class ServiceHistoryScreen extends StatefulWidget {
  const ServiceHistoryScreen({super.key});

  @override
  State<ServiceHistoryScreen> createState() => _ServiceHistoryScreenState();
}

class _ServiceHistoryScreenState extends State<ServiceHistoryScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<VehiclesCubit>().loadVehicles();
      context.read<ServiceHistoryCubit>().loadServiceRecords();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VehiclesCubit, VehiclesState>(
      builder: (context, vehiclesState) {
        final activeVehicle = vehiclesState.activeVehicle;

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.go('/'),
            ),
            title: activeVehicle != null
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'История обслуживания',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        '${activeVehicle.brand} ${activeVehicle.model}',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  )
                : const Text('История обслуживания'),
            centerTitle: true,
          ),
          body: activeVehicle == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.directions_car_outlined,
                        size: 100,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Нет активного автомобиля',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: () => context.push('/vehicles'),
                        icon: const Icon(Icons.add),
                        label: const Text('Добавить автомобиль'),
                      ),
                    ],
                  ),
                )
              : BlocBuilder<SettingsCubit, SettingsState>(
                  builder: (context, settingsState) {
                    final distanceUnit = settingsState.settings.distanceUnit;

                    return BlocBuilder<ServiceHistoryCubit, ServiceHistoryState>(
                      builder: (context, state) {
                        final records = state.getRecordsByVehicle(activeVehicle.id);

                        if (records.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.history,
                                  size: 100,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'История обслуживания пуста',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Добавьте первую запись о ТО',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        final sortedRecords = List.from(records)
                          ..sort((a, b) => b.date.compareTo(a.date));

                        return ListView.builder(
                          padding: const EdgeInsets.all(8),
                          itemCount: sortedRecords.length,
                          itemBuilder: (context, index) {
                            final record = sortedRecords[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                              elevation: 2,
                              child: ExpansionTile(
                                leading: CircleAvatar(
                                  backgroundColor: Theme.of(context).primaryColor,
                                  child: Text(
                                    record.type.icon,
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                ),
                                title: Text(
                                  record.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.category,
                                          size: 14,
                                          color: Colors.grey[600],
                                        ),
                                        const SizedBox(width: 4),
                                        Text(record.type.displayName),
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.calendar_today,
                                          size: 14,
                                          color: Colors.grey[600],
                                        ),
                                        const SizedBox(width: 4),
                                        Text(DateFormat('dd.MM.yyyy').format(record.date)),
                                      ],
                                    ),
                                    if (record.mileage != null) ...[
                                      const SizedBox(height: 2),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.speed,
                                            size: 14,
                                            color: Colors.grey[600],
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            FormatHelpers.formatDistance(
                                              record.mileage!,
                                              distanceUnit,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ],
                                ),
                                trailing: PopupMenuButton(
                                  itemBuilder: (context) => [
                                    const PopupMenuItem(
                                      value: 'delete',
                                      child: Row(
                                        children: [
                                          Icon(Icons.delete, color: Colors.red),
                                          SizedBox(width: 8),
                                          Text(
                                            'Удалить',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                  onSelected: (value) {
                                    if (value == 'delete') {
                                      _showDeleteDialog(context, record.id, record.title);
                                    }
                                  },
                                ),
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        if (record.worksDone.isNotEmpty) ...[
                                          const Text(
                                            'Выполненные работы:',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          ...record.worksDone.map((work) => Padding(
                                                padding: const EdgeInsets.only(bottom: 4),
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    const Icon(
                                                      Icons.check_circle,
                                                      size: 16,
                                                      color: Colors.green,
                                                    ),
                                                    const SizedBox(width: 8),
                                                    Expanded(child: Text(work)),
                                                  ],
                                                ),
                                              )),
                                          const SizedBox(height: 12),
                                        ],

                                        if (record.serviceCenter != null) ...[
                                          Row(
                                            children: [
                                              const Icon(Icons.build, size: 16),
                                              const SizedBox(width: 8),
                                              const Text(
                                                'СТО: ',
                                                style: TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                              Expanded(child: Text(record.serviceCenter!)),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                        ],

                                        if (record.nextServiceDate != null) ...[
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.event_available,
                                                size: 16,
                                                color: record.nextServiceDate!.isBefore(DateTime.now())
                                                    ? Colors.red
                                                    : Colors.green,
                                              ),
                                              const SizedBox(width: 8),
                                              const Text(
                                                'Следующее ТО: ',
                                                style: TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                              Text(
                                                DateFormat('dd.MM.yyyy').format(record.nextServiceDate!),
                                                style: TextStyle(
                                                  color: record.nextServiceDate!.isBefore(DateTime.now())
                                                      ? Colors.red
                                                      : Colors.green,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                        ],

                                        if (record.notes != null && record.notes!.isNotEmpty) ...[
                                          const Text(
                                            'Заметки:',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Container(
                                            padding: const EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              color: Colors.grey[100],
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Text(record.notes!),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
          floatingActionButton: activeVehicle != null
              ? FloatingActionButton(
                  onPressed: () => context.push('/history/add'),
                  child: const Icon(Icons.add),
                )
              : null,
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context, String recordId, String title) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Удалить запись?'),
        content: Text('Вы уверены, что хотите удалить "$title"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              context.read<ServiceHistoryCubit>().deleteServiceRecord(recordId);
              Navigator.of(dialogContext).pop();
            },
            child: const Text(
              'Удалить',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
