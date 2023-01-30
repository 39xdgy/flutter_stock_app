import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';

class Generate extends StatelessWidget {
  Generate();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Generate'),
          backgroundColor: Colors.green,
        ),
        body: Text('This is generate'),
      ),
    );
  }
}
