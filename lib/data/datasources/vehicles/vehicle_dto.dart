class VehicleDto {
  final String id;
  final String brand;
  final String model;
  final int year;
  final String? vin;
  final String? licensePlate;
  final String? color;
  final int? mileage;
  final String? purchaseDate;
  final bool isActive;

  VehicleDto({
    required this.id,
    required this.brand,
    required this.model,
    required this.year,
    this.vin,
    this.licensePlate,
    this.color,
    this.mileage,
    this.purchaseDate,
    required this.isActive,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'brand': brand,
    'model': model,
    'year': year,
    'vin': vin,
    'licensePlate': licensePlate,
    'color': color,
    'mileage': mileage,
    'purchaseDate': purchaseDate,
    'isActive': isActive,
  };

  factory VehicleDto.fromJson(Map<String, dynamic> json) => VehicleDto(
    id: json['id'] as String,
    brand: json['brand'] as String,
    model: json['model'] as String,
    year: json['year'] as int,
    vin: json['vin'] as String?,
    licensePlate: json['licensePlate'] as String?,
    color: json['color'] as String?,
    mileage: json['mileage'] as int?,
    purchaseDate: json['purchaseDate'] as String?,
    isActive: json['isActive'] as bool,
  );
}
