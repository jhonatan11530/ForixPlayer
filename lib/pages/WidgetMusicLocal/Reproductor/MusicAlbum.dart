import 'package:flutter/material.dart';
import 'package:forixplayer/Providers/ChangeTheme.dart';
import 'package:forixplayer/class/SeachMusic.dart';
import 'package:forixplayer/pages/WidgetMusicLocal/Reproductor/Reproductor.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class MusicAlbum extends StatefulWidget {
  final List<AlbumModel> MusicArtistAll;
  final int index;
  final String titleAlbum;
  final String titleArtist;
  const MusicAlbum(
      {super.key,
      required this.MusicArtistAll,
      required this.index,
      required this.titleAlbum,
      required this.titleArtist});

  @override
  State<MusicAlbum> createState() => _MusicAlbumState();
}

class _MusicAlbumState extends State<MusicAlbum> {
  final MusicLocal _musicLocal = MusicLocal();
  List<AlbumModel> songs = [];

  @override
  void initState() {
    super.initState();
    songs.clear();
    songs = widget.MusicArtistAll;
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
          title: Text('${widget.titleAlbum} ${songs[widget.index].album}'),
        ),
        body: Column(
          children: [
            ImageAlbum(context),
            ListMusic(context),
          ],
        ),
      ),
    );
  }

  Widget ImageAlbum(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Row(
        children: [
          SizedBox(
            height: 120,
            width: 120,
            child: QueryArtworkWidget(
              artworkFit: BoxFit.fill,
              artworkBorder: BorderRadius.circular(0),
              artworkQuality: FilterQuality.high,
              keepOldArtwork: true,
              id: songs[widget.index].id,
              type: ArtworkType.ALBUM,
              nullArtworkWidget: const Icon(Icons.image_not_supported,
                  size: 62, color: Colors.grey),
            ),
          ),
          SizedBox(
            child: Column(
              children: [
                Text(
                  songs[widget.index].album,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${widget.titleArtist} ${songs[widget.index].artist}',
                  style: const TextStyle(
                      fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget ListMusic(BuildContext context) {
    return Expanded(
      child: FutureBuilder<List<SongModel>>(
        future: _musicLocal.AllSongsAlbumsFiltre(songs[widget.index].album),
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
                  Navigator.of(context);
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
