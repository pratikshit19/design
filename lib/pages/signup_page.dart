import 'package:design/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../utils/routes.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  // Define controllers for the text fields
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                'assets/images/loginbg.png',
              ),
              fit: BoxFit.fitWidth,
              opacity: 1,
            ),
          ),
          child: Column(
            children: [
              buildHeader(context),
              buildFooter(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildHeader(BuildContext context) {
    return Flexible(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 220, left: 20, right: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Sign Up!',
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: AppColors.themeColor),
              ),
              const SizedBox(
                height: 30,
              ),
              buildTextField(fullNameController, 'Enter Full Name'),
              const SizedBox(
                height: 30,
              ),
              buildTextField(emailController, 'Enter Email'),
              const SizedBox(
                height: 30,
              ),
              buildTextField(passwordController, 'Enter Password', true),
              const SizedBox(
                height: 30,
              ),
              buildTextField(
                  confirmPasswordController, 'Confirm Password', true),
              const SizedBox(
                height: 70,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 150),
                  shape: const StadiumBorder(),
                  backgroundColor: AppColors.themeColor,
                ),
                onPressed: () async {
                  String fullName = fullNameController.text.trim();
                  String email = emailController.text.trim();
                  String password = passwordController.text.trim();
                  String confirmPassword =
                      confirmPasswordController.text.trim();

                  if (password != confirmPassword) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Passwords do not match.'),
                      ),
                    );
                    return;
                  }

                  try {
                    // Create user with email and password
                    UserCredential userCredential = await FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                      email: email,
                      password: password,
                    );

                    // Update user's display name
                    User? user = userCredential.user;
                    if (user != null) {
                      await user.updateDisplayName(fullName);
                    }

                    // Sign up successful
                    // ignore: avoid_print
                    print('User signed up successfully!');
                    // ignore: use_build_context_synchronously
                    Navigator.pushNamed(context, MyRoutes.homeRoute);
                  } catch (e) {
                    // Sign up failed
                    // ignore: avoid_print
                    print('Sign up error: $e');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Sign up error: $e'),
                      ),
                    );
                  }
                },
                child: const Text(
                  'Register',
                  style: TextStyle(fontSize: 17),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(TextEditingController controller, String hintText,
      [bool obscureText = false]) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: const Color(0xffEBFDF2).withOpacity(0.5),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Center(
          child: TextFormField(
            controller: controller,
            obscureText: obscureText,
            decoration: InputDecoration(
              fillColor: Colors.black,
              border: InputBorder.none,
              hintText: hintText,
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return "Field cannot be empty";
              }
              return null;
            },
          ),
        ),
      ),
    );
  }

  Widget buildFooter(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Already have an account?',
          style: TextStyle(color: Colors.black),
        ),
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, MyRoutes.loginRoute);
          },
          child: const Text(
            'Log In!',
            style: TextStyle(color: Colors.blue),
          ),
        ),
      ],
    );
  }
}
