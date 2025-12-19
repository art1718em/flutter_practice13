import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:flutter_practice13/core/di/injection_container.dart';
import 'package:flutter_practice13/domain/usecases/vehicle_catalog/get_wmis_for_manufacturer_usecase.dart';
import 'package:flutter_practice13/domain/entities/vehicle_info.dart';
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
  List<Wmi>? _wmiCodes;
  bool _isLoadingWmi = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadWmiCodes();
    });
  }

  Future<void> _loadWmiCodes() async {
    final state = context.read<VehiclesCubit>().state;
    final vehicle = state.vehicles.firstWhere(
      (v) => v.id == widget.vehicleId,
      orElse: () => state.vehicles.first,
    );

    if (vehicle.brand.isNotEmpty) {
      setState(() {
        _isLoadingWmi = true;
      });

      try {
        final getWMIsUseCase = getIt<GetWMIsForManufacturerUseCase>();
        final wmis = await getWMIsUseCase(vehicle.brand);
        
        if (!mounted) return;
        
        setState(() {
          _wmiCodes = wmis;
          _isLoadingWmi = false;
        });
      } catch (e) {
        if (!mounted) return;
        setState(() {
          _isLoadingWmi = false;
        });
      }
    }
  }

  void _showWmiBottomSheet(String brand) {
    if (_wmiCodes == null || _wmiCodes!.isEmpty) return;

    final groupedByCountry = <String, List<Wmi>>{};
    for (final wmi in _wmiCodes!) {
      final country = wmi.country ?? 'Не указана';
      if (!groupedByCountry.containsKey(country)) {
        groupedByCountry[country] = [];
      }
      groupedByCountry[country]!.add(wmi);
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'WMI коды для $brand',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Всего ${_wmiCodes!.length} кодов',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: groupedByCountry.length,
                itemBuilder: (context, index) {
                  final country = groupedByCountry.keys.elementAt(index);
                  final codes = groupedByCountry[country]!;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 12),
                        child: Row(
                          children: [
                            Icon(
                              Icons.public,
                              size: 20,
                              color: Theme.of(context).primaryColor,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '$country (${codes.length})',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      ...codes.map((wmi) => Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              dense: true,
                              leading: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  wmi.code,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor,
                                    fontFamily: 'monospace',
                                  ),
                                ),
                              ),
                              title: Text(
                                wmi.vehicleType ?? 'Тип не указан',
                                style: const TextStyle(fontSize: 14),
                              ),
                              subtitle: wmi.name != null
                                  ? Text(
                                      wmi.name!,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    )
                                  : null,
                            ),
                          )),
                      const SizedBox(height: 8),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
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
                const Divider(),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.verified_user,
                                color: Theme.of(context).primaryColor,
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Информация о производителе',
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          if (_isLoadingWmi)
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.all(16),
                                child: CircularProgressIndicator(),
                              ),
                            )
                          else if (_wmiCodes != null && _wmiCodes!.isNotEmpty) ...[
                            Text(
                              'Найдено ${_wmiCodes!.length} WMI кодов для марки ${vehicle.brand}',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.grey[700],
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'WMI (World Manufacturer Identifier) - первые 3 символа VIN, идентифицирующие производителя',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: () => _showWmiBottomSheet(vehicle.brand),
                                icon: const Icon(Icons.list),
                                label: const Text('Просмотреть все коды'),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                          ] else
                            Text(
                              'Не удалось загрузить WMI коды',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
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

