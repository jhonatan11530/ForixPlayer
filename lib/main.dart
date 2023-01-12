import 'package:flutter/material.dart';
import 'package:forixplayer/pages/home.dart';
import 'package:forixplayer/pages/library.dart';
import 'package:forixplayer/pages/settings.dart';

void main() {
  runApp(ForixPlayer());
}

class ForixPlayer extends StatefulWidget {
  const ForixPlayer({super.key});

  @override
  State<ForixPlayer> createState() => _ForixPlayerState();
}

class _ForixPlayerState extends State<ForixPlayer> {
  // primary color nabvar - second color footer - tree color theme body
  List<Color> _colorAplicacion = [Colors.blue, Colors.blue, Colors.white];
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        bottomNavigationBar: MyNavigationBar(),
      ),
    );
  }
}

class NavBarButton {
  int _selectedIndex = 0;
  List<Widget> _pages = [Home(), Biblioteca(), Settings()];
}

NavBarButton NavBar = new NavBarButton();
ValueNotifier<int> buttonClickedTimes = ValueNotifier(0);

class MyNavigationBar extends StatefulWidget {
  const MyNavigationBar({super.key});

  @override
  State<MyNavigationBar> createState() => _MyNavigationBarState();
}

class _MyNavigationBarState extends State<MyNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
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
              icon: Icon(Icons.settings),
              label: 'Herramientas',
            ),
          ],
        ),
      ),
    );
  }
}
