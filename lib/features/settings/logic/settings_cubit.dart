import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_practice13/core/models/app_settings_model.dart';
import 'package:flutter_practice13/domain/usecases/settings/get_settings_usecase.dart';
import 'package:flutter_practice13/domain/usecases/settings/update_settings_usecase.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final GetSettingsUseCase getSettingsUseCase;
  final UpdateSettingsUseCase updateSettingsUseCase;

  SettingsCubit({
    required this.getSettingsUseCase,
    required this.updateSettingsUseCase,
  }) : super(const SettingsState()) {
    loadSettings();
  }

  Future<void> loadSettings() async {
    try {
      final settings = await getSettingsUseCase();
      emit(state.copyWith(settings: settings));
    } catch (e) {
      emit(const SettingsState());
    }
  }

  Future<void> setThemeMode(AppThemeMode mode) async {
    final updatedSettings = state.settings.copyWith(themeMode: mode);
    await _updateSettings(updatedSettings);
  }

  Future<void> setCurrency(Currency currency) async {
    final updatedSettings = state.settings.copyWith(currency: currency);
    await _updateSettings(updatedSettings);
  }

  Future<void> setDistanceUnit(DistanceUnit unit) async {
    final updatedSettings = state.settings.copyWith(distanceUnit: unit);
    await _updateSettings(updatedSettings);
  }

  Future<void> toggleNotifications(bool enabled) async {
    final updatedSettings = state.settings.copyWith(notificationsEnabled: enabled);
    await _updateSettings(updatedSettings);
  }

  Future<void> toggleAutoBackup(bool enabled) async {
    final updatedSettings = state.settings.copyWith(autoBackup: enabled);
    await _updateSettings(updatedSettings);
  }

  Future<void> _updateSettings(AppSettingsModel settings) async {
    try {
      await updateSettingsUseCase(settings);
      emit(state.copyWith(settings: settings));
    } catch (e) {
      rethrow;
    }
  }

  void resetSettings() {
    emit(const SettingsState());
  }
}
