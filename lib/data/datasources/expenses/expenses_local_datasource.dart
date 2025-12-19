import 'package:flutter_practice13/core/models/expense_model.dart';
import 'package:flutter_practice13/core/storage/database_helper.dart';
import 'package:flutter_practice13/core/storage/secure_storage_helper.dart';
import 'package:flutter_practice13/data/datasources/expenses/expense_dto.dart';
import 'package:flutter_practice13/data/datasources/expenses/expense_mapper.dart';
import 'package:uuid/uuid.dart';

class ExpensesLocalDataSource {
  final _uuid = const Uuid();
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  final SecureStorageHelper _secureStorage;

  ExpensesLocalDataSource(this._secureStorage);

  Future<List<ExpenseModel>> getExpenses() async {
    final userId = await _secureStorage.getUserId();
    if (userId == null) return [];

    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'expenses',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'date DESC',
    );

    return maps.map((map) => ExpenseDto.fromJson(map).toModel()).toList();
  }

  Future<List<ExpenseModel>> getExpensesByVehicle(String vehicleId) async {
    final userId = await _secureStorage.getUserId();
    if (userId == null) return [];

    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'expenses',
      where: 'userId = ? AND vehicleId = ?',
      whereArgs: [userId, vehicleId],
      orderBy: 'date DESC',
    );

    return maps.map((map) => ExpenseDto.fromJson(map).toModel()).toList();
  }

  Future<void> addExpense(ExpenseModel expense) async {
    final userId = await _secureStorage.getUserId();
    if (userId == null) throw Exception('Пользователь не авторизован');

    final db = await _dbHelper.database;
    final newExpense = ExpenseModel(
      id: _uuid.v4(),
      vehicleId: expense.vehicleId,
      title: expense.title,
      amount: expense.amount,
      date: DateTime.now(),
    );

    final json = newExpense.toDto().toJson();
    json['userId'] = userId;
    await db.insert('expenses', json);
  }

  Future<void> deleteExpense(String id) async {
    final userId = await _secureStorage.getUserId();
    if (userId == null) throw Exception('Пользователь не авторизован');

    final db = await _dbHelper.database;
    await db.delete(
      'expenses',
      where: 'id = ? AND userId = ?',
      whereArgs: [id, userId],
    );
  }

  Future<double> getTotalExpenses() async {
    final userId = await _secureStorage.getUserId();
    if (userId == null) return 0.0;

    final db = await _dbHelper.database;
    final result = await db.rawQuery(
      'SELECT SUM(amount) as total FROM expenses WHERE userId = ?',
      [userId],
    );
    final total = result.first['total'];
    return total != null ? (total as num).toDouble() : 0.0;
  }

  Future<double> getTotalExpensesByVehicle(String vehicleId) async {
    final userId = await _secureStorage.getUserId();
    if (userId == null) return 0.0;

    final db = await _dbHelper.database;
    final result = await db.rawQuery(
      'SELECT SUM(amount) as total FROM expenses WHERE userId = ? AND vehicleId = ?',
      [userId, vehicleId],
    );
    final total = result.first['total'];
    return total != null ? (total as num).toDouble() : 0.0;
  }
}

