import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fortune_cookie/pages/profile/profile_home_page.dart';
import 'package:fortune_cookie/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:fortune_cookie/pages/home/home.dart';
import 'personal_data_page.dart';
import 'package:fortune_cookie/services/user.dart';
import 'dart:math';

class VerifyEmailPage extends StatefulWidget {
  @override
  _VerifyEmailPageState createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  bool isEmailVerified = false;
  bool canResendEmail = false;
  Timer? timer;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  UserService userService = UserService();

  @override
  void initState() {
    super.initState();

    /// user needs to be created before!
    isEmailVerified = _auth.currentUser!.emailVerified;

    if (!isEmailVerified) {
      sendVerificationEmail();

      timer = Timer.periodic(
        //check if the user verified email every 3 seconds
        Duration(seconds: 3),
        //add api call to backend
        (_) => checkEmailVerified(),
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future checkEmailVerified() async {
    // call after email verification!
    await _auth.currentUser!.reload();

    setState(() {
      isEmailVerified = _auth.currentUser!.emailVerified;
    });

    if (isEmailVerified) {
      // update user data
      var random = Random();
      //print(_auth.currentUser!.uid);
      //print(_auth.currentUser!.email);
      // var res = await userService.createUser(
      //   _auth.currentUser!.uid,
      //   "Cookie Monster ${random.nextInt(10000)}",
      //   _auth.currentUser!.email!,
      // );
      // print(res);
      // stop timer
      timer?.cancel();
    }
  }

  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();

      setState(() => canResendEmail = false);
      // wait 60 seconds before user can resend email
      await Future.delayed(Duration(seconds: 60));
      setState(() => canResendEmail = true);
    } catch (e) {
      Utils.showSnackBar(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) => isEmailVerified
      ? ProfileHomePage()
      : Scaffold(
          appBar: AppBar(
            title: Text('Verify Email'),
          ),
          body: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'A verification email has been sent to your email.',
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size.fromHeight(50),
                  ),
                  icon: Icon(Icons.email, size: 32),
                  label: Text(
                    'Resent Email',
                    style: TextStyle(fontSize: 24),
                  ),
                  onPressed: canResendEmail ? sendVerificationEmail : null,
                ),
                SizedBox(height: 8),
                TextButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size.fromHeight(50),
                  ),
                  child: Text(
                    'Cancel',
                    style: TextStyle(fontSize: 24),
                  ),
                  onPressed: () => FirebaseAuth.instance.signOut(),
                ),
              ],
            ),
          ),
        );
}
