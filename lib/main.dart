import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:hotelbooking/app/core/services/shared_pref_service.dart';
import 'package:hotelbooking/app/core/services/stripe_key.dart';
import 'package:hotelbooking/app/core/services/database.dart';

import 'package:hotelbooking/app/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:hotelbooking/app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:hotelbooking/app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:hotelbooking/app/features/auth/presentation/controllers/login_controller.dart';
import 'package:hotelbooking/app/features/auth/presentation/controllers/signup_controller.dart';
import 'package:hotelbooking/app/features/auth/presentation/pages/login_page.dart';

import 'package:hotelbooking/app/features/hotel/PageHelper/widgets/commonHelpers/main_navigation_page.dart';
import 'package:hotelbooking/app/features/owner/presentation/pages/owner_home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  Stripe.publishableKey = Publishablekey;

  runApp(
    MultiProvider(
      providers: [
        Provider<AuthRepositoryImpl>(
          create: (_) => AuthRepositoryImpl(
            AuthRemoteDataSourceImpl(FirebaseAuth.instance),
            AuthLocalDataSourceImpl(SharedPrefServiceHelper()),
            DatabaseMethods(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              LoginController(context.read<AuthRepositoryImpl>()),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              SignupController(context.read<AuthRepositoryImpl>()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hotel Booking',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      debugShowCheckedModeBanner: false,
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData) {
          final user = snapshot.data!;
          final authRepo = context.read<AuthRepositoryImpl>(); // Use repo

          return FutureBuilder<String>(
            future: authRepo.getUserType(user.uid), // Use repo method
            builder: (context, typeSnapshot) {
              if (typeSnapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }

              if (typeSnapshot.hasData) {
                final userType = typeSnapshot.data!;
                // print(" Redirecting based on userType: $userType");

                if (userType.toLowerCase() == 'owner') {
                  return const OwnerAdminPage();
                } else {
                  return const MainNavigationPage();
                }
              }

              return const LoginPage(); // fallback
            },
          );
        }

        return const LoginPage(); // Not logged in
      },
    );
  }
}
