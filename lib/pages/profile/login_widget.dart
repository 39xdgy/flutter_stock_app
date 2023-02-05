import 'package:firebase_auth/firebase_auth.dart';
import 'package:fortune_cookie/utils/utils.dart';
import 'package:fortune_cookie/main.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fortune_cookie/utils/utils.dart';
import 'forgot_password_page.dart';

class LoginWidget extends StatefulWidget {
  final VoidCallback onClickedSignUp;
  const LoginWidget({
    Key? key,
    required this.onClickedSignUp,
  }) : super(key: key);

  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              const SizedBox(height: 20),
              const Text(
                'RICH',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(height: 40),
              TextField(
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                ),
                controller: emailController,
                cursorColor: Colors.white,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelStyle: TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                  labelText: 'Email',
                ),
              ),
              const SizedBox(height: 4),
              TextField(
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                ),
                controller: passwordController,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  labelStyle: TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                  labelText: 'Password',
                ),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  backgroundColor: Color.fromARGB(193, 250, 50, 130),
                ),
                icon: const Icon(Icons.lock_open, size: 32),
                label: const Text(
                  'Sign In',
                  style: TextStyle(fontSize: 24),
                ),
                onPressed: signIn,
              ),
              SizedBox(height: 24),
              GestureDetector(
                child: Text(
                  'Forgot Password?',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 20,
                  ),
                ),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ForgotPasswordPage(),
                  ),
                ),
              ),
              SizedBox(height: 16),
              RichText(
                text: TextSpan(
                  style: TextStyle(color: Colors.white, fontSize: 20),
                  text: 'No account?  ',
                  children: [
                    TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = widget.onClickedSignUp,
                      text: 'Sign Up',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  Future signIn() async {
    //display loading circle
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      //add pop up error message here
      print(e);
      switch (e.code) {
        case 'network-request-failed':
          Utils.showSnackBar('Please check your internet connection.');
          break;
        case 'user-not-found':
          Utils.showSnackBar('No user found for that email.');
          break;
        case 'wrong-password':
          Utils.showSnackBar('Wrong password.');
          break;
        case 'invalid-email':
          Utils.showSnackBar('Invalid email.');
          break;
        case 'unknown':
          Utils.showSnackBar('Please type in your email and password.');
          break;
      }
    } catch (e) {
      Utils.showSnackBar("Something went wrong. Please try again later.");
    }

    // Hide loading circle
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
