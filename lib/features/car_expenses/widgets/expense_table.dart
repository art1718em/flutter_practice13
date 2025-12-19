import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_practice13/core/models/app_settings_model.dart';
import 'package:flutter_practice13/core/models/expense_model.dart';
import 'expense_row.dart';

class ExpenseTable extends StatelessWidget {
  final List<ExpenseModel> expenses;
  final Currency currency;
  final ValueChanged<String>? onRemove;

  const ExpenseTable({
    super.key,
    required this.expenses,
    required this.currency,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    if (expenses.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CachedNetworkImage(
              imageUrl: "https://cdn4.iconfinder.com/data/icons/emoticons-outline/512/9-1024.png",
              width: 100,
              height: 100,
            ),
            const SizedBox(height: 16),
            const Text(
              'Расходов пока нет',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (context, index) {
        final expense = expenses[index];
        return ExpenseRow(
          key: ValueKey(expense.id),
          expense: expense,
          currency: currency,
          onRemove: onRemove != null ? (id) => onRemove!(id) : null,
        );
      },
    );
  }
}

