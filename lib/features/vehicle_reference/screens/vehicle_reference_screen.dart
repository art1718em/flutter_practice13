import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_practice13/features/vehicle_reference/logic/vehicle_reference_cubit.dart';
import 'package:flutter_practice13/features/vehicle_reference/logic/vehicle_reference_state.dart';

class VehicleReferenceScreen extends StatefulWidget {
  const VehicleReferenceScreen({super.key});

  @override
  State<VehicleReferenceScreen> createState() => _VehicleReferenceScreenState();
}

class _VehicleReferenceScreenState extends State<VehicleReferenceScreen> {
  @override
  void initState() {
    super.initState();
    context.read<VehicleReferenceCubit>().loadVariableList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Справочник'),
        centerTitle: true,
      ),
      body: BlocBuilder<VehicleReferenceCubit, VehicleReferenceState>(
        builder: (context, state) {
          if (state.isLoadingVariables) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    state.error!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<VehicleReferenceCubit>().loadVariableList();
                    },
                    child: const Text('Повторить'),
                  ),
                ],
              ),
            );
          }

          if (state.variables.isEmpty) {
            return const Center(
              child: Text('Справочник пуст'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: state.variables.length,
            itemBuilder: (context, index) {
              final variable = state.variables[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                    child: Icon(
                      Icons.info_outline,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  title: Text(
                    variable.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    _showVariableValues(context, variable.name);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showVariableValues(BuildContext context, String variableName) {
    context.read<VehicleReferenceCubit>().loadVariableValues(variableName);

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
        builder: (context, scrollController) => BlocBuilder<VehicleReferenceCubit, VehicleReferenceState>(
          builder: (context, state) {
            return Column(
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
                        variableName,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      if (state.isLoadingValues) ...[
                        const SizedBox(height: 16),
                        const CircularProgressIndicator(),
                      ] else if (state.values.isNotEmpty)
                        Text(
                          'Найдено ${state.values.length} значений',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.grey[600],
                              ),
                        ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                if (!state.isLoadingValues)
                  Expanded(
                    child: state.values.isEmpty
                        ? const Center(child: Text('Нет доступных значений'))
                        : ListView.builder(
                            controller: scrollController,
                            padding: const EdgeInsets.all(16),
                            itemCount: state.values.length,
                            itemBuilder: (context, index) {
                              final value = state.values[index];
                              return Card(
                                margin: const EdgeInsets.only(bottom: 8),
                                child: ListTile(
                                  leading: Icon(
                                    Icons.check_circle_outline,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  title: Text(
                                    value.name,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
              ],
            );
          },
        ),
      ),
    ).whenComplete(() {
      context.read<VehicleReferenceCubit>().clearValues();
    });
  }
}

