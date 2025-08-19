import 'user.dart';

class AuthenticatedUser extends User {
  final String accessToken;

  const AuthenticatedUser({
    required super.id,
    required super.name,
    required super.email,
    required this.accessToken,
  }) : assert(name.length >= 3);

  @override
  List<Object?> get props => [id, name, email, accessToken];
}