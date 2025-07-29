import 'package:hotelbooking/app/features/auth/domain/auth_repository.dart';
import 'package:hotelbooking/app/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:hotelbooking/app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:hotelbooking/app/core/services/database.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final DatabaseMethods databaseMethods;

  AuthRepositoryImpl(
    this.remoteDataSource,
    this.localDataSource,
    this.databaseMethods,
  );

  @override
  Future<void> signup(
    String name,
    String email,
    String password,
    String userType,
  ) async {
    // Create user in Firebase Auth and get UID
    String uid = await remoteDataSource.signup(email, password);

    // Prepare user data including userType
    Map<String, dynamic> userMap = {
      "Name": name,
      "Email": email,
      "Id": uid,
      "UserType": userType,
    };

    // Save user info locally
    await localDataSource.saveUser(name, email, uid);

    // Save user info in Firestore
    await databaseMethods.addUserInfo(userMap, uid);
  }

  @override
  Future<void> login(String email, String password) async {
    await remoteDataSource.login(email, password);
  }

  @override
  Future<void> logout() async {
    await remoteDataSource.logout();
    await localDataSource.clearUserData();
  }

  @override
  Future<String> getUserType(String uid) async {
    final userData = await databaseMethods.getUserInfo(uid);

    // print("Fetched user data for UID $uid: $userData");

    if (userData != null && userData.containsKey('UserType')) {
      final type = userData['UserType'];
      if (type is String) {
        // print(
        //   "User type resolved as: ${type.toLowerCase().trim()}",
        // );
        return type.toLowerCase().trim();
      }
    }

    // print("User type not found. Defaulting to 'guest'");
    return 'guest';
  }
}
