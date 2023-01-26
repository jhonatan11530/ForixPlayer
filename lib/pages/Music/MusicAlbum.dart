import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class MusicAlbum extends StatefulWidget {
  final List<SongModel> MusicArtistAll;
  final int index;
  const MusicAlbum(
      {super.key, required this.MusicArtistAll, required this.index});

  @override
  State<MusicAlbum> createState() => _MusicAlbumState();
}

class _MusicAlbumState extends State<MusicAlbum> {
  OnAudioQuery audioQuery = OnAudioQuery();
  List<SongModel> songs = [];
  int currentIndex = 0;
  @override
  void initState() {
    super.initState();
    songs.clear();
    songs = widget.MusicArtistAll;
  }

  Future<List<SongModel>> SongsAlbum() {
    return audioQuery.queryAudiosFrom(
      AudiosFromType.ALBUM_ID,
      songs[currentIndex].id,
      sortType: SongSortType.SIZE,
      orderType: OrderType.ASC_OR_SMALLER,
      ignoreCase: true,
    );

    audioQuery.queryWithFilters(
        "Sam Smith", 
        WithFiltersType.AUDIOS,
        args: AudiosArgs.ARTIST,
    );
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
                      type: ArtworkType.AUDIO,
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
                          songs[currentIndex].title,
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${songs[currentIndex].artist}',
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
              child: FutureBuilder<List<SongModel>>(
                future: SongsAlbum(),
                builder: (context, item) {
                  if (item.data == null)
                    return Center(
                      child: Container(
                          width: 100,
                          height: 100,
                          child: CircularProgressIndicator()),
                    );
                  if (item.data!.isEmpty) return const Text("Nothing found!");
                  return ListView.builder(
                    itemCount: item.data!.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(item.data![index].title ?? "No Artist"),
                        subtitle: Text(item.data![index].displayName ?? ""),
                        leading: QueryArtworkWidget(
                          id: item.data![index].id,
                          type: ArtworkType.AUDIO,
                        ),
                        onTap: () {},
                      );
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
