import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String id;
  final String email;
  final String name;
  final DateTime registrationDate;

  const UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.registrationDate,
  });

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    DateTime? registrationDate,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      registrationDate: registrationDate ?? this.registrationDate,
    );
  }

  @override
  List<Object?> get props => [id, email, name, registrationDate];
}
