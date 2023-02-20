import 'dart:async';
import 'package:flutter/material.dart';
import 'package:forixplayer/Providers/ChangeTheme.dart';
import 'package:forixplayer/Providers/MusicPlayer.dart';
import 'package:just_audio/just_audio.dart';
import 'package:marquee_widget/marquee_widget.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class Music extends StatefulWidget {
  final List<SongModel> MusicSongs;
  final int index;
  const Music({super.key, required this.MusicSongs, required this.index});
  @override
  State<Music> createState() => _MusicState();
}

class _MusicState extends State<Music> {
  bool iconChange = false, iconChangeshuffle = false;
  int iconChangeRepat = 0, speedSongs = 0;
  double volume = 1;
  MusicPlayer _musicPlayer = MusicPlayer();
  @override
  void initState() {
    super.initState();
    Timer(
      Duration(seconds: 2),
      () => _getMusic(),
    );
    _musicPlayer.InitState(widget.MusicSongs, widget.index);
  }

  void _getMusic() {
    setState(() {
      _musicPlayer.play();
      iconChange = !iconChange;
    });
  }

  @override
  Widget build(BuildContext context) {
    AudioPlayer player = context.watch<MusicPlayer>().player;
    final themeChangeProvider = Provider.of<ChangeTheme>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themeChangeProvider.isdarktheme
          ? ThemeData.dark()
          : ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                _musicPlayer.stop();
                Navigator.pop(context);
              },
              icon: const Icon(Icons.keyboard_arrow_down_sharp)),
          elevation: 0,
          title: Text('${_musicPlayer.currentSongTitle}'),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: _musicPlayer,
                builder: (context, value, child) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.all(10),
                    child: QueryArtworkWidget(
                      artworkFit: BoxFit.fill,
                      artworkBorder: BorderRadius.circular(0),
                      artworkQuality: FilterQuality.high,
                      keepOldArtwork: true,
                      id: _musicPlayer.currentSongID,
                      type: ArtworkType.AUDIO,
                      nullArtworkWidget: const Icon(Icons.image_not_supported,
                          size: 120, color: Colors.grey),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: _musicPlayer,
                builder: (context, value, child) {
                  return Column(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 1.5,
                        height: 30,
                        child: Center(
                          child: _buildComplexMarquee(
                              _musicPlayer.currentSongTitle),
                        ),
                      ),
                      Slider(
                        value: _musicPlayer.PositionSlider(),
                        max: _musicPlayer.DurationSlider() + 0.0,
                        onChanged: (value) {
                          setState(() {
                            player.seek(Duration(seconds: value.toInt()));
                          });
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(FormatTime(_musicPlayer.Positions())),
                            Text(FormatTime(_musicPlayer.Durations()!)),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: AudioControlTwo(context, volume),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: AudioControl(context),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
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

  Widget _buildComplexMarquee(String title) {
    return Marquee(
      autoRepeat: true,
      animationDuration: const Duration(seconds: 1),
      backDuration: const Duration(seconds: 2),
      pauseDuration: const Duration(milliseconds: 1500),
      directionMarguee: DirectionMarguee.TwoDirection,
      child: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  List<Widget> AudioControl(BuildContext context) {
    return <Widget>[
      IconButton(
        iconSize: 32,
        icon: (iconChangeshuffle == false)
            ? const Icon(
                Icons.shuffle,
                color: Colors.grey,
              )
            : const Icon(
                Icons.shuffle,
                color: Colors.black,
              ),
        onPressed: () {
          setState(() {
            switch (iconChangeshuffle) {
              case false:
                _musicPlayer.ShuffleModeEnabledFalse();
                iconChangeshuffle = !iconChangeshuffle;
                break;
              case true:
                _musicPlayer.ShuffleModeEnabledTrue();
                iconChangeshuffle = !iconChangeshuffle;
                break;
              default:
            }
          });
        },
      ),
      IconButton(
        iconSize: 48,
        icon: const Icon(Icons.skip_previous),
        onPressed: () {
          setState(() {
            _musicPlayer.seekToPrevious();
          });
        },
      ),
      IconButton(
        iconSize: 64,
        icon:
            Icon((iconChange == false) ? Icons.play_arrow : Icons.pause_sharp),
        onPressed: () {
          setState(() {
            switch (iconChange) {
              case false:
                _musicPlayer.play();
                iconChange = !iconChange;
                break;
              case true:
                _musicPlayer.stop();
                iconChange = !iconChange;
                break;
              default:
            }
          });
        },
      ),
      IconButton(
        iconSize: 48,
        icon: const Icon(Icons.skip_next),
        onPressed: () {
          setState(() {
            _musicPlayer.seekToNext();
          });
        },
      ),
      TextButton(
        child: (iconChangeRepat == 0)
            ? Icon(
                Icons.repeat,
                size: 32,
                color: Colors.grey,
              )
            : (iconChangeRepat == 1)
                ? Icon(
                    Icons.repeat_on_rounded,
                    size: 32,
                    color: Colors.black,
                  )
                : Icon(
                    Icons.repeat_one,
                    size: 32,
                    color: Colors.black,
                  ),
        onPressed: () {
          setState(() {
            switch (iconChangeRepat) {
              case 0:
                iconChangeRepat = 1;
                _musicPlayer.setLoopModeAll();
                break;
              case 1:
                iconChangeRepat = 2;
                _musicPlayer.setLoopModeOne();
                break;
              case 2:
                iconChangeRepat = 0;
                _musicPlayer.setLoopModeOff();
                break;
            }
          });
        },
      ),
    ];
  }

  List<Widget> AudioControlTwo(BuildContext context, double volume) {
    return <Widget>[
      InkWell(
        child: (speedSongs == 0)
            ? const Text(
                '1.0x',
                style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
              )
            : (speedSongs == 1)
                ? const Text(
                    '2.0x',
                    style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
                  )
                : const Text(
                    '3.0x',
                    style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
                  ),
        onTap: () {
          setState(() {
            switch (speedSongs) {
              case 0:
                _musicPlayer.SpeedX2();
                speedSongs = 1;
                break;
              case 1:
                _musicPlayer.SpeedX3();
                speedSongs = 2;
                break;
              case 2:
                _musicPlayer.SpeedX1();
                speedSongs = 0;
                break;
              default:
            }
          });
        },
      ),
      const SizedBox(
        width: 30,
      ),
      IconButton(
        icon: const Icon(
          Icons.volume_up,
          size: 34,
        ),
        onPressed: () => _showAlertVolume(context, volume),
      ),
    ];
  }

  void _showAlertVolume(BuildContext context, double volume) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Ajustar volumen"),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () => _musicPlayer.VolumenUp(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Subir Volumen",
                    style: TextStyle(color: Colors.white),
                  ),
                  Icon(Icons.volume_up, color: Colors.white),
                ],
              ),
              style: TextButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
            ),
            TextButton(
              onPressed: () => _musicPlayer.VolumenDowm(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Bajar Volumen",
                    style: TextStyle(color: Colors.white),
                  ),
                  Icon(Icons.volume_down, color: Colors.white),
                ],
              ),
              style: TextButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Entendido'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
