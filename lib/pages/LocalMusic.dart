import 'package:flutter/material.dart';
import 'package:forixplayer/Providers/ChangeTheme.dart';
import 'package:forixplayer/pages/Music/MusicAlbum.dart';
import 'package:forixplayer/pages/Music/MusicAll.dart';
import 'package:on_audio_query/on_audio_query.dart';

class LocalMusic extends StatefulWidget {
  const LocalMusic({super.key});

  @override
  State<LocalMusic> createState() => _LocalMusicState();
}

class _LocalMusicState extends State<LocalMusic> with TickerProviderStateMixin {
  bool iconChange = false, iconChangeshuffle = false;
  int iconChangeRepat = 0, currentIndex = 0;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  List<SongModel> songs = [];
  String currentSongTitle = '';
  ChangeTheme changeTheme = new ChangeTheme();
  final OnAudioQuery _audioQuery = OnAudioQuery();
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    songs.clear();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Musica En el Dispositivo'),
          bottom: TabBar(
            controller: _tabController,
            tabs: const <Widget>[
              Tab(
                text: "Musica",
                icon: Icon(Icons.music_note),
              ),
              Tab(
                text: "Álbum",
                icon: Icon(Icons.album),
              )
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: <Widget>[
            TodaMusica(),
            GridViewAlbum(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back)),
      ),
    );
  }

  TodaMusica() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 150,
          child: FutureBuilder<List<SongModel>>(
            future: AllSongs(),
            builder: (context, item) {
              if (item.data == null) {
                return Center(
                  child: Container(
                      width: 100,
                      height: 100,
                      child: CircularProgressIndicator()),
                );
              }
              if (item.data!.isEmpty) {
                return const Text("Nothing found!",
                    style: TextStyle(color: Colors.black));
              }
              return ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.all(10),
                itemCount: item.data!.length,
                separatorBuilder: (context, index) => const SizedBox(
                  width: 12,
                ),
                itemBuilder: (context, index) {
                  return buildCard(context, index, item);
                },
              );
            },
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Expanded(
          child: FutureBuilder<List<SongModel>>(
            future: AllSongs(),
            builder: (context, item) {
              if (item.data == null) {
                return Center(
                  child: Container(
                      width: 100,
                      height: 100,
                      child: CircularProgressIndicator()),
                );
              }
              if (item.data!.isEmpty) {
                return const Text("Nothing found!",
                    style: TextStyle(color: Colors.black));
              }
              return CustomScrollView(
                slivers: [
                  SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      return ListTile(
                        title: Text(item.data![index].title ?? "No Artist",
                            style: const TextStyle(color: Colors.black)),
                        subtitle: Text(item.data![index].artist ?? "",
                            style: const TextStyle(color: Colors.black)),
                        leading: QueryArtworkWidget(
                          keepOldArtwork: true,
                          artworkQuality: FilterQuality.high,
                          id: item.data![index].id,
                          type: ArtworkType.AUDIO,
                          nullArtworkWidget: const Icon(
                              Icons.image_not_supported,
                              size: 48,
                              color: Colors.grey),
                        ),
                        onTap: () {
                          setState(() {
                            songs = item.data!;
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => Music(
                                      MusicSongs: item.data!, index: index)),
                            );
                          });
                        },
                      );
                    }, childCount: item.data!.length),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  GridViewAlbum() {
    return FutureBuilder<List<SongModel>>(
      future: AllSongs(),
      builder: (context, item) {
        return GridView.builder(
          itemCount: item.data!.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2),
          itemBuilder: (context, index) {
            return Card(
              child: InkWell(
                child: QueryArtworkWidget(
                  keepOldArtwork: true,
                  artworkBorder: BorderRadius.circular(0),
                  artworkQuality: FilterQuality.high,
                  id: item.data![index].id,
                  type: ArtworkType.AUDIO,
                  nullArtworkWidget: const Icon(Icons.image_not_supported,
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
            );
          },
        );
      },
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

  Widget buildCard(
      BuildContext context, int index, AsyncSnapshot<List<SongModel>> item) {
    return Column(
      children: [
        Expanded(
          child: AspectRatio(
            aspectRatio: 4 / 4,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Material(
                child: InkWell(
                  child: QueryArtworkWidget(
                    keepOldArtwork: true,
                    artworkBorder: BorderRadius.circular(0),
                    artworkQuality: FilterQuality.high,
                    id: item.data![index].id,
                    type: ArtworkType.AUDIO,
                    nullArtworkWidget: const Icon(Icons.image_not_supported,
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
    );
  }
}
