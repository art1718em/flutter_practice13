import 'package:shared_preferences/shared_preferences.dart';

class PreferencesHelper {
  static PreferencesHelper? _instance;
  static SharedPreferences? _preferences;

  static const String _keyThemeMode = 'theme_mode';
  static const String _keyCurrency = 'currency';
  static const String _keyDistanceUnit = 'distance_unit';
  static const String _keyNotificationsEnabled = 'notifications_enabled';
  static const String _keyAutoBackup = 'auto_backup';

  PreferencesHelper._();

  static Future<PreferencesHelper> getInstance() async {
    if (_instance == null) {
      _instance = PreferencesHelper._();
      await _instance!._init();
    }
    return _instance!;
  }

  Future<void> _init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  Future<bool> setThemeMode(String mode) async {
    if (_preferences == null) await _init();
    return await _preferences!.setString(_keyThemeMode, mode);
  }

  String getThemeMode() {
    if (_preferences == null) throw Exception('PreferencesHelper не инициализирован');
    return _preferences!.getString(_keyThemeMode) ?? 'system';
  }

  Future<bool> setCurrency(String currency) async {
    if (_preferences == null) await _init();
    return await _preferences!.setString(_keyCurrency, currency);
  }

  String getCurrency() {
    if (_preferences == null) throw Exception('PreferencesHelper не инициализирован');
    return _preferences!.getString(_keyCurrency) ?? 'rub';
  }

  Future<bool> setDistanceUnit(String unit) async {
    if (_preferences == null) await _init();
    return await _preferences!.setString(_keyDistanceUnit, unit);
  }

  String getDistanceUnit() {
    if (_preferences == null) throw Exception('PreferencesHelper не инициализирован');
    return _preferences!.getString(_keyDistanceUnit) ?? 'kilometers';
  }

  Future<bool> setNotificationsEnabled(bool enabled) async {
    if (_preferences == null) await _init();
    return await _preferences!.setBool(_keyNotificationsEnabled, enabled);
  }

  bool getNotificationsEnabled() {
    if (_preferences == null) throw Exception('PreferencesHelper не инициализирован');
    return _preferences!.getBool(_keyNotificationsEnabled) ?? true;
  }

  Future<bool> setAutoBackup(bool enabled) async {
    if (_preferences == null) await _init();
    return await _preferences!.setBool(_keyAutoBackup, enabled);
  }

  bool getAutoBackup() {
    if (_preferences == null) throw Exception('PreferencesHelper не инициализирован');
    return _preferences!.getBool(_keyAutoBackup) ?? false;
  }

  Future<bool> clear() async {
    if (_preferences == null) await _init();
    return await _preferences!.clear();
  }
}
