import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'generate_home_page.dart';
import 'package:fortune_cookie/pages/profile/profile.dart';

class Generate extends StatefulWidget {
  const Generate({Key? key}) : super(key: key);

  @override
  _GenerateState createState() {
    return _GenerateState();
  }
}

class _GenerateState extends State<Generate> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        //check: if logged in, go to profile, if not, let user log in or sign up
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Something went wrong!'));
          } else if (snapshot.hasData) {
            return GenerateHomePage();
          } else {
            return Profile();
          }
        },
      ),
    );
  }
}
