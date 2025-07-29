import 'package:hotelbooking/app/core/services/shared_pref_service.dart';

abstract class AuthLocalDataSource {
  Future<void> saveUser(String name, String email, String id);
  Future<void> clearUserData();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPrefServiceHelper sharedPrefService;

  AuthLocalDataSourceImpl(this.sharedPrefService);

  @override
  Future<void> saveUser(String name, String email, String id) async {
    await sharedPrefService.saveUserName(name);
    await sharedPrefService.saveUserEmail(email);
    await sharedPrefService.saveUserId(id);
  }

  @override
  Future<void> clearUserData() async {
    await sharedPrefService.clearUserData();
  }
}
