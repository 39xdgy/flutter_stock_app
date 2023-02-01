import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Home extends StatelessWidget {
  Home();

  @override
  Widget build(BuildContext context) {
    String hour = DateFormat.H().format(DateTime.now());
    String minute = DateFormat.m().format(DateTime.now());
    return Scaffold(
      appBar: AppBar(
        title: Text('Fortune Cookie'),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Welcome to Fortune Cookie!',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'The time is $hour:$minute',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Image.asset('assets/img/hammer.png')
          ],
        ),
      ),
    );
  }
}
