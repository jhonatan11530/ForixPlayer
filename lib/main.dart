import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:forixplayer/pages/home.dart';
import 'package:forixplayer/pages/library.dart';
import 'package:forixplayer/pages/settings.dart';
import 'package:on_audio_query/on_audio_query.dart';

void main() {
  runApp(ForixPlayer());
}

class ForixPlayer extends StatefulWidget {
  const ForixPlayer({super.key});

  @override
  State<ForixPlayer> createState() => _ForixPlayerState();
}

class _ForixPlayerState extends State<ForixPlayer> {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  // primary color nabvar - second color footer - tree color theme body
  List<Color> _colorAplicacion = [Colors.blue, Colors.blue, Colors.white];

  @override
  void initState() {
    super.initState();

    requestStoragePermission();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        //bottomNavigationBar: MyNavigationBar(),
      ),
    );
  }

  void requestStoragePermission() async {
    //only if the platform is not web, coz web have no permissions
    if (!kIsWeb) {
      bool permissionStatus = await _audioQuery.permissionsStatus();
      if (!permissionStatus) {
        await _audioQuery.permissionsRequest();

        MaterialApp(
          home: Scaffold(
            bottomNavigationBar: MyNavigationBar(),
          ),
        );
      }

      //ensure build method is called
      setState(() {});
    }
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
