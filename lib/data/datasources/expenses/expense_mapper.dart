import 'package:flutter_practice13/core/models/expense_model.dart';
import 'package:flutter_practice13/data/datasources/expenses/expense_dto.dart';

extension ExpenseMapper on ExpenseDto {
  ExpenseModel toModel() {
    return ExpenseModel(
      id: id,
      vehicleId: vehicleId,
      title: title,
      amount: amount,
      date: DateTime.parse(date),
    );
  }
}

extension ExpenseModelMapper on ExpenseModel {
  ExpenseDto toDto() {
    return ExpenseDto(
      id: id,
      vehicleId: vehicleId,
      title: title,
      amount: amount,
      date: date.toIso8601String(),
    );
  }
}

