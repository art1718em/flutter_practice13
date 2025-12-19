import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_practice13/core/models/expense_model.dart';
import 'package:flutter_practice13/domain/usecases/expenses/get_expenses_usecase.dart';
import 'package:flutter_practice13/domain/usecases/expenses/add_expense_usecase.dart';
import 'package:flutter_practice13/domain/usecases/expenses/delete_expense_usecase.dart';
import 'car_expenses_state.dart';

class CarExpensesCubit extends Cubit<CarExpensesState> {
  final GetExpensesUseCase getExpensesUseCase;
  final AddExpenseUseCase addExpenseUseCase;
  final DeleteExpenseUseCase deleteExpenseUseCase;

  CarExpensesCubit({
    required this.getExpensesUseCase,
    required this.addExpenseUseCase,
    required this.deleteExpenseUseCase,
  }) : super(const CarExpensesState());

  Future<void> loadExpenses() async {
    try {
      final expenses = await getExpensesUseCase();
      emit(state.copyWith(expenses: expenses));
    } catch (e) {
      emit(state.copyWith(expenses: []));
    }
  }

  Future<void> addExpense(String vehicleId, String title, double amount) async {
    final newExpense = ExpenseModel(
      id: '',
      vehicleId: vehicleId,
      title: title,
      amount: amount,
      date: DateTime.now(),
    );

    try {
      await addExpenseUseCase(newExpense);
      await loadExpenses();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> removeExpense(String id) async {
    final expenseIndex = state.expenses.indexWhere((expense) => expense.id == id);
    if (expenseIndex < 0) {
      return;
    }

    final expenseToRemove = state.expenses[expenseIndex];

    try {
      await deleteExpenseUseCase(id);
      await loadExpenses();
      
      emit(state.copyWith(
        recentlyRemovedExpense: expenseToRemove,
        recentlyRemovedExpenseIndex: expenseIndex,
      ));
    } catch (e) {
      rethrow;
    }
  }

  Future<void> undoRemove() async {
    if (state.recentlyRemovedExpense != null) {
      try {
        await addExpenseUseCase(state.recentlyRemovedExpense!);
        await loadExpenses();
        emit(state.copyWith(clearRecentlyRemoved: true));
      } catch (e) {
        rethrow;
      }
    }
  }

  void clearUndoState() {
    emit(state.copyWith(clearRecentlyRemoved: true));
  }

  void clearExpenses() {
    emit(const CarExpensesState());
  }
}
