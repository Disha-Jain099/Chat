import 'package:chat/Screens/signup.dart';
import 'package:chat/Screens/textfield.dart';
import 'package:chat/Widget/button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Services/authentication.dart';
import '../Widget/snack_bar.dart';
import 'homescreen.dart';

class Loginscreen extends StatefulWidget {
  const Loginscreen({super.key});

  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {

  // Controllers

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  bool isLoading = false;
  void setFirebaseLocale() {
    FirebaseAuth.instance.setLanguageCode('en'); // Replace 'en' with your preferred language code
  }

  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }

  void loginUser() async {
    setState(() {
      isLoading = true;
    });

    String res = await AuthServices().loginUser(
      email: emailController.text.trim(),
      password: passController.text.trim(),
    );

    if (mounted) {
      if (res == "success") {
        print("Login successful! Navigating to Home Screen...");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => Homescreen()),
        );
      } else {

        setState(() {
          isLoading = false;
        });
        showSnackBar(context, res);
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: height,
          ),
          child: IntrinsicHeight(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 70),
                  child: SizedBox(
                    width: double.infinity,
                    height: height * 0.25,
                    child: Image.asset("images/msg.png"),
                  ),
                ),
                const SizedBox(height: 20),
                Textfield(
                  textEditingController: emailController,
                  hintText: "Enter your email",
                  icon: Icons.email,
                ),
                Textfield(
                  textEditingController: passController,
                  hintText: "Enter your password",
                  isPass: true,
                  icon: Icons.lock,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 35),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        // Navigate to "Forgot Password" screen or add functionality
                        showSnackBar(context, "Forgot Password feature coming soon.");
                      },
                      child: const Text(
                        "Forgot Password?",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                ),
                isLoading
                    ? const CircularProgressIndicator()
                    : Button(
                  onTab: loginUser,
                  text: "Log In",
                ),
                SizedBox(height: height / 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account?",
                      style: TextStyle(fontSize: 16),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => Signup()),
                        );
                      },
                      child: const Text(
                        " SignUp",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
