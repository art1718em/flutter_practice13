import 'package:flutter_practice13/core/models/expense_model.dart';

abstract class ExpensesRepository {
  Future<List<ExpenseModel>> getExpenses();
  Future<List<ExpenseModel>> getExpensesByVehicle(String vehicleId);
  Future<void> addExpense(ExpenseModel expense);
  Future<void> deleteExpense(String id);
  Future<double> getTotalExpenses();
  Future<double> getTotalExpensesByVehicle(String vehicleId);
}

