import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';

import '../bottom_bar.dart';
class Intro extends StatelessWidget {


  Intro();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('My First App')
          ),
        bottomNavigationBar: Bottom_bar(),
        body: Text('This is Intro page')
      )
    );
    
  }
}