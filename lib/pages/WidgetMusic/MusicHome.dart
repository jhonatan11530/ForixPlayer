import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:forixplayer/pages/WidgetMusicLocal/DraggableScrollableLocalMusic.dart';

class MusicHome extends StatelessWidget {
  DraggableScrollableLocalMusic music = new DraggableScrollableLocalMusic();
  @override
  Widget build(BuildContext context) {
    ScrollController _mycontroller1 = new ScrollController();
    return DraggableScrollableSheet(
      minChildSize: 0.0,
      maxChildSize: 0.9,
      initialChildSize: 0.9,
      builder: (context, scrollController) {
        return SingleChildScrollView(
          controller: _mycontroller1,
          child: Column(
            children: <Widget>[
              Text("De tu biblioteca", style: TextStyle(fontSize: 30)),
              SizedBox(
                height: 150,
                child: music.MusicLocalListViewHorizontal(),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 2,
                child: music.MusicLocalListViewVertical(),
              ),
              Text("asdasdasd")
            ],
          ),
        );
      },
    );
  }
}
