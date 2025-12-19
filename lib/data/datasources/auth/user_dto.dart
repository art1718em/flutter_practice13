class UserDto {
  final String id;
  final String email;
  final String password;
  final String name;
  final String registrationDate;

  UserDto({
    required this.id,
    required this.email,
    required this.password,
    required this.name,
    required this.registrationDate,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'password': password,
    'name': name,
    'registrationDate': registrationDate,
  };

  factory UserDto.fromJson(Map<String, dynamic> json) => UserDto(
    id: json['id'] as String,
    email: json['email'] as String,
    password: json['password'] as String,
    name: json['name'] as String,
    registrationDate: json['registrationDate'] as String,
  );
}
