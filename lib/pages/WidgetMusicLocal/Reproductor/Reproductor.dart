import 'dart:async';
import 'package:flutter/material.dart';
import 'package:forixplayer/Providers/MusicPlayer.dart';
import 'package:just_audio/just_audio.dart';
import 'package:marquee_widget/marquee_widget.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class Music extends StatelessWidget {
  final List<SongModel> MusicSongs;
  final int index;
  Music({super.key, required this.MusicSongs, required this.index});

  bool iconChange = false, iconChangeshuffle = false;
  int iconChangeRepat = 0, speedSongs = 0;
  double volume = 1;
  MusicPlayer _musicPlayer = MusicPlayer();

  @override
  Widget build(BuildContext context) {
    AudioPlayer player = context.watch<MusicPlayer>().player;
    initState();
    return DraggableScrollableSheet(
      minChildSize: 0.1,
      maxChildSize: 1.0,
      initialChildSize: 1.0,
      builder: (context, scrollController) {
        return SingleChildScrollView(
          controller: scrollController,
          child: Container(
              child: Column(
            children: [
              ChangeNotifierProvider(
                create: (_) => _musicPlayer,
                child: Consumer<MusicPlayer>(
                  builder: (context, value, child) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 3.5,
                      padding: const EdgeInsets.all(5),
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
              ChangeNotifierProvider(
                create: (_) => _musicPlayer,
                child: Consumer<MusicPlayer>(
                  builder: (context, valueChange, child) {
                    return Column(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 1.5,
                          height: 30,
                          child: Center(
                            child: _buildComplexMarquee(
                                valueChange.currentSongTitle),
                          ),
                        ),
                        Slider(
                          value: valueChange.PositionSlider() ?? 0,
                          max: valueChange.DurationSlider() ?? 0,
                          onChanged: (value) {
                            player.seek(Duration(seconds: value.toInt()));
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15, right: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(FormatTime(valueChange.Positions())),
                              Text(FormatTime(valueChange.Durations())),
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
          )),
        );
      },
    );
  }

  void initState() {
    Timer(
      const Duration(seconds: 2),
      () => _getMusic(),
    );
    _musicPlayer.InitState(MusicSongs, index);
  }

  void _getMusic() {
    _musicPlayer.play();
    iconChange = !iconChange;
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
        },
      ),
      IconButton(
        iconSize: 48,
        icon: const Icon(Icons.skip_previous),
        onPressed: () {
          _musicPlayer.seekToPrevious();
        },
      ),
      IconButton(
        iconSize: 64,
        icon:
            Icon((iconChange == false) ? Icons.play_arrow : Icons.pause_sharp),
        onPressed: () {
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
        },
      ),
      IconButton(
        iconSize: 48,
        icon: const Icon(Icons.skip_next),
        onPressed: () {
          _musicPlayer.seekToNext();
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
