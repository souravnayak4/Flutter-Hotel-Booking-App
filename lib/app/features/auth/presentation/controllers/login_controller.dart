import 'package:flutter/material.dart';
import 'package:hotelbooking/app/features/auth/domain/auth_repository.dart';

class LoginController with ChangeNotifier {
  final AuthRepository authRepository;

  bool isLoading = false;
  String? errorMessage;

  LoginController(this.authRepository);

  Future<void> login(String email, String password) async {
    isLoading = true;
    notifyListeners();

    try {
      await authRepository.login(email, password);
      errorMessage = null;
    } catch (e) {
      errorMessage = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }
}
