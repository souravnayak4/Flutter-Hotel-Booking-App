import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hotelbooking/app/core/services/database.dart';
import 'package:hotelbooking/app/core/services/shared_pref_service.dart';
import 'package:hotelbooking/app/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:hotelbooking/app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:hotelbooking/app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:hotelbooking/app/features/auth/presentation/pages/login_page.dart';

Future<void> logoutUser(BuildContext context) async {
  final authRepo = AuthRepositoryImpl(
    AuthRemoteDataSourceImpl(FirebaseAuth.instance),
    AuthLocalDataSourceImpl(SharedPrefServiceHelper()),
    DatabaseMethods(),
  );

  try {
    await authRepo.logout();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  } catch (e) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Logout failed: $e")));
  }
}
