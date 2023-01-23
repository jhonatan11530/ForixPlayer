import 'package:flutter/material.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:marquee/marquee.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Music extends StatefulWidget {
  final int id;
  final String? uri;
  final String titulo;
  const Music({super.key, required this.titulo, this.uri, required this.id});
  @override
  State<Music> createState() => _MusicState();
}

class _MusicState extends State<Music> {
  bool iconChange = false;
  int iconChangeRepat = 0;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  final advancedPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _musicInit();
  }

  _musicInit() async {
    await advancedPlayer.setAudioSource(AudioSource.uri(
      Uri.parse(widget.uri!),
      tag: MediaItem(
        id: '${widget.id}',
        title: widget.titulo,
        artUri: Uri.parse(widget.uri!),
      ),
    ));

    advancedPlayer.positionStream.listen((Duration p) {
      setState(() => position = p);
    });

    advancedPlayer.durationStream.listen((d) {
      setState(() => duration = d!);
    });

    advancedPlayer.playerStateStream.listen((playerState) {
      if (playerState.processingState == ProcessingState.completed) {
        print("asdasdasdasdasdasdasdasd");
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
      theme: ThemeData(scaffoldBackgroundColor: Colors.green),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
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
                id: widget.id,
                type: ArtworkType.AUDIO,
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width / 1.5,
              height: 30,
              child: _buildComplexMarquee(widget.titulo),
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
        icon: Icon(
          Icons.shuffle,
        ),
        onPressed: () {},
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
}
