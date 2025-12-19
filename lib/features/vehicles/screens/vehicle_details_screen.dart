import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:flutter_practice13/core/di/injection_container.dart';
import 'package:flutter_practice13/features/settings/logic/settings_cubit.dart';
import 'package:flutter_practice13/features/settings/logic/settings_state.dart';
import 'package:flutter_practice13/features/vehicles/logic/vehicles_cubit.dart';
import 'package:flutter_practice13/features/vehicles/logic/vehicles_state.dart';
import 'package:flutter_practice13/features/vehicle_catalog/logic/vehicle_catalog_cubit.dart';
import 'package:flutter_practice13/shared/utils/format_helpers.dart';

class VehicleDetailsScreen extends StatefulWidget {
  final String vehicleId;

  const VehicleDetailsScreen({
    super.key,
    required this.vehicleId,
  });

  @override
  State<VehicleDetailsScreen> createState() => _VehicleDetailsScreenState();
}

class _VehicleDetailsScreenState extends State<VehicleDetailsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, settingsState) {
        final distanceUnit = settingsState.settings.distanceUnit;

        return BlocBuilder<VehiclesCubit, VehiclesState>(
          builder: (context, state) {
            final vehicle = state.vehicles.firstWhere(
              (v) => v.id == widget.vehicleId,
              orElse: () => state.vehicles.first,
            );

            return Scaffold(
          appBar: AppBar(
            title: const Text('Детали автомобиля'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.pop(),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  child: Column(
                    children: [
                      Icon(
                        Icons.directions_car,
                        size: 80,
                        color: Theme.of(context).primaryColor,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '${vehicle.brand} ${vehicle.model}',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      if (vehicle.isActive)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Text(
                            'Активный автомобиль',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.calendar_today),
                  title: const Text('Год выпуска'),
                  trailing: Text(
                    vehicle.year.toString(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (vehicle.vehicleType != null) ...[
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.category),
                    title: const Text('Тип кузова'),
                    trailing: Text(
                      vehicle.vehicleType!,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
                if (vehicle.vin != null) ...[
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.numbers),
                    title: const Text('VIN'),
                    trailing: Text(
                      vehicle.vin!,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
                if (vehicle.licensePlate != null) ...[
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.pin),
                    title: const Text('Гос. номер'),
                    trailing: Text(
                      vehicle.licensePlate!,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
                if (vehicle.color != null) ...[
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.palette),
                    title: const Text('Цвет'),
                    trailing: Text(
                      vehicle.color!,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
                if (vehicle.mileage != null) ...[
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.speed),
                    title: const Text('Пробег'),
                    trailing: Text(
                      FormatHelpers.formatDistance(vehicle.mileage!, distanceUnit),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
                if (vehicle.purchaseDate != null) ...[
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.event),
                    title: const Text('Дата покупки'),
                    trailing: Text(
                      DateFormat('dd.MM.yyyy').format(vehicle.purchaseDate!),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
                const Divider(                ),
              ],
            ),
          ),
            );
          },
        );
      },
    );
  }
}

