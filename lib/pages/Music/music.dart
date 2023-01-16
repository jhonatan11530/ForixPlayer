import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:just_audio/just_audio.dart';

class Music extends StatefulWidget {
  const Music({super.key});

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
    await advancedPlayer.setAsset("assets/audio.mp3");

   

    advancedPlayer.positionStream.listen((Duration p) {
      setState(() => position = p);
    });


    advancedPlayer.durationStream.listen((d) {
      setState(() => duration = d!);
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
                AudioPlayer.clearAssetCache();
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
              child: Image.network(
                  "https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg"),
            ),
            Container(
              width: MediaQuery.of(context).size.width / 1.5,
              height: 30,
              child: _buildComplexMarquee(),
            ),
            Container(
              child: Slider(
                value: position.inSeconds.toDouble(),
                max: duration.inSeconds.toDouble(),
                onChanged: (value) {
                  setState(() {
                    advancedPlayer.seek(Duration(seconds: value.toInt() - 1));
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
                children: AudioControl(),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.pop(context);
          },
          label: const Text('Atras'),
          icon: const Icon(Icons.arrow_back),
          backgroundColor: Colors.blue,
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

  Widget _buildComplexMarquee() {
    return Marquee(
      text: '[ Megurine Luka ] Dreamin Chu Chu',
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

  List<Widget> AudioControl() {
    return <Widget>[
      IconButton(iconSize: 30, onPressed: () {}, icon: Icon(Icons.shuffle)),
      IconButton(
        iconSize: 50,
        icon: Icon(Icons.skip_previous),
        onPressed: () {
          setState(() {
            print(advancedPlayer.sequence);
          });
        },
      ),
      IconButton(
        iconSize: 100,
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
        icon:
            Icon((iconChange == false) ? Icons.play_arrow : Icons.pause_sharp),
      ),
      IconButton(
        iconSize: 50,
        icon: Icon(Icons.skip_next),
        onPressed: () {
          setState(() {
            print(advancedPlayer.hasNext);
          });
        },
      ),
      IconButton(
          iconSize: 30,
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
          icon: Icon(
            (iconChangeRepat == 0)
                ? Icons.repeat
                : (iconChangeRepat == 1)
                    ? Icons.repeat_on_rounded
                    : (iconChangeRepat == 2)
                        ? Icons.repeat_one
                        : null,
          )),
    ];
  }
}
