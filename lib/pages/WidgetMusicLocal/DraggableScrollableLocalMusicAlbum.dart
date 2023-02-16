import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:forixplayer/Providers/ChangeTheme.dart';
import 'package:forixplayer/pages/WidgetMusicLocal/Reproductor/MusicAlbum.dart';
import 'package:on_audio_query/on_audio_query.dart';

class DraggableScrollableLocalMusicAlbum extends StatelessWidget {
  bool iconChange = false, iconChangeshuffle = false;
  int iconChangeRepat = 0, currentIndex = 0;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  List<SongModel> songs = [];
  String currentSongTitle = '';
  ChangeTheme changeTheme = ChangeTheme();
  final OnAudioQuery _audioQuery = OnAudioQuery();
  late TabController _tabController;

  Future<List<SongModel>> AllSongs() {
    return _audioQuery.querySongs(
      sortType: SongSortType.TITLE,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      minChildSize: 0.0,
      maxChildSize: 0.9,
      initialChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          child: GridViewAlbum(),
        );
      },
    );
  }

  GridViewAlbum() {
    return FutureBuilder<List<SongModel>>(
      future: AllSongs(),
      builder: (context, item) {
        if (item.data == null) {
          return Container(
              width: 100,
              height: 100,
              child: const CircularProgressIndicator());
        }
        if (item.data!.isEmpty) {
          return const Text("Nothing found!");
        }
        return GridView.builder(
          itemCount: item.data!.length ?? 0,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2),
          itemBuilder: (context, index) {
            return Card(
              child: InkWell(
                child: QueryArtworkWidget(
                  artworkFit: BoxFit.fill,
                  artworkBorder: BorderRadius.circular(0),
                  artworkQuality: FilterQuality.high,
                  keepOldArtwork: true,
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
}
