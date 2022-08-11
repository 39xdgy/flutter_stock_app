import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';

class News_list extends StatelessWidget {


  News_list();

  get_every_news(String i){

    return Card(
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {
            debugPrint('Card tapped.');
          },
          child: SizedBox(
            width: 300,
            height: 100,
            child: Column(
              children: [
                Text('A card that can be tapped number ' + i),
                const Image(
                  width: 200,
                  height: 80,
                  image: AssetImage('assets/img/logo.png')
                  )
              ]
          ),
        )
      )
    );
  }

  

  create_news_list(){
    List<Card> output = [];
    for(int i = 0; i < 10;i++){
      output.add(get_every_news(i.toString()));
    }
    return output;
  }


  @override
  Widget build(BuildContext context) {
    return ListView(
        children: create_news_list(),
        scrollDirection: Axis.vertical,
      );
  }
}