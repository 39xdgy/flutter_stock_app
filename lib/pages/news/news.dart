import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';

import '../../bottom_bar.dart';
import './news_list.dart';
class News extends StatelessWidget {


  News();


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('My First App')
          ),
        bottomNavigationBar: Bottom_bar(),
        body: News_list()
      )
    );
    
  }
}