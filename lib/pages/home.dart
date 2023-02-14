import 'dart:async';

import 'package:flutter/material.dart';
import 'package:forixplayer/Providers/ChangeTheme.dart';
import 'package:forixplayer/pages/LocalMusic.dart';
import 'package:forixplayer/pages/Music/MusicAlbum.dart';

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
  String Descripcion = "Como Quieres Empezar";
  @override
  void initState() {
    super.initState();
    _getGreeting();
  }

  void _getGreeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      _Today = '¡Buenos días!';
    } else if (hour < 18) {
      _Today = '¡Buenas tardes!';
    } else {
      _Today = '¡Buenas noches!';
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
        body: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 120,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _Today,
                    style: const TextStyle(
                        fontSize: 35, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    Descripcion,
                    style: const TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Card(
                  child: InkWell(
                    onTap: () {
                      print("tapped");
                    },
                    child: Stack(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.center,
                          child: Image.asset(
                            "assets/YouTube-Music-Logo.png",
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const Align(
                          alignment: Alignment(0, -0.70),
                          child: Text(
                            "Escuchar Musica en ",
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: 25),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Card(
                  child: InkWell(
                    onTap: () {
                      print("tapped");
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => LocalMusic()),
                      );
                    },
                    child: Stack(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.music_note,
                            size: 120,
                          ),
                        ),
                        const Align(
                          alignment: Alignment(0, -0.70),
                          child: Text(
                            "Escuchar Musica En el Equipo",
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: 25),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
