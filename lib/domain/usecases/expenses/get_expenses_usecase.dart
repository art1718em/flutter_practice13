import 'package:flutter_practice13/core/models/expense_model.dart';
import 'package:flutter_practice13/domain/repositories/expenses_repository.dart';

class GetExpensesUseCase {
  final ExpensesRepository repository;

  GetExpensesUseCase(this.repository);

  Future<List<ExpenseModel>> call() {
    return repository.getExpenses();
  }
}

