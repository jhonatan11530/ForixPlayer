import 'package:flutter/material.dart';
import 'package:forixplayer/Preferences/DarkThemePreferences.dart';
import 'package:forixplayer/Providers/ChangeReplay.dart';
import 'package:forixplayer/Providers/ChangeTheme.dart';
import 'package:forixplayer/pages/WidgetMusic/MusicHome.dart';
import 'package:forixplayer/pages/WidgetMusicLocal/DraggableScrollableLocalMusic.dart';
import 'package:forixplayer/pages/WidgetMusicLocal/DraggableScrollableLocalMusicAlbum.dart';
import 'package:forixplayer/pages/WidgetMusicLocal/DraggableScrollableLocalMusicArtis.dart';
import 'package:forixplayer/pages/WidgetMusicLocal/Reproductor/Reproductor.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int reproductorValue = 0;
  List<SongModel> songs = [];
  String _Today = '';
  bool _isSheetOpenHome = false,
      _isSheetOpenMusic = false,
      _isSheetOpenAlbum = false,
      _isSheetOpenArtist = false;

  @override
  void initState() {
    super.initState();
    _getGreeting();

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
    final ChangeProductor = Provider.of<ChangeReplay>(context);
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
                      //ChangeProductor.isReplay = true;
                      _isSheetOpenHome = true;
                      _isSheetOpenMusic = false;
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
                      _isSheetOpenMusic = true;
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
                      _isSheetOpenMusic = false;
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
                      _isSheetOpenMusic = false;
                      _isSheetOpenAlbum = false;
                      _isSheetOpenArtist = true;
                    });
                  },
                ),
              ],
            ),
            /*if (ChangeProductor.isReplay)
              Music(
                MusicSongs: music,
                index: index,
              ),*/
            if (_isSheetOpenHome) MusicHome(),
            if (_isSheetOpenMusic) DraggableScrollableLocalMusic(),
            if (_isSheetOpenAlbum) DraggableScrollableLocalMusicAlbum(),
            if (_isSheetOpenArtist) DraggableScrollableLocalMusicArtis(),
          ],
        ),
      ),
    );
  }
}
