import 'package:flutter/material.dart';
import 'package:forixplayer/pages/home.dart';
import 'package:forixplayer/pages/library.dart';
import 'package:forixplayer/pages/settings.dart';

class NavBarButton {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
     Home(),
     Biblioteca(),
     Settings()
  ];
}

NavBarButton NavBar = NavBarButton();
ValueNotifier<int> buttonClickedTimes = ValueNotifier(0);

class MyNavigationBar extends StatefulWidget {
  const MyNavigationBar({super.key});

  @override
  State<MyNavigationBar> createState() => _MyNavigationBarState();
}

class _MyNavigationBarState extends State<MyNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ValueListenableBuilder(
          valueListenable: buttonClickedTimes,
          builder: (context, value, child) {
            return NavBar._pages[value];
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.blue,
          currentIndex: NavBar._selectedIndex,
          selectedItemColor: Colors.white,
          onTap: (value) {
            setState(() {
              NavBar._selectedIndex = value;
              buttonClickedTimes.value = value;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Principal',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.video_collection_sharp),
              label: 'Biblioteca',
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.settings),
              label: 'Herramientas',
            )
          ],
        ),
      );
  }
}
