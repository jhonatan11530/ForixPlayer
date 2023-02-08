import 'package:flutter/material.dart';
import 'package:forixplayer/pages/Music/MusicAll.dart';
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
  final OnAudioQuery _audioQuery = OnAudioQuery();
  List<SongModel> songs = [];

  @override
  void initState() {
    super.initState();
    songs.clear();
    songs = widget.MusicArtistAll;
  }

  Future<List<SongModel>> SongsAlbum() {
    return _audioQuery.queryAudiosFrom(
      AudiosFromType.ALBUM,
      '${songs[widget.index].album}',
      sortType: SongSortType.TITLE,
      orderType: OrderType.ASC_OR_SMALLER,
      ignoreCase: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back)),
          elevation: 0,
          title: Text('Album ${songs[widget.index].artist}'),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Expanded(
                      child: Container(
                        height: 150,
                        width: 150,
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: QueryArtworkWidget(
                          artworkBorder: BorderRadius.circular(0),
                          artworkQuality: FilterQuality.high,
                          keepOldArtwork: true,
                          id: songs[widget.index].id,
                          type: ArtworkType.AUDIO,
                          nullArtworkWidget: const Icon(
                              Icons.image_not_supported,
                              size: 62,
                              color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    child: Expanded(
                      child: Container(
                        height: 150,
                        width: 150,
                        padding: const EdgeInsets.symmetric(horizontal: 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              textAlign: TextAlign.center,
                              songs[widget.index].title,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Artista ${songs[widget.index].artist}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder<List<SongModel>>(
                future: SongsAlbum(),
                builder: (context, item) {
                  if (item.data == null) {
                    return Center(
                      child: Container(
                          width: 100,
                          height: 100,
                          child: const CircularProgressIndicator()),
                    );
                  }
                  if (item.data!.isEmpty) return const Text("Nothing found!");
                  return ListView.builder(
                    itemCount: item.data!.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(item.data![index].title ?? "No Artist"),
                        subtitle: Text(item.data![index].artist ?? ""),
                        leading: QueryArtworkWidget(
                          artworkQuality: FilterQuality.high,
                          keepOldArtwork: true,
                          id: item.data![index].id,
                          type: ArtworkType.AUDIO,
                          nullArtworkWidget: const Icon(
                              Icons.image_not_supported,
                              size: 48,
                              color: Colors.grey),
                        ),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                Music(MusicSongs: item.data!),
                          ));
                        },
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
