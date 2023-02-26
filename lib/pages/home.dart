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
  List<SongModel> _music = [];
  int _index = 0;
  bool _isSheetOpenHome = false,
      _isSheetOpenMusic = false,
      _isSheetOpenAlbum = false,
      _isSheetOpenArtist = false;

  List<SongModel> get music => _music;
  set music(List<SongModel> value) => _music = value;

  int get index => _index;
  set index(int value) => _index = value;

//--------------------------- // -----------------------//

  bool get isSheetOpenHome => _isSheetOpenHome;
  set isSheetOpenHome(bool value) => _isSheetOpenHome = value;

  bool get isSheetOpenMusic => _isSheetOpenMusic;
  set isSheetOpenMusic(bool value) => _isSheetOpenMusic = value;

  bool get isSheetOpenAlbum => _isSheetOpenAlbum;
  set isSheetOpenAlbum(bool value) => _isSheetOpenAlbum = value;

  bool get isSheetOpenArtist => _isSheetOpenArtist;
  set isSheetOpenArtist(bool value) => _isSheetOpenArtist = value;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int reproductorValue = 0;
  List<SongModel> songs = [];
  String _Today = '';

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
                      widget.isSheetOpenHome = true;
                      widget.isSheetOpenMusic = false;
                      widget.isSheetOpenAlbum = false;
                      widget.isSheetOpenArtist = false;
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
                      widget.isSheetOpenHome = false;
                      widget.isSheetOpenMusic = true;
                      widget.isSheetOpenAlbum = false;
                      widget.isSheetOpenArtist = false;
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
                      widget.isSheetOpenHome = false;
                      widget.isSheetOpenMusic = false;
                      widget.isSheetOpenAlbum = true;
                      widget.isSheetOpenArtist = false;
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
                      widget.isSheetOpenHome = false;
                      widget.isSheetOpenMusic = false;
                      widget.isSheetOpenAlbum = false;
                      widget.isSheetOpenArtist = true;
                    });
                  },
                ),
              ],
            ),
            if (ChangeProductor.isReplay)
              Music(
                MusicSongs: widget.music,
                index: widget.index,
              ),
            if (widget.isSheetOpenHome) MusicHome(),
            if (widget.isSheetOpenMusic) DraggableScrollableLocalMusic(),
            if (widget.isSheetOpenAlbum) DraggableScrollableLocalMusicAlbum(),
            if (widget.isSheetOpenArtist) DraggableScrollableLocalMusicArtis(),
          ],
        ),
      ),
    );
  }
}
