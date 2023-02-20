import 'package:flutter/material.dart';
import 'package:forixplayer/class/SeachMusic.dart';
import 'package:forixplayer/pages/WidgetMusicLocal/Reproductor/MusicAlbum.dart';
import 'package:forixplayer/pages/WidgetMusicLocal/Reproductor/Reproductor.dart';
import 'package:on_audio_query/on_audio_query.dart';

class DraggableScrollableLocalMusic extends StatelessWidget {
  final MusicLocal _musicLocal = MusicLocal();

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      minChildSize: 0.0,
      maxChildSize: 0.9,
      initialChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          child: MusicLocalListViewVertical(),
        );
      },
    );
  }

  MusicLocalListViewVertical() {
    return Expanded(
      child: FutureBuilder<List<SongModel>>(
        future: _musicLocal.AllSongs(),
        builder: (context, item) {
          if (item.data == null) {
            return Center(
              child: Container(
                  width: 100,
                  height: 100,
                  child: const CircularProgressIndicator()),
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
                    title: Text(item.data![index].title ?? "No Artist"),
                    subtitle: Text(item.data![index].artist ?? ""),
                    leading: QueryArtworkWidget(
                      keepOldArtwork: true,
                      artworkQuality: FilterQuality.high,
                      id: item.data![index].id,
                      type: ArtworkType.AUDIO,
                      nullArtworkWidget: const Icon(Icons.image_not_supported,
                          size: 48, color: Colors.grey),
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => Music(
                            MusicSongs: item.data!,
                            index: index,
                          ),
                        ),
                      );
                    },
                  );
                }, childCount: item.data!.length),
              ),
            ],
          );
        },
      ),
    );
  }

  MusicLocalListViewHorizontal() {
    return Expanded(
      child: FutureBuilder<List<AlbumModel>>(
        future: _musicLocal.AllSongsAlbums(),
        builder: (context, item) {
          if (item.data == null) {
            return Center(
              child: Container(
                  width: 100,
                  height: 100,
                  child: const CircularProgressIndicator()),
            );
          }
          if (item.data!.isEmpty) {
            return const Text("Nothing found!",
                style: TextStyle(color: Colors.black));
          }
          return CustomScrollView(
            scrollDirection: Axis.horizontal,
            slivers: [
              SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  return Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Card(
                      child: InkWell(
                        child: QueryArtworkWidget(
                          keepOldArtwork: true,
                          artworkBorder: BorderRadius.circular(0),
                          artworkQuality: FilterQuality.high,
                          id: item.data![index].id,
                          type: ArtworkType.AUDIO,
                          nullArtworkWidget: const Icon(
                              Icons.image_not_supported,
                              size: 48,
                              color: Colors.grey),
                        ),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => MusicAlbum(
                                titleAlbum: _musicLocal.titleAlbum(),
                                titleArtist: _musicLocal.titleArtist(),
                                MusicArtistAll: item.data!,
                                index: index,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                }, childCount: item.data?.length),
              ),
            ],
          );
        },
      ),
    );
  }
}
