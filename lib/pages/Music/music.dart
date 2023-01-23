import 'dart:async';

import 'package:flutter/material.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:marquee/marquee.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:rxdart/rxdart.dart';

class Todo {
  List<SongModel> MusicSongs;
  Todo(this.MusicSongs);
}

class Music extends StatefulWidget {
  final List<SongModel> todos;
  const Music({super.key, required this.todos});
  @override
  State<Music> createState() => _MusicState();
}

class _MusicState extends State<Music> {
  bool iconChange = false, iconChangeshuffle = false;
  int iconChangeRepat = 0, currentSongImage = 0;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  List<SongModel> songs = [];
  String currentSongTitle = '';
  final advancedPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _musicInit();
  }

  _musicInit() async {
    await advancedPlayer.setAudioSource(createPlaylist(widget.todos));

    advancedPlayer.positionStream.listen((Duration p) {
      setState(() => position = p);
    });

    advancedPlayer.durationStream.listen((d) {
      setState(() => duration = d!);
    });

    advancedPlayer.currentIndexStream.listen((index) {
      if (index != null) {
        currentSongImage = widget.todos[index].id;
        _updateCurrentPlayingSongDetails(widget.todos, index);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    advancedPlayer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          scaffoldBackgroundColor: Color.fromARGB(255, 255, 255, 255)),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(100, 114, 114, 114),
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.keyboard_arrow_down_sharp)),
          elevation: 0,
          title: Text('Press the button with a label below!'),
        ),
        body: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(20),
              child: QueryArtworkWidget(
                id: currentSongImage,
                type: ArtworkType.AUDIO,
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width / 1.5,
              height: 30,
              child: _buildComplexMarquee(currentSongTitle),
            ),
            Container(
              child: Slider(
                value: position.inSeconds.toDouble(),
                max: duration.inSeconds.toDouble() + 0.0,
                onChanged: (value) {
                  setState(() {
                    advancedPlayer.seek(Duration(seconds: value.toInt()));
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(FormatTime(position)),
                    Text(FormatTime(duration)),
                  ]),
            ),
            Container(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: AudioControl(context)),
            ),
          ],
        ),
      ),
    );
  }

  String FormatTime(Duration value) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final Hours = twoDigits(value.inHours);
    final Minutes = twoDigits(value.inMinutes.remainder(60));
    final Seconds = twoDigits(value.inSeconds.remainder(60));
    return [if (value.inHours > 0) Hours, Minutes, Seconds].join(":");
  }

  Widget _buildComplexMarquee(String titulo) {
    return Marquee(
      text: titulo,
      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
      scrollAxis: Axis.horizontal,
      crossAxisAlignment: CrossAxisAlignment.start,
      blankSpace: 20.0,
      velocity: 50.0,
      pauseAfterRound: Duration(seconds: 5),
      startPadding: 0,
      accelerationDuration: Duration(seconds: 1),
      accelerationCurve: Curves.linear,
      decelerationDuration: Duration(milliseconds: 500),
      decelerationCurve: Curves.easeOut,
    );
  }

  List<Widget> AudioControl(BuildContext context) {
    return <Widget>[
      Expanded(
          child: IconButton(
        iconSize: MediaQuery.of(context).size.height / 20,
        icon: (iconChangeshuffle == false)
            ? Icon(Icons.shuffle, color: Colors.grey)
            : Icon(Icons.shuffle),
        onPressed: () {
          setState(() {
            switch (iconChangeshuffle) {
              case false:
                advancedPlayer.shuffle();
                advancedPlayer.setShuffleModeEnabled(false);
                iconChangeshuffle = !iconChangeshuffle;
                break;
              case true:
                advancedPlayer.shuffle();
                advancedPlayer.setShuffleModeEnabled(true);
                iconChangeshuffle = !iconChangeshuffle;
                break;
              default:
            }
          });
        },
      )),
      Expanded(
        child: IconButton(
          iconSize: MediaQuery.of(context).size.height / 15,
          icon: Icon(Icons.skip_previous),
          onPressed: () {
            setState(() {
              advancedPlayer.seekToPrevious();
            });
          },
        ),
      ),
      Expanded(
        child: IconButton(
          iconSize: MediaQuery.of(context).size.height / 10,
          icon: Icon(
              (iconChange == false) ? Icons.play_arrow : Icons.pause_sharp),
          onPressed: () {
            setState(() {
              switch (iconChange) {
                case false:
                  advancedPlayer.play();
                  iconChange = !iconChange;
                  break;
                case true:
                  advancedPlayer.stop();
                  iconChange = !iconChange;
                  break;
                default:
              }
            });
          },
        ),
      ),
      Expanded(
        child: IconButton(
          iconSize: MediaQuery.of(context).size.height / 15,
          icon: Icon(Icons.skip_next),
          onPressed: () {
            setState(() {
              advancedPlayer.seekToNext();
            });
          },
        ),
      ),
      Expanded(
        child: IconButton(
          iconSize: MediaQuery.of(context).size.height / 20,
          icon: Icon((iconChangeRepat == 0)
              ? Icons.repeat
              : (iconChangeRepat == 1)
                  ? Icons.repeat_on_rounded
                  : (iconChangeRepat == 2)
                      ? Icons.repeat_one
                      : null),
          onPressed: () {
            setState(() {
              switch (iconChangeRepat) {
                case 0:
                  iconChangeRepat = 1;
                  advancedPlayer.setLoopMode(LoopMode.all);
                  break;
                case 1:
                  iconChangeRepat = 2;
                  advancedPlayer.setLoopMode(LoopMode.one);
                  break;
                case 2:
                  iconChangeRepat = 0;
                  advancedPlayer.setLoopMode(LoopMode.off);
                  break;
              }
            });
          },
        ),
      ),
    ];
  }

  ConcatenatingAudioSource createPlaylist(List<SongModel> songs) {
    List<AudioSource> sources = [];
    for (var song in songs) {
      sources.add(AudioSource.uri(Uri.parse(song.uri!),
          tag: MediaItem(
              id: '${song.id}',
              title: song.title,
              artUri: Uri.parse(song.uri!))));
    }
    return ConcatenatingAudioSource(children: sources);
  }

  void _updateCurrentPlayingSongDetails(List<SongModel> songs, int index) {
    setState(() {
      currentSongTitle = songs[index].title;
    });
  }
}
