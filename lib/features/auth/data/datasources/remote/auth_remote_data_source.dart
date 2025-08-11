import '../../models/login_model.dart';
import '../../models/register_model.dart';
import '../../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<AccessToken> login(LoginModel loginModel);
  Future<UserModel> register(RegisterModel registerModel);
  Future<UserModel> getCurrentUser();
}