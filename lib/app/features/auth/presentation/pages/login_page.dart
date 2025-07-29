import 'package:flutter/material.dart';
import 'package:hotelbooking/app/features/auth/presentation/controllers/login_controller.dart';
import 'package:hotelbooking/app/features/owner/presentation/pages/owner_hotel_details.dart';
import 'package:hotelbooking/main.dart';
import 'package:provider/provider.dart';
import 'package:hotelbooking/app/core/widgets/widget_support.dart';
import 'signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<LoginController>(context);

    //  Show error message automatically when it changes
    if (controller.errorMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(controller.errorMessage!),
            backgroundColor: Colors.red,
          ),
        );
        controller.errorMessage = null; // Reset after showing
      });
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Image
            Center(
              child: Image.asset(
                'images/login.png',
                height: 250,
                width: 250,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 30.0),

            /// Title
            Center(
              child: Text('Log In', style: AppWidget.headelinetextstyle(28)),
            ),
            const SizedBox(height: 8.0),

            /// Subtitle
            Center(
              child: Text(
                'Please enter your details to continue',
                style: AppWidget.normaltextstyle(18),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 30.0),

            /// Email Label
            const Padding(
              padding: EdgeInsets.only(left: 5.0),
              child: Text(
                'Email',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(height: 8.0),

            /// Email Field
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF5F6FA),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.mail, color: Color(0xFF0766B3)),
                  border: InputBorder.none,
                  hintText: 'Enter email',
                  contentPadding: EdgeInsets.symmetric(vertical: 15.0),
                ),
              ),
            ),
            const SizedBox(height: 20.0),

            /// Password Label
            const Padding(
              padding: EdgeInsets.only(left: 5.0),
              child: Text(
                'Password',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(height: 8.0),

            /// Password Field
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF5F6FA),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.lock, color: Color(0xFF0766B3)),
                  border: InputBorder.none,
                  hintText: 'Enter password',
                  contentPadding: EdgeInsets.symmetric(vertical: 15.0),
                ),
              ),
            ),
            const SizedBox(height: 10.0),

            /// Forgot Password
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                child: const Text(
                  'Forgot Password?',
                  style: TextStyle(
                    color: Color(0xFF0766B3),
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20.0),

            /// Login Button
            Center(
              child: GestureDetector(
                onTap: controller.isLoading
                    ? null
                    : () async {
                        final email = emailController.text.trim();
                        final password = passwordController.text.trim();

                        if (email.isNotEmpty && password.isNotEmpty) {
                          await controller.login(email, password);

                          if (controller.errorMessage == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Login Successful"),
                                backgroundColor: Colors.green,
                              ),
                            );

                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (_) => const MyApp()),
                              (route) => false,
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please fill all fields'),
                            ),
                          );
                        }
                      },

                child: Container(
                  height: 55.0,
                  width: MediaQuery.of(context).size.width * 0.8,
                  decoration: BoxDecoration(
                    color: controller.isLoading
                        ? Colors.grey
                        : const Color(0xFF0766B3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: controller.isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Log In',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15.0),

            /// Sign Up Section
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have an account? ",
                  style: AppWidget.normaltextstyle(18.0),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignupPage(),
                      ),
                    );
                  },
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(
                      color: Color(0xFF0766B3),
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
