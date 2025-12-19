import 'package:flutter_practice13/core/models/favorite_place_model.dart';
import 'package:flutter_practice13/core/storage/database_helper.dart';
import 'package:flutter_practice13/core/storage/secure_storage_helper.dart';
import 'package:flutter_practice13/data/datasources/places/favorite_place_dto.dart';
import 'package:flutter_practice13/data/datasources/places/favorite_place_mapper.dart';
import 'package:uuid/uuid.dart';

class PlacesLocalDataSource {
  final _uuid = const Uuid();
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  final SecureStorageHelper _secureStorage;

  PlacesLocalDataSource(this._secureStorage);

  Future<List<FavoritePlaceModel>> getPlaces() async {
    final userId = await _secureStorage.getUserId();
    if (userId == null) return [];

    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'favorite_places',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'name ASC',
    );

    return maps.map((map) => FavoritePlaceDto.fromJson(map).toModel()).toList();
  }

  Future<FavoritePlaceModel> getPlaceById(String id) async {
    final userId = await _secureStorage.getUserId();
    if (userId == null) throw Exception('Пользователь не авторизован');

    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'favorite_places',
      where: 'id = ? AND userId = ?',
      whereArgs: [id, userId],
    );

    if (maps.isEmpty) {
      throw Exception('Место с id $id не найдено');
    }

    return FavoritePlaceDto.fromJson(maps.first).toModel();
  }

  Future<void> addPlace(FavoritePlaceModel place) async {
    final userId = await _secureStorage.getUserId();
    if (userId == null) throw Exception('Пользователь не авторизован');

    final db = await _dbHelper.database;
    final newPlace = FavoritePlaceModel(
      id: _uuid.v4(),
      name: place.name,
      type: place.type,
      address: place.address,
      phone: place.phone,
      rating: place.rating,
      notes: place.notes,
      lastVisit: place.lastVisit,
    );

    final json = newPlace.toDto().toJson();
    json['userId'] = userId;
    await db.insert('favorite_places', json);
  }

  Future<void> updatePlace(FavoritePlaceModel place) async {
    final userId = await _secureStorage.getUserId();
    if (userId == null) throw Exception('Пользователь не авторизован');

    final db = await _dbHelper.database;
    final json = place.toDto().toJson();
    json['userId'] = userId;

    final result = await db.update(
      'favorite_places',
      json,
      where: 'id = ? AND userId = ?',
      whereArgs: [place.id, userId],
    );

    if (result == 0) {
      throw Exception('Место с id ${place.id} не найдено');
    }
  }

  Future<void> deletePlace(String id) async {
    final userId = await _secureStorage.getUserId();
    if (userId == null) throw Exception('Пользователь не авторизован');

    final db = await _dbHelper.database;
    await db.delete(
      'favorite_places',
      where: 'id = ? AND userId = ?',
      whereArgs: [id, userId],
    );
  }
}

