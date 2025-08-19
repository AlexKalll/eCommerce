import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    required super.name,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'],
      email: json['email'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'email': email,
      'name': name,
    };
  }

  static UserModel fromEntity(User user) {
    return UserModel(
      id: user.id,
      email: user.email,
      name: user.name,
    );
  }
}