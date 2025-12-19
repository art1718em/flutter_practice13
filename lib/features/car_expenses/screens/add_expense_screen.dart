import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_practice13/features/settings/logic/settings_cubit.dart';
import 'package:flutter_practice13/features/settings/logic/settings_state.dart';
import 'package:flutter_practice13/features/vehicles/logic/vehicles_cubit.dart';
import 'package:flutter_practice13/shared/utils/format_helpers.dart';
import '../logic/car_expenses_cubit.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({
    super.key,
  });

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
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
      final title = _titleController.text;
      final amount = double.tryParse(_amountController.text) ?? 0.0;
      context.read<CarExpensesCubit>().addExpense(activeVehicle.id, title, amount);
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, settingsState) {
        final currency = settingsState.settings.currency;

        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.pop(),
            ),
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CachedNetworkImage(
                  imageUrl: "https://cdn-icons-png.flaticon.com/512/189/189715.png",
                  width: 30,
                  height: 30,
                ),
                const SizedBox(width: 8),
                const Text('Добавить расход'),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.save),
                onPressed: _saveForm,
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: 'Название',
                      prefixIcon: CachedNetworkImage(
                        imageUrl: "https://avatars.mds.yandex.net/i?id=b9fc9d04689ecc346cf000d5c217eb36_l-5303358-images-thumbs&n=13",
                        width: 24,
                        height: 24,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Пожалуйста, введите название';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _amountController,
                    decoration: InputDecoration(
                      labelText: 'Сумма (${FormatHelpers.getCurrencyLabel(currency)})',
                      prefixIcon: CachedNetworkImage(
                        imageUrl: "https://cdn-icons-png.flaticon.com/512/3135/3135706.png",
                        width: 24,
                        height: 24,
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Пожалуйста, введите сумму';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Введите корректное число';
                      }
                      if (double.parse(value) <= 0) {
                        return 'Сумма должна быть больше нуля';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _saveForm,
                    child: const Text('Сохранить'),
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
