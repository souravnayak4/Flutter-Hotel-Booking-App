import 'package:flutter/material.dart';
import 'package:hotelbooking/app/features/hotel/PageHelper/widgets/commonHelpers/main_navigation_page.dart';
import 'package:provider/provider.dart';
import 'package:hotelbooking/app/features/auth/presentation/controllers/signup_controller.dart';
import 'package:hotelbooking/app/core/widgets/widget_support.dart';
import 'login_page.dart';
import 'package:hotelbooking/app/features/owner/presentation/pages/owner_home_page.dart'; // Make sure this import is correct

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  String selectedUserType = 'guest'; // default value
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final signupController = Provider.of<SignupController>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset('images/signup.png', height: 200, width: 200),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text("Sign Up", style: AppWidget.headelinetextstyle(28)),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                "Please enter the details to continue.",
                style: AppWidget.normaltextstyle(18),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),

            /// User Type Toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _userTypeTile("Guest", Icons.person, 'guest'),
                _userTypeTile("Hotel Owner", Icons.business, 'owner'),
              ],
            ),
            const SizedBox(height: 25),

            /// Name
            const Text(
              "Name",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            _buildTextField(
              controller: nameController,
              hintText: "Enter your name",
              icon: Icons.person,
            ),

            /// Email
            const SizedBox(height: 20),
            const Text(
              "Email",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            _buildTextField(
              controller: emailController,
              hintText: "Enter your email",
              icon: Icons.email,
            ),

            /// Password
            const SizedBox(height: 20),
            const Text(
              "Password",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            _buildTextField(
              controller: passwordController,
              hintText: "Enter your password",
              icon: Icons.lock,
              obscureText: true,
            ),

            const SizedBox(height: 30),

            /// Sign Up Button
            Center(
              child: GestureDetector(
                onTap: signupController.isLoading
                    ? null
                    : () async {
                        final name = nameController.text.trim();
                        final email = emailController.text.trim();
                        final password = passwordController.text.trim();

                        final result = await signupController.registerUser(
                          userType: selectedUserType,
                          name: name,
                          email: email,
                          password: password,
                        );

                        if (result == null) {
                          // success
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Sign Up Successful"),
                              backgroundColor: Colors.green,
                            ),
                          );
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => selectedUserType == 'owner'
                                  ? const OwnerAdminPage()
                                  : const MainNavigationPage(),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(result),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                child: Container(
                  height: 55,
                  width: MediaQuery.of(context).size.width * 0.8,
                  decoration: BoxDecoration(
                    color: signupController.isLoading
                        ? Colors.grey
                        : const Color(0xFF0766B3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: signupController.isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "Sign Up",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already have an account?",
                  style: AppWidget.normaltextstyle(16),
                ),
                const SizedBox(width: 5),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginPage()),
                    );
                  },
                  child: const Text(
                    "Login",
                    style: TextStyle(
                      color: Color(0xFF0766B3),
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

  /// Reusable text field
  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool obscureText = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F6FA),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: const Color(0xFF0766B3)),
          border: InputBorder.none,
          hintText: hintText,
          contentPadding: const EdgeInsets.symmetric(vertical: 15.0),
        ),
      ),
    );
  }

  /// User Type Selector
  Widget _userTypeTile(String label, IconData icon, String value) {
    final isSelected = selectedUserType == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedUserType = value;
        });
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFF0766B3)
                  : Colors.grey.shade200,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: isSelected ? Colors.white : Colors.black),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isSelected ? const Color(0xFF0766B3) : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
