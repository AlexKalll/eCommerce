import '../../models/authenticated_user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> clear();
  Future<AuthenticatedUserModel> getUser();
  Future<void> cacheUser(AuthenticatedUserModel user);
}