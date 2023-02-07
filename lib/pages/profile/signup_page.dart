import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fortune_cookie/main.dart';
import 'package:fortune_cookie/widgets/utils.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SignUpWidget extends StatefulWidget {
  final Function() onClickedSignIn;

  const SignUpWidget({
    Key? key,
    required this.onClickedSignIn,
  }) : super(key: key);

  @override
  _SignUpWidgetState createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    userNameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              const SizedBox(height: 20),
              const Text(
                'Fortune Cookie',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 40),
              TextFormField(
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                ),
                controller: emailController,
                cursorColor: Colors.white,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(labelText: 'Email'),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (email) =>
                    email != null && !EmailValidator.validate(email)
                        ? 'Enter a valid email'
                        : null,
              ),
              const SizedBox(height: 4),
              // TextFormField(
              //   style: const TextStyle(
              //     fontSize: 22,
              //     fontWeight: FontWeight.normal,
              //     color: Colors.white,
              //   ),
              //   controller: userNameController,
              //   textInputAction: TextInputAction.next,
              //   decoration: const InputDecoration(labelText: 'Nickname'),
              //   obscureText: false,
              //   autovalidateMode: AutovalidateMode.onUserInteraction,
              //   validator: (value) => value != null && value.length > 20
              //       ? 'Enter max. 20 characters'
              //       : null,
              // ),
              const SizedBox(height: 4),
              TextFormField(
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                ),
                controller: passwordController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => value != null && value.length < 6
                    ? 'Enter min. 6 characters'
                    : null,
              ),
              const SizedBox(height: 4),
              TextFormField(
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                ),
                controller: confirmPasswordController,
                textInputAction: TextInputAction.done,
                decoration:
                    const InputDecoration(labelText: 'Confirm Password'),
                obscureText: true,
                validator: (value) =>
                    passwordController.text != confirmPasswordController.text
                        ? 'Passwords do not match'
                        : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  backgroundColor: Color.fromARGB(193, 250, 50, 130),
                ),
                icon: const Icon(Icons.arrow_forward, size: 32),
                label: const Text(
                  'Sign Up',
                  style: TextStyle(fontSize: 24),
                ),
                onPressed: signUp,
              ),
              const SizedBox(height: 20),
              RichText(
                text: TextSpan(
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                  text: 'Already have an account?  ',
                  children: [
                    TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = widget.onClickedSignIn,
                      text: 'Log In',
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

  Future signUp() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      //pop up error message
      switch (e.code) {
        case 'email-already-in-use':
          Utils.showSnackBar('The account already exists for that email.');
          break;
        case 'invalid-email':
          Utils.showSnackBar('This is not a valid email.');
          break;
        case 'operation-not-allowed':
          Utils.showSnackBar(
              'Signing in with Email and Password is not enabled.');
          break;
        case 'weak-password':
          Utils.showSnackBar('The password provided is too weak.');
          break;
        default:
          Utils.showSnackBar('An undefined Error happened.');
      }
    } catch (e) {
      Utils.showSnackBar("Something went wrong. Please try again later.");
    }

    // Hide loading circle
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
