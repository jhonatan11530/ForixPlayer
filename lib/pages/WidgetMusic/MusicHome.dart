import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:forixplayer/pages/WidgetMusicLocal/DraggableScrollableLocalMusic.dart';

class MusicHome extends StatelessWidget {
  DraggableScrollableLocalMusic music = DraggableScrollableLocalMusic();

  @override
  Widget build(BuildContext context) {
    ScrollController mycontroller1 = ScrollController();
    return DraggableScrollableSheet(
      minChildSize: 0.0,
      maxChildSize: 0.9,
      initialChildSize: 0.9,
      builder: (context, scrollController) {
        return SingleChildScrollView(
          controller: mycontroller1,
          child: Column(
            children: <Widget>[
              const Text("De tu biblioteca", style: TextStyle(fontSize: 30)),
              SizedBox(
                height: 150,
                child: music.MusicLocalListViewHorizontalHome(),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 1.7,
                child: music.MusicLocalListViewVerticalHome(),
              ),
              const Text("Musica Recomendada", style: TextStyle(fontSize: 30)),
            ],
          ),
        );
      },
    );
  }
}
