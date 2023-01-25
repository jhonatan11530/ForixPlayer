import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class MusicArtist extends StatefulWidget {
  final List<ArtistModel> MusicArtistAll;
  final int index;
  const MusicArtist(
      {super.key, required this.MusicArtistAll, required this.index});
  @override
  State<MusicArtist> createState() => _MusicArtistState();
}

class _MusicArtistState extends State<MusicArtist> {
  List<ArtistModel> songs = [];
  int currentIndex = 0;
  @override
  void initState() {
    super.initState();
    songs.clear();
    songs = widget.MusicArtistAll;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        /*appBar: AppBar(
          backgroundColor: Color.fromARGB(100, 114, 114, 114),
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back)),
          elevation: 0,
          title: Text('Musica del Artista'),
        ),*/
        body: Column(
          children: [
            Container(
              color: Colors.blue,
              height: MediaQuery.of(context).size.height * 0.4,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(20),
              child: QueryArtworkWidget(
                id: songs[currentIndex].id,
                type: ArtworkType.ARTIST,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(songs[currentIndex].artist),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
