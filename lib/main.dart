import 'package:flutter/material.dart';
import './bottom_bar.dart';
import 'pages/intro.dart';

import './pages/intro.dart';
// void main(){
//   runApp(MyApp());
// }

void main() => runApp(MyApp());

class MyApp extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {


  @override
  build(BuildContext context){
    return Intro();
  }
}