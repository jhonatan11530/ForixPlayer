import 'package:flutter/material.dart';
import 'package:forixplayer/Providers/ChangeTheme.dart';
import 'package:forixplayer/pages/Music/MusicAll.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

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
    final themeChangeProvider = Provider.of<ChangeTheme>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themeChangeProvider.isdarktheme
          ? ThemeData.dark()
          : ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(
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
            Stack(
              alignment: Alignment.center,
              children: [
                ImageAlbum(context),
                Stacks(context),
              ],
            ),
            ListMusic(context),
          ],
        ),
      ),
    );
  }

  Widget ImageAlbum(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      width: MediaQuery.of(context).size.width,
      child: QueryArtworkWidget(
        artworkFit: BoxFit.fill,
        artworkBorder: BorderRadius.circular(0),
        artworkQuality: FilterQuality.high,
        keepOldArtwork: true,
        id: songs[widget.index].id,
        type: ArtworkType.AUDIO,
        nullArtworkWidget:
            const Icon(Icons.image_not_supported, size: 62, color: Colors.grey),
      ),
    );
  }

  Widget Stacks(BuildContext context) {
    return Positioned(
      bottom: 80,
      child: Column(
        children: [
          Text(
            textAlign: TextAlign.center,
            songs[widget.index].title,
            style: const TextStyle(
                fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          Text(
            'Artista ${songs[widget.index].artist}',
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget ListMusic(BuildContext context) {
    return Expanded(
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
              return ListTile(
                title: Text(item.data![index].title ?? "No Artist"),
                subtitle: Text(item.data![index].artist ?? ""),
                leading: QueryArtworkWidget(
                  artworkQuality: FilterQuality.high,
                  keepOldArtwork: true,
                  id: item.data![index].id,
                  type: ArtworkType.AUDIO,
                  nullArtworkWidget: const Icon(Icons.image_not_supported,
                      size: 48, color: Colors.grey),
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
    );
  }
}
