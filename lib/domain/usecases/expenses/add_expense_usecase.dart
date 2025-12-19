import 'package:flutter_practice13/core/models/expense_model.dart';
import 'package:flutter_practice13/domain/repositories/expenses_repository.dart';

class AddExpenseUseCase {
  final ExpensesRepository repository;

  AddExpenseUseCase(this.repository);

  Future<void> call(ExpenseModel expense) {
    return repository.addExpense(expense);
  }
}

