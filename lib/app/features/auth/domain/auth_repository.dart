abstract class AuthRepository {
  Future<void> signup(
    String name,
    String email,
    String password,
    String userType,
  );
  Future<void> login(String email, String password);
  Future<void> logout();

  Future<String> getUserType(String uid);
}
