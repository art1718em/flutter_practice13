import 'package:equatable/equatable.dart';
import 'package:flutter_practice13/core/models/expense_model.dart';

class CarExpensesState extends Equatable {
  final List<ExpenseModel> expenses;
  final ExpenseModel? recentlyRemovedExpense;
  final int? recentlyRemovedExpenseIndex;

  const CarExpensesState({
    this.expenses = const [],
    this.recentlyRemovedExpense,
    this.recentlyRemovedExpenseIndex,
  });

  double getTotalAmount(String? vehicleId) {
    if (vehicleId == null) return 0.0;
    return expenses
        .where((e) => e.vehicleId == vehicleId)
        .fold(0.0, (sum, item) => sum + item.amount);
  }

  List<ExpenseModel> getExpensesByVehicle(String? vehicleId) {
    if (vehicleId == null) return [];
    return expenses.where((e) => e.vehicleId == vehicleId).toList();
  }

  CarExpensesState copyWith({
    List<ExpenseModel>? expenses,
    ExpenseModel? recentlyRemovedExpense,
    int? recentlyRemovedExpenseIndex,
    bool clearRecentlyRemoved = false,
  }) {
    return CarExpensesState(
      expenses: expenses ?? this.expenses,
      recentlyRemovedExpense: clearRecentlyRemoved
          ? null
          : recentlyRemovedExpense ?? this.recentlyRemovedExpense,
      recentlyRemovedExpenseIndex: clearRecentlyRemoved
          ? null
          : recentlyRemovedExpenseIndex ?? this.recentlyRemovedExpenseIndex,
    );
  }

  @override
  List<Object?> get props =>
      [expenses, recentlyRemovedExpense, recentlyRemovedExpenseIndex];
}

