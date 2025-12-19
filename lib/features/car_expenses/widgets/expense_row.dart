import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_practice13/core/models/app_settings_model.dart';
import 'package:flutter_practice13/core/models/expense_model.dart';
import 'package:flutter_practice13/shared/utils/format_helpers.dart';

class ExpenseRow extends StatelessWidget {
  final ExpenseModel expense;
  final Currency currency;
  final ValueChanged<String>? onRemove;

  const ExpenseRow({
    super.key,
    required this.expense,
    required this.currency,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('dd.MM.yyyy HH:mm').format(expense.date);

    return ListTile(
      title: Text(expense.title),
      subtitle: Text(formattedDate),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            FormatHelpers.formatCurrency(expense.amount, currency),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          if (onRemove != null)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => onRemove!(expense.id),
            ),
        ],
      ),
    );
  }
}

