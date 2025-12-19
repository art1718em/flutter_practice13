import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_practice13/features/settings/logic/settings_cubit.dart';
import 'package:flutter_practice13/features/settings/logic/settings_state.dart';
import 'package:flutter_practice13/core/models/app_settings_model.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Настройки'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          final settings = state.settings;

          return ListView(
            children: [
              const _SectionHeader(title: 'Внешний вид'),
              ListTile(
                leading: const Icon(Icons.palette),
                title: const Text('Тема'),
                subtitle: Text(settings.themeMode.displayName),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showThemeDialog(context, settings.themeMode),
              ),
              const Divider(),
              const _SectionHeader(title: 'Единицы измерения'),
              ListTile(
                leading: const Icon(Icons.attach_money),
                title: const Text('Валюта'),
                subtitle: Text(settings.currency.displayName),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showCurrencyDialog(context, settings.currency),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.straighten),
                title: const Text('Расстояние'),
                subtitle: Text(settings.distanceUnit.displayName),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showDistanceDialog(context, settings.distanceUnit),
              ),
              const Divider(),
              const _SectionHeader(title: 'О приложении'),
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('Версия приложения'),
                subtitle: const Text('1.0.0'),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: OutlinedButton.icon(
                  onPressed: () {
                    _showResetDialog(context);
                  },
                  icon: const Icon(Icons.restore),
                  label: const Text('Сбросить настройки'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showThemeDialog(BuildContext context, AppThemeMode currentMode) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Выберите тему'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: AppThemeMode.values.map((mode) {
            return RadioListTile<AppThemeMode>(
              title: Text(mode.displayName),
              value: mode,
              groupValue: currentMode,
              onChanged: (value) {
                if (value != null) {
                  context.read<SettingsCubit>().setThemeMode(value);
                  Navigator.of(dialogContext).pop();
                }
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showCurrencyDialog(BuildContext context, Currency currentCurrency) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Выберите валюту'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: Currency.values.map((currency) {
            return RadioListTile<Currency>(
              title: Text(currency.displayName),
              value: currency,
              groupValue: currentCurrency,
              onChanged: (value) {
                if (value != null) {
                  context.read<SettingsCubit>().setCurrency(value);
                  Navigator.of(dialogContext).pop();
                }
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showDistanceDialog(BuildContext context, DistanceUnit currentUnit) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Выберите единицу расстояния'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: DistanceUnit.values.map((unit) {
            return RadioListTile<DistanceUnit>(
              title: Text(unit.displayName),
              value: unit,
              groupValue: currentUnit,
              onChanged: (value) {
                if (value != null) {
                  context.read<SettingsCubit>().setDistanceUnit(value);
                  Navigator.of(dialogContext).pop();
                }
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showResetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Сбросить настройки?'),
        content: const Text('Все настройки будут возвращены к значениям по умолчанию.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              context.read<SettingsCubit>().resetSettings();
              Navigator.of(dialogContext).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Настройки сброшены')),
              );
            },
            child: const Text('Сбросить'),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}

