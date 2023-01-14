import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

class Music extends StatefulWidget {
  const Music({super.key});

  @override
  State<Music> createState() => _MusicState();
}

class _MusicState extends State<Music> {
  double _value = 0;
  bool iconChange = false;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(scaffoldBackgroundColor: Colors.amber),
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
              padding: const EdgeInsets.all(30),
              child: Image.network(
                  "https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg"),
            ),
            Container(
              width: 300,
              height: 30,
              child: Expanded(
                child: _buildComplexMarquee(),
              ),
            ),
            Container(
              child: Slider(
                value: _value,
                min: 0,
                max: 100,
                onChanged: (value) {
                  setState(() {
                    _value = value;
                  });
                },
              ),
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
      IconButton(
          iconSize: 50,
          onPressed: () {},
          icon: Icon(Icons.keyboard_double_arrow_left)),
      IconButton(
        iconSize: 100,
        onPressed: () {
          setState(() {
            iconChange = !iconChange;
          });
        },
        icon:
            Icon((iconChange == false) ? Icons.play_arrow : Icons.pause_sharp),
      ),
      IconButton(
          iconSize: 50,
          onPressed: () {},
          icon: Icon(Icons.keyboard_double_arrow_right)),
    ];
  }
}
