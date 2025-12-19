class ServiceRecordDto {
  final String id;
  final String vehicleId;
  final String title;
  final String type;
  final String date;
  final int? mileage;
  final List<String> worksDone;
  final String? serviceCenter;
  final String? notes;
  final String? nextServiceDate;

  ServiceRecordDto({
    required this.id,
    required this.vehicleId,
    required this.title,
    required this.type,
    required this.date,
    this.mileage,
    required this.worksDone,
    this.serviceCenter,
    this.notes,
    this.nextServiceDate,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'vehicleId': vehicleId,
    'title': title,
    'type': type,
    'date': date,
    'mileage': mileage,
    'worksDone': worksDone,
    'serviceCenter': serviceCenter,
    'notes': notes,
    'nextServiceDate': nextServiceDate,
  };

  factory ServiceRecordDto.fromJson(Map<String, dynamic> json) => ServiceRecordDto(
    id: json['id'] as String,
    vehicleId: json['vehicleId'] as String,
    title: json['title'] as String,
    type: json['type'] as String,
    date: json['date'] as String,
    mileage: json['mileage'] as int?,
    worksDone: (json['worksDone'] as List<dynamic>).map((e) => e as String).toList(),
    serviceCenter: json['serviceCenter'] as String?,
    notes: json['notes'] as String?,
    nextServiceDate: json['nextServiceDate'] as String?,
  );
}
