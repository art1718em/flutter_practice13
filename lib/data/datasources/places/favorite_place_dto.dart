class FavoritePlaceDto {
  final String id;
  final String name;
  final String type;
  final String address;
  final String? phone;
  final double rating;
  final String? notes;
  final String? lastVisit;

  FavoritePlaceDto({
    required this.id,
    required this.name,
    required this.type,
    required this.address,
    this.phone,
    required this.rating,
    this.notes,
    this.lastVisit,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'type': type,
    'address': address,
    'phone': phone,
    'rating': rating,
    'notes': notes,
    'lastVisit': lastVisit,
  };

  factory FavoritePlaceDto.fromJson(Map<String, dynamic> json) => FavoritePlaceDto(
    id: json['id'] as String,
    name: json['name'] as String,
    type: json['type'] as String,
    address: json['address'] as String,
    phone: json['phone'] as String?,
    rating: (json['rating'] as num).toDouble(),
    notes: json['notes'] as String?,
    lastVisit: json['lastVisit'] as String?,
  );
}
