class ExpenseDto {
  final String id;
  final String vehicleId;
  final String title;
  final double amount;
  final String date;

  ExpenseDto({
    required this.id,
    required this.vehicleId,
    required this.title,
    required this.amount,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'vehicleId': vehicleId,
    'title': title,
    'amount': amount,
    'date': date,
  };

  factory ExpenseDto.fromJson(Map<String, dynamic> json) => ExpenseDto(
    id: json['id'] as String,
    vehicleId: json['vehicleId'] as String,
    title: json['title'] as String,
    amount: (json['amount'] as num).toDouble(),
    date: json['date'] as String,
  );
}
