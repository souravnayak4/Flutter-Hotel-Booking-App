import 'package:flutter/material.dart';
import 'package:hotelbooking/app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:hotelbooking/app/core/services/network_service.dart';

class SignupController extends ChangeNotifier {
  final AuthRepositoryImpl authRepository;

  SignupController(this.authRepository);

  bool isLoading = false;

  Future<String?> registerUser({
    required String userType,
    required String name,
    required String email,
    required String password,
  }) async {
    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      return "Please fill all fields";
    }
    // Validate userType
    if (userType != 'guest' && userType != 'owner') {
      return "Please select a valid user type";
    }

    bool hasInternet = await NetworkServiceHelper.hasInternetConnection();
    if (!hasInternet) {
      return "No Internet Connection";
    }

    try {
      isLoading = true;
      notifyListeners();

      await authRepository.signup(name, email, password, userType);

      isLoading = false;
      notifyListeners();
      return null; // Success
    } catch (e) {
      isLoading = false;
      notifyListeners();
      return "Registration failed: ${e.toString()}";
    }
  }
}
