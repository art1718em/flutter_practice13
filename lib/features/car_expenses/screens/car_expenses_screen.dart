import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_practice13/features/settings/logic/settings_cubit.dart';
import 'package:flutter_practice13/features/settings/logic/settings_state.dart';
import 'package:flutter_practice13/features/vehicles/logic/vehicles_cubit.dart';
import 'package:flutter_practice13/features/vehicles/logic/vehicles_state.dart';
import 'package:flutter_practice13/shared/utils/format_helpers.dart';
import '../logic/car_expenses_cubit.dart';
import '../logic/car_expenses_state.dart';
import '../widgets/expense_table.dart';

class CarExpensesScreen extends StatefulWidget {
  const CarExpensesScreen({
    super.key,
  });

  @override
  State<CarExpensesScreen> createState() => _CarExpensesScreenState();
}

class _CarExpensesScreenState extends State<CarExpensesScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<VehiclesCubit>().loadVehicles();
      context.read<CarExpensesCubit>().loadExpenses();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VehiclesCubit, VehiclesState>(
      builder: (context, vehiclesState) {
        final activeVehicle = vehiclesState.activeVehicle;

        if (activeVehicle == null) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Расходы'),
              centerTitle: true,
            ),
            body: Center(
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
                  const SizedBox(height: 8),
                  Text(
                    'Добавьте автомобиль для учета расходов',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
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
            ),
          );
        }

        return BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, settingsState) {
            final currency = settingsState.settings.currency;

            return BlocConsumer<CarExpensesCubit, CarExpensesState>(
              listener: (context, state) {
        if (state.recentlyRemovedExpense != null) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context)
              .showSnackBar(
                SnackBar(
                  content: const Text('Расход удален'),
                  duration: const Duration(seconds: 3),
                  action: SnackBarAction(
                    label: 'ОТМЕНИТЬ',
                    onPressed: () {
                      context.read<CarExpensesCubit>().undoRemove();
                    },
                  ),
                ),
              )
              .closed
              .then((reason) {
            if (reason != SnackBarClosedReason.action) {
              context.read<CarExpensesCubit>().clearUndoState();
            }
          });
        }
      },
              builder: (context, state) {
                final expenses = state.getExpensesByVehicle(activeVehicle.id);
                final totalAmount = state.getTotalAmount(activeVehicle.id);

                return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.history),
              tooltip: 'История обслуживания',
              onPressed: () => context.push('/history'),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.directions_car),
                tooltip: 'Автомобили',
                onPressed: () => context.push('/vehicles'),
              ),
            ],
                  title: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${activeVehicle.brand} ${activeVehicle.model}',
                        style: const TextStyle(fontSize: 14),
                      ),
                      Text(
                        'Расходы: ${FormatHelpers.formatCurrency(totalAmount, currency)}',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
          ),
                  body: ExpenseTable(
                    expenses: expenses,
                    currency: currency,
                    onRemove: (id) =>
                        context.read<CarExpensesCubit>().removeExpense(id),
                  ),
                  floatingActionButton: FloatingActionButton(
                    onPressed: () => context.push('/expenses/add'),
                    child: const Icon(Icons.add),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

