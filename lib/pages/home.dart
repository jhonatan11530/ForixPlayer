import 'dart:async';

import 'package:flutter/material.dart';
import 'package:forixplayer/Providers/ChangeTheme.dart';
import 'package:forixplayer/pages/WidgetMusicLocal/DraggableScrollableLocalMusic.dart';
import 'package:forixplayer/pages/WidgetMusicLocal/DraggableScrollableLocalMusicAlbum.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  List<SongModel> songs = [];
  String _Today = '';
  bool _isSheetOpen = false, _isSheetOpenAlbum = false;

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
        body: Container(
          child: Stack(
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
                    child: const Text("Canciones"),
                    onPressed: () {
                      setState(() {
                        _isSheetOpen = true;
                        _isSheetOpenAlbum = false;
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
                        _isSheetOpen = false;
                        _isSheetOpenAlbum = true;
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
                        _isSheetOpen = true;
                        _isSheetOpenAlbum = false;
                      });
                    },
                  ),
                ],
              ),
              if (_isSheetOpen) DraggableScrollableLocalMusic(),
              if (_isSheetOpenAlbum) DraggableScrollableLocalMusicAlbum(),
            ],
          ),
        ),
      ),
    );
  }
}
