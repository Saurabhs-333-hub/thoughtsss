import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thoughtsss/constants/ui_constants.dart';
import 'package:velocity_x/velocity_x.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _page = 0;
  void onPageChange(int index) {
    setState(() {
      _page = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(alignment: Alignment.bottomCenter, children: [
      IndexedStack(
        index: _page,
        children: UIConstants().bottombarpages,
      ),
      Positioned(
          bottom: 0,
          child: Container(
            height: 60,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                  Color.fromARGB(170, 0, 0, 0),
                  // Color.fromARGB(170, 0, 0, 0),
                  // Color.fromARGB(81, 0, 0, 0),
                  Color.fromARGB(0, 0, 0, 0)
                ])),
          )),
      Positioned(
        bottom: 10,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(40),
          child: Container(
              width: 250,
              // height: 40,
              // color: Color.fromARGB(255, 255, 255, 255),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: Color(Vx.getColorFromHex('#121212'))),
              child: CupertinoTabBar(
                backgroundColor: Color(Vx.getColorFromHex('#121212')),
                currentIndex: _page,
                onTap: onPageChange,
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(
                      _page == 0 ? Icons.home : Icons.home,
                      color: const Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      _page == 1 ? Icons.home : Icons.home,
                      color: const Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      _page == 2 ? Icons.home : Icons.home,
                      color: const Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                ],
              )),
        ),
      )
    ]));
  }
}
