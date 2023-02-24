import 'package:flutter/material.dart';
import 'package:forixplayer/Providers/ChangeTheme.dart';
import 'package:forixplayer/class/SeachMusic.dart';
import 'package:forixplayer/pages/WidgetMusic/MusicHome.dart';
import 'package:forixplayer/pages/WidgetMusicLocal/DraggableScrollableLocalMusic.dart';
import 'package:forixplayer/pages/WidgetMusicLocal/DraggableScrollableLocalMusicAlbum.dart';
import 'package:forixplayer/pages/WidgetMusicLocal/DraggableScrollableLocalMusicArtis.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<SongModel> songs = [];
  String _Today = '';
  bool _isSheetOpenHome = true,
      _isSheetOpen = false,
      _isSheetOpenAlbum = false,
      _isSheetOpenArtist = false;

  @override
  void initState() {
    super.initState();
    _getGreeting();
    prefe();
  }

  saveprefe(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("asd", value);
  }

  prefe() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.getBool("asd") ?? false;
      print("verdadero");
    });
  }

  void _getGreeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      _Today = 'Bienvenido ¡Buenos días!';
    } else if (hour < 18) {
      _Today = 'Bienvenido ¡Buenas tardes!';
    } else {
      _Today = 'Bienvenido ¡Buenas noches!';
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeChangeProvider = Provider.of<ChangeTheme>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themeChangeProvider.isdarktheme
          ? ThemeData.dark()
          : ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text(
              _Today,
            ),
          ),
        ),
        body: Stack(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: (themeChangeProvider.isdarktheme)
                        ? Colors.grey
                        : Colors.blue,
                    foregroundColor: (themeChangeProvider.isdarktheme)
                        ? Colors.white
                        : Colors.white,
                  ),
                  child: const Text("Principal"),
                  onPressed: () {
                    setState(() {
                      saveprefe(true);
                      _isSheetOpenHome = true;
                      _isSheetOpen = false;
                      _isSheetOpenAlbum = false;
                      _isSheetOpenArtist = false;
                    });
                  },
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: (themeChangeProvider.isdarktheme)
                        ? Colors.grey
                        : Colors.blue,
                    foregroundColor: (themeChangeProvider.isdarktheme)
                        ? Colors.white
                        : Colors.white,
                  ),
                  child: const Text("Canciones"),
                  onPressed: () {
                    setState(() {
                      _isSheetOpenHome = false;
                      _isSheetOpen = true;
                      _isSheetOpenAlbum = false;
                      _isSheetOpenArtist = false;
                    });
                  },
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: (themeChangeProvider.isdarktheme)
                        ? Colors.grey
                        : Colors.blue,
                    foregroundColor: (themeChangeProvider.isdarktheme)
                        ? Colors.white
                        : Colors.white,
                  ),
                  child: const Text("Álbumes"),
                  onPressed: () {
                    setState(() {
                      _isSheetOpenHome = false;
                      _isSheetOpen = false;
                      _isSheetOpenAlbum = true;
                      _isSheetOpenArtist = false;
                    });
                  },
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: (themeChangeProvider.isdarktheme)
                        ? Colors.grey
                        : Colors.blue,
                    foregroundColor: (themeChangeProvider.isdarktheme)
                        ? Colors.white
                        : Colors.white,
                  ),
                  child: const Text("Artistas"),
                  onPressed: () {
                    setState(() {
                      _isSheetOpenHome = false;
                      _isSheetOpen = false;
                      _isSheetOpenAlbum = false;
                      _isSheetOpenArtist = true;
                    });
                  },
                ),
              ],
            ),
            if (_isSheetOpenHome) MusicHome(),
            if (_isSheetOpen) DraggableScrollableLocalMusic(),
            if (_isSheetOpenAlbum) DraggableScrollableLocalMusicAlbum(),
            if (_isSheetOpenArtist) DraggableScrollableLocalMusicArtis(),
          ],
        ),
      ),
    );
  }
}
