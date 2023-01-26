import 'package:flutter/material.dart';
import 'package:forixplayer/pages/Music/MusicAlbum.dart';
import 'package:forixplayer/pages/Music/MusicAll.dart';
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
              Text(
                "Álbum",
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold),
              ),
              Container(
                width: double.infinity,
                height: 150,
                child: FutureBuilder<List<AlbumModel>>(
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
                    return ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.all(10),
                      itemCount: item.data!.length,
                      separatorBuilder: (context, index) => SizedBox(
                        width: 12,
                      ),
                      itemBuilder: (context, index) {
                        return buildCardAlbum(context, index, item);
                      },
                    );
                  },
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: FutureBuilder<List<SongModel>>(
                  future: AllSongs(),
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
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  Music(MusicSongs: item.data!, index: index),
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
      ),
    );
  }

  Future<List<AlbumModel>> SongsAlbum() {
    return _audioQuery.queryAlbums(
      sortType: AlbumSortType.ALBUM,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
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
      BuildContext context, int index, AsyncSnapshot<List<AlbumModel>> item) {
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
                      id: item.data![index].id,
                      type: ArtworkType.ALBUM,
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
