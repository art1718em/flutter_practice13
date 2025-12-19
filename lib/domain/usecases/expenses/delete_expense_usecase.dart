import 'package:flutter_practice13/domain/repositories/expenses_repository.dart';

class DeleteExpenseUseCase {
  final ExpensesRepository repository;

  DeleteExpenseUseCase(this.repository);

  Future<void> call(String id) {
    return repository.deleteExpense(id);
  }
}

