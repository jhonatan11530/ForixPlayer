import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
class MusicAlbum extends StatefulWidget {
  final List<AlbumModel> MusicArtistAll;
  final int index;
  const MusicAlbum(
      {super.key, required this.MusicArtistAll, required this.index});

  @override
  State<MusicAlbum> createState() => _MusicAlbumState();
}

class _MusicAlbumState extends State<MusicAlbum> {
OnAudioQuery audioQuery = OnAudioQuery();
  List<AlbumModel> songs = [];
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
        appBar: AppBar(
          backgroundColor: Color.fromARGB(100, 114, 114, 114),
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back)),
          elevation: 0,
          title: Text('Album ${songs[currentIndex].artist}'),
        ),
        body: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.2,
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.all(10),
                    child: QueryArtworkWidget(
                      id: songs[currentIndex].id,
                      type: ArtworkType.ALBUM,
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    height: 150,
                    width: 150,
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          songs[currentIndex].album,
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                        Text('${songs[currentIndex].artist}',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: songs[currentIndex].numOfSongs,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(songs[currentIndex].album),
                    leading: const CircleAvatar(child: Icon(Icons.music_note)),
                    onTap: () {
                      setState(() {
                        print(songs[currentIndex]);
                      });
                    },
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
