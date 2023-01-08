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
  int _selectedIndex = 0;
  List<Widget> _pages = [Home(), Biblioteca(), Settings()];
  // primary color nabvar - second color footer - tree color theme body
  List<Color> _colorAplicacion = [Colors.blue, Colors.blue, Colors.white];
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: new ThemeData(scaffoldBackgroundColor: _colorAplicacion[2]),
      home: Scaffold(
        /*appBar: AppBar(
          title: const Text('Forix Multimedia'),
          backgroundColor: _colorAplicacion[0],
        ),*/
        body: _pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: _colorAplicacion[1],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.white,
          onTap: (value) {
            setState(() {
              _selectedIndex = value;
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
