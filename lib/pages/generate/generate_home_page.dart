import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';

class GenerateHomePage extends StatefulWidget {
  const GenerateHomePage({Key? key}) : super(key: key);

  @override
  _GenerateHomePageState createState() {
    return _GenerateHomePageState();
  }
}

class _GenerateHomePageState extends State<GenerateHomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Generate'),
        backgroundColor: Colors.green,
      ),
      body: Text('This is generate',
          style: Theme.of(context).textTheme.displayLarge),
    );
  }
}
