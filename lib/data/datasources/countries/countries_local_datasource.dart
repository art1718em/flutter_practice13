import 'package:flutter_practice13/core/storage/database_helper.dart';
import 'package:flutter_practice13/domain/entities/country.dart';
import 'package:sqflite/sqflite.dart';
import 'country_local_dto.dart';
import 'country_local_mapper.dart';

class CountriesLocalDataSource {
  final DatabaseHelper _dbHelper;

  CountriesLocalDataSource(this._dbHelper);

  Future<void> cacheCountries(List<Country> countries) async {
    final db = await _dbHelper.database;
    final batch = db.batch();

    for (final country in countries) {
      if (country.countryCode == null || country.countryCode!.isEmpty) {
        continue;
      }

      final dto = CountryLocalMapper.toDto(country);
      batch.insert(
        'countries',
        dto.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
  }

  Future<List<Country>> getCachedCountries() async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'countries',
      orderBy: 'name ASC',
    );

    return maps.map((map) {
      final dto = CountryLocalDto.fromMap(map);
      return CountryLocalMapper.toEntity(dto);
    }).toList();
  }

  Future<Country?> getCachedCountryByCode(String code) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'countries',
      where: 'countryCode = ?',
      whereArgs: [code],
      limit: 1,
    );

    if (maps.isEmpty) return null;

    final dto = CountryLocalDto.fromMap(maps.first);
    return CountryLocalMapper.toEntity(dto);
  }

  Future<void> clearCache() async {
    final db = await _dbHelper.database;
    await db.delete('countries');
  }

  Future<bool> hasCachedData() async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM countries');
    final count = Sqflite.firstIntValue(result) ?? 0;
    return count > 0;
  }

  Future<DateTime?> getLastCacheTime() async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'countries',
      columns: ['cachedAt'],
      orderBy: 'cachedAt DESC',
      limit: 1,
    );

    if (maps.isEmpty) return null;

    try {
      return DateTime.parse(maps.first['cachedAt'] as String);
    } catch (e) {
      return null;
    }
  }
}
