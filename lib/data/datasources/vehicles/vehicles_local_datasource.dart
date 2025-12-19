import 'package:flutter_practice13/core/models/vehicle_model.dart';
import 'package:flutter_practice13/core/storage/database_helper.dart';
import 'package:flutter_practice13/core/storage/secure_storage_helper.dart';
import 'package:flutter_practice13/data/datasources/vehicles/vehicle_dto.dart';
import 'package:flutter_practice13/data/datasources/vehicles/vehicle_mapper.dart';
import 'package:uuid/uuid.dart';

class VehiclesLocalDataSource {
  final _uuid = const Uuid();
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  final SecureStorageHelper _secureStorage;

  VehiclesLocalDataSource(this._secureStorage);

  Future<List<VehicleModel>> getVehicles() async {
    final userId = await _secureStorage.getUserId();
    if (userId == null) return [];

    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'vehicles',
      where: 'userId = ?',
      whereArgs: [userId],
    );

    return maps.map((map) {
      final mapWithBool = Map<String, dynamic>.from(map);
      mapWithBool['isActive'] = map['isActive'] == 1;
      return VehicleDto.fromJson(mapWithBool).toModel();
    }).toList();
  }

  Future<VehicleModel> getVehicleById(String id) async {
    final userId = await _secureStorage.getUserId();
    if (userId == null) throw Exception('Пользователь не авторизован');

    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'vehicles',
      where: 'id = ? AND userId = ?',
      whereArgs: [id, userId],
    );

    if (maps.isEmpty) {
      throw Exception('Автомобиль с id $id не найден');
    }

    final map = maps.first;
    final mapWithBool = Map<String, dynamic>.from(map);
    mapWithBool['isActive'] = map['isActive'] == 1;
    return VehicleDto.fromJson(mapWithBool).toModel();
  }

  Future<void> addVehicle(VehicleModel vehicle) async {
    final userId = await _secureStorage.getUserId();
    if (userId == null) throw Exception('Пользователь не авторизован');

    final db = await _dbHelper.database;

    await db.update(
      'vehicles',
      {'isActive': 0},
      where: 'userId = ? AND isActive = ?',
      whereArgs: [userId, 1],
    );

    final newVehicle = VehicleModel(
      id: _uuid.v4(),
      brand: vehicle.brand,
      model: vehicle.model,
      year: vehicle.year,
      vin: vehicle.vin,
      licensePlate: vehicle.licensePlate,
      color: vehicle.color,
      mileage: vehicle.mileage,
      purchaseDate: vehicle.purchaseDate,
      isActive: true,
      vehicleType: vehicle.vehicleType,
    );

    final json = newVehicle.toDto().toJson();
    json['userId'] = userId;
    json['isActive'] = newVehicle.isActive ? 1 : 0;
    await db.insert('vehicles', json);
  }

  Future<void> updateVehicle(VehicleModel vehicle) async {
    final userId = await _secureStorage.getUserId();
    if (userId == null) throw Exception('Пользователь не авторизован');

    final db = await _dbHelper.database;
    final json = vehicle.toDto().toJson();
    json['userId'] = userId;
    json['isActive'] = vehicle.isActive ? 1 : 0;

    final result = await db.update(
      'vehicles',
      json,
      where: 'id = ? AND userId = ?',
      whereArgs: [vehicle.id, userId],
    );

    if (result == 0) {
      throw Exception('Автомобиль с id ${vehicle.id} не найден');
    }
  }

  Future<void> deleteVehicle(String id) async {
    final userId = await _secureStorage.getUserId();
    if (userId == null) throw Exception('Пользователь не авторизован');

    final db = await _dbHelper.database;
    await db.delete(
      'vehicles',
      where: 'id = ? AND userId = ?',
      whereArgs: [id, userId],
    );
  }

  Future<void> setActiveVehicle(String id) async {
    final userId = await _secureStorage.getUserId();
    if (userId == null) throw Exception('Пользователь не авторизован');

    final db = await _dbHelper.database;

    await db.update(
      'vehicles',
      {'isActive': 0},
      where: 'userId = ?',
      whereArgs: [userId],
    );

    await db.update(
      'vehicles',
      {'isActive': 1},
      where: 'id = ? AND userId = ?',
      whereArgs: [id, userId],
    );
  }
}

