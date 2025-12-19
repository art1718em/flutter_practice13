import 'package:flutter_practice13/core/models/expense_model.dart';
import 'package:flutter_practice13/data/datasources/expenses/expenses_local_datasource.dart';
import 'package:flutter_practice13/domain/repositories/expenses_repository.dart';

class ExpensesRepositoryImpl implements ExpensesRepository {
  final ExpensesLocalDataSource localDataSource;

  ExpensesRepositoryImpl(this.localDataSource);

  @override
  Future<List<ExpenseModel>> getExpenses() {
    return localDataSource.getExpenses();
  }

  @override
  Future<List<ExpenseModel>> getExpensesByVehicle(String vehicleId) {
    return localDataSource.getExpensesByVehicle(vehicleId);
  }

  @override
  Future<void> addExpense(ExpenseModel expense) {
    return localDataSource.addExpense(expense);
  }

  @override
  Future<void> deleteExpense(String id) {
    return localDataSource.deleteExpense(id);
  }

  @override
  Future<double> getTotalExpenses() {
    return localDataSource.getTotalExpenses();
  }

  @override
  Future<double> getTotalExpensesByVehicle(String vehicleId) {
    return localDataSource.getTotalExpensesByVehicle(vehicleId);
  }
}

