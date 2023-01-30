import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  RoundedButton(
      {required this.colour, required this.title, required this.onPressed});
  final Color colour;
  final String title;
  final Function onPressed;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: colour,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: onPressed(),
          //Go to login screen.
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            title,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class Utils {
  static final messengerKey = GlobalKey<ScaffoldMessengerState>();

  static showSnackBar(String? text) {
    if (text == null) return;
    final snackBar = SnackBar(content: Text(text), backgroundColor: Colors.red);
    if (messengerKey.currentState != null) {
      messengerKey.currentState?.removeCurrentSnackBar();
      messengerKey.currentState?.showSnackBar(snackBar);
    }
  }

  static showSnackBarBlue(String? text) {
    if (text == null) return;
    final snackBar = SnackBar(
        content: Text(text), backgroundColor: Color.fromARGB(255, 33, 50, 238));
    if (messengerKey.currentState != null) {
      messengerKey.currentState?.removeCurrentSnackBar();
      messengerKey.currentState?.showSnackBar(snackBar);
    }
  }
}
