import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_practice13/features/settings/logic/settings_cubit.dart';
import 'package:flutter_practice13/features/settings/logic/settings_state.dart';
import 'package:flutter_practice13/features/vehicles/logic/vehicles_cubit.dart';
import 'package:flutter_practice13/features/vehicles/logic/vehicles_state.dart';
import 'package:flutter_practice13/shared/utils/format_helpers.dart';

class VehiclesScreen extends StatefulWidget {
  const VehiclesScreen({super.key});

  @override
  State<VehiclesScreen> createState() => _VehiclesScreenState();
}

class _VehiclesScreenState extends State<VehiclesScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<VehiclesCubit>().loadVehicles();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Мои автомобили'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, settingsState) {
          final distanceUnit = settingsState.settings.distanceUnit;

          return BlocBuilder<VehiclesCubit, VehiclesState>(
            builder: (context, state) {
          if (state.vehicles.isEmpty) {
            return Center(
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
                    'У вас пока нет автомобилей',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Добавьте первый автомобиль',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: state.vehicles.length,
            itemBuilder: (context, index) {
              final vehicle = state.vehicles[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                elevation: vehicle.isActive ? 4 : 1,
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: CircleAvatar(
                    backgroundColor: vehicle.isActive 
                        ? Theme.of(context).primaryColor 
                        : Colors.grey,
                    child: const Icon(
                      Icons.directions_car,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(
                    '${vehicle.brand} ${vehicle.model}',
                    style: TextStyle(
                      fontWeight: vehicle.isActive ? FontWeight.bold : FontWeight.normal,
                      fontSize: 18,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text('Год: ${vehicle.year}'),
                        if (vehicle.licensePlate != null)
                          Text('Номер: ${vehicle.licensePlate}'),
                        if (vehicle.mileage != null)
                          Text(
                            'Пробег: ${FormatHelpers.formatDistance(vehicle.mileage!, distanceUnit)}',
                          ),
                      if (vehicle.isActive)
                        Container(
                          margin: const EdgeInsets.only(top: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'Активный',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  ),
                  trailing: PopupMenuButton(
                    itemBuilder: (context) => [
                      if (!vehicle.isActive)
                        const PopupMenuItem(
                          value: 'activate',
                          child: Row(
                            children: [
                              Icon(Icons.check_circle_outline),
                              SizedBox(width: 8),
                              Text('Сделать активным'),
                            ],
                          ),
                        ),
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit),
                            SizedBox(width: 8),
                            Text('Редактировать'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Удалить', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                    onSelected: (value) {
                      switch (value) {
                        case 'activate':
                          context.read<VehiclesCubit>().setActiveVehicle(vehicle.id);
                          break;
                        case 'edit':
                          context.push('/vehicles/edit/${vehicle.id}');
                          break;
                        case 'delete':
                          _showDeleteDialog(context, vehicle.id);
                          break;
                      }
                    },
                  ),
                  onTap: () => context.push('/vehicles/details/${vehicle.id}'),
                ),
              );
            },
          );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/vehicles/add'),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, String vehicleId) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Удалить автомобиль?'),
        content: const Text('Это действие нельзя будет отменить.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              context.read<VehiclesCubit>().deleteVehicle(vehicleId);
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

