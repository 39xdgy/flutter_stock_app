import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';

import '../../bottom_bar.dart';
class People extends StatelessWidget {

  People();

  People_page(){
    return Column(
      children: [
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ElevatedButton(
                onPressed: (){}, 
                child: Text('Chat'),
                style: ElevatedButton.styleFrom(
                  shape: CircleBorder(),
                  minimumSize: Size(70, 70)
                )
              ),
              ElevatedButton(
                onPressed: (){}, 
                child: Text('Blog'),
                style: ElevatedButton.styleFrom(
                  shape: CircleBorder(),
                  minimumSize: Size(70, 70)
                )
              ),
              ElevatedButton(
                onPressed: (){}, 
                child: Text('Ranking'),
                style: ElevatedButton.styleFrom(
                  shape: CircleBorder(),
                  minimumSize: Size(70, 70)
                )
              )
            ],
          )
        ),
        Container(
          // TODO, card of all the upvote blogs
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('My First App')
          ),
        bottomNavigationBar: Bottom_bar(),
        body: People_page()
      )
    );
  }
}