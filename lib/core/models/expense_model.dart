import 'package:equatable/equatable.dart';

class ExpenseModel extends Equatable {
  final String id;
  final String vehicleId;
  final String title;
  final double amount;
  final DateTime date;

  const ExpenseModel({
    required this.id,
    required this.vehicleId,
    required this.title,
    required this.amount,
    required this.date,
  });

  ExpenseModel copyWith({
    String? id,
    String? vehicleId,
    String? title,
    double? amount,
    DateTime? date,
  }) {
    return ExpenseModel(
      id: id ?? this.id,
      vehicleId: vehicleId ?? this.vehicleId,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      date: date ?? this.date,
    );
  }

  @override
  List<Object?> get props => [id, vehicleId, title, amount, date];
}
