import 'package:demo/pages/intro.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';

import './pages/home.dart';
import 'pages/news/news.dart';
import 'pages/people/people.dart';
import 'pages/profile/profile.dart';
import 'pages/train/train.dart';

class Bottom_bar extends StatelessWidget {

 // final VoidCallback selectPageFunction;
  Bottom_bar();


  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      color: Colors.blue,
      notchMargin: 1.0,
      child: IconTheme(
        data: IconThemeData(color: Colors.white),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              tooltip: 'Open Chat menu',
              icon: const Icon(Icons.people),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => People()));
              },
            ),
            IconButton(
              tooltip: 'Open Train menu',
              icon: const Icon(Icons.train),
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => Train()));
              },
            ),
            IconButton(
              tooltip: 'Open Home menu',
              icon: const Icon(Icons.home),
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
              },
            ),
            IconButton(
              tooltip: 'Open Profile menu',
              icon: const Icon(Icons.account_box_outlined),
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => Profile()));
              },
            ),
            IconButton(
              tooltip: 'Open News menu',
              icon: const Icon(Icons.newspaper),
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => News()));
              },
            )
          ],
          )
        )
    );
  }
}