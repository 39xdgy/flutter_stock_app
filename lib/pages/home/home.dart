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
        title: Text('RICH'),
        backgroundColor: Colors.green,
      ),
      body: Text(hour + ":" + minute),
    );
  }
}
