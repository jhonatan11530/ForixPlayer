import 'package:flutter/material.dart';
import 'package:forixplayer/Providers/MusicPlayer.dart';
import 'package:just_audio/just_audio.dart';
import 'package:marquee_widget/marquee_widget.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class Music extends StatefulWidget {
  final List<SongModel> MusicSongs;
  const Music({super.key, required this.MusicSongs});
  @override
  State<Music> createState() => _MusicState();
}

class _MusicState extends State<Music> {
  bool iconChange = false, iconChangeshuffle = false;
  int iconChangeRepat = 0;
  MusicPlayer _musicPlayer = MusicPlayer();
  @override
  void initState() {
    super.initState();

    _musicPlayer.players = widget.MusicSongs;
  }

  @override
  Widget build(BuildContext context) {
    AudioPlayer player = context.watch<MusicPlayer>().player;
    //final postProvider = Provider.of<MusicPlayer>(context, listen: false);
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.keyboard_arrow_down_sharp)),
          elevation: 0,
          title: Text('${_musicPlayer.currentSongTitle}'),
        ),
        body: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(20),
              child: QueryArtworkWidget(
                artworkBorder: BorderRadius.circular(0),
                artworkQuality: FilterQuality.high,
                keepOldArtwork: true,
                id: _musicPlayer.currentSongID,
                type: ArtworkType.AUDIO,
                nullArtworkWidget: const Icon(Icons.image_not_supported,
                    size: 120, color: Colors.grey),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 1.5,
              height: 30,
              child: _buildComplexMarquee(_musicPlayer.currentSongTitle),
            ),
            ValueListenableBuilder<int>(
              valueListenable: _musicPlayer,
              builder: (context, value, child) {
                return Slider(
                  value: _musicPlayer.PositionSlider(),
                  max: _musicPlayer.DurationSlider() + 0.0,
                  onChanged: (value) {
                    setState(() {
                      player.seek(Duration(seconds: value.toInt()));
                    });
                  },
                );
              },
            ),
            ValueListenableBuilder<int>(
              valueListenable: _musicPlayer,
              builder: (context, value, child) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(FormatTime(_musicPlayer.Positions())),
                        Text(FormatTime(_musicPlayer.Durations()!)),
                      ]),
                );
              },
            ),
            Expanded(
              child: Container(
                color: Colors.blue,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: AudioControl(context),
                ),
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
        style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
      ),
    );
  }

  List<Widget> AudioControl(BuildContext context) {
    return <Widget>[
      IconButton(
        padding: const EdgeInsets.all(8.0),
        iconSize: 32,
        icon: (iconChangeshuffle == false)
            ? const Icon(
                Icons.shuffle,
                color: Colors.grey,
              )
            : const Icon(Icons.shuffle),
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
        padding: const EdgeInsets.all(8.0),
        iconSize: 48,
        icon: const Icon(Icons.skip_previous),
        onPressed: () {
          setState(() {
            _musicPlayer.seekToPrevious();
          });
        },
      ),
      IconButton(
        padding: const EdgeInsets.all(8.0),
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
        padding: const EdgeInsets.all(8.0),
        iconSize: 48,
        icon: const Icon(Icons.skip_next),
        onPressed: () {
          setState(() {
            _musicPlayer.seekToNext();
          });
        },
      ),
      IconButton(
        padding: const EdgeInsets.all(8.0),
        iconSize: 32,
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
}
