import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'home/home.dart';
import 'generate/generate.dart';
import 'profile/profile.dart';

class Nav extends StatefulWidget {
  const Nav({Key? key}) : super(key: key);

  @override
  _IntroState createState() => _IntroState();
}

class _IntroState extends State<Nav> {
  List pages = [
    Home(),
    Generate(),
    Profile(),
  ];
  int currentIndex = 0;
  void onTap(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  var hour = int.parse(DateFormat.H().format(DateTime.now()));
  var minute = int.parse(DateFormat.m().format(DateTime.now()));
  Color getBackgroundColor() {
    if (hour >= 16 || hour < 9) {
      return Color.fromARGB(255, 109, 21, 56);
    } else if (hour == 9 && minute < 30) {
      return Color.fromARGB(255, 109, 21, 56);
    } else {
      return Color.fromARGB(193, 250, 50, 130);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.rocket_launch),
            label: "Generate",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
        type: BottomNavigationBarType.fixed,
        backgroundColor: getBackgroundColor(),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withOpacity(0.5),
        showSelectedLabels: true,
        showUnselectedLabels: false,
      ),
    );
  }
}
