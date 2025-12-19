class UserProfileDto {
  final String userId;
  final String name;
  final String email;
  final String? phone;
  final String? avatar;
  final String? drivingLicenseNumber;
  final int? drivingExperienceYears;

  UserProfileDto({
    required this.userId,
    required this.name,
    required this.email,
    this.phone,
    this.avatar,
    this.drivingLicenseNumber,
    this.drivingExperienceYears,
  });

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'name': name,
    'email': email,
    'phone': phone,
    'avatar': avatar,
    'drivingLicenseNumber': drivingLicenseNumber,
    'drivingExperienceYears': drivingExperienceYears,
  };

  factory UserProfileDto.fromJson(Map<String, dynamic> json) => UserProfileDto(
    userId: json['userId'] as String,
    name: json['name'] as String,
    email: json['email'] as String,
    phone: json['phone'] as String?,
    avatar: json['avatar'] as String?,
    drivingLicenseNumber: json['drivingLicenseNumber'] as String?,
    drivingExperienceYears: json['drivingExperienceYears'] as int?,
  );
}
