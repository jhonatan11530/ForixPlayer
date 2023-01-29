import 'package:flutter/material.dart';
import 'package:forixplayer/pages/LocalMusic.dart';
import 'package:forixplayer/pages/Music/MusicAlbum.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  List<SongModel> songs = [];
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 120,
                child: Padding(
                  padding:
                      new EdgeInsets.symmetric(horizontal: 0, vertical: 30),
                  child: Row(
                    children: [
                      Padding(padding: EdgeInsets.all(15)),
                      Text(
                        "Tu Musica",
                        style: TextStyle(
                            fontSize: 40,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(4),
                  child: Card(
                    child: new InkWell(
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
                          Container(
                            child: Align(
                              alignment: Alignment(0, -0.50),
                              child: Text(
                                "Escuchar Musica en ",
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25),
                              ),
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
                  padding: EdgeInsets.all(4),
                  child: Card(
                    child: new InkWell(
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
                            child: Icon(
                              Icons.music_note,
                              size: 120,
                            ),
                          ),
                          Container(
                            child: Align(
                              alignment: Alignment(0, -0.50),
                              child: Text(
                                "Escuchar Musica Local ",
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25),
                              ),
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
      ),
    );
  }

  Future<List<SongModel>> AllSongs() {
    return _audioQuery.querySongs(
      sortType: SongSortType.TITLE,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
    );
  }

  Widget buildCardAlbum(
      BuildContext context, int index, AsyncSnapshot<List<SongModel>> item) {
    return Container(
      child: Column(
        children: [
          Expanded(
            child: AspectRatio(
              aspectRatio: 4 / 4,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Material(
                  child: InkWell(
                    child: QueryArtworkWidget(
                      artworkBorder: BorderRadius.circular(0),
                      artworkQuality: FilterQuality.high,
                      id: item.data![index].id,
                      type: ArtworkType.AUDIO,
                      nullArtworkWidget: Icon(Icons.image_not_supported,
                          size: 62, color: Colors.grey),
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => MusicAlbum(
                            MusicArtistAll: item.data!,
                            index: index,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
