import 'package:flutter/material.dart';
import 'package:forixplayer/Providers/ChangeTheme.dart';
import 'package:forixplayer/pages/WidgetMusicLocal/Reproductor/Reproductor.dart';
import 'package:on_audio_query/on_audio_query.dart';

class DraggableScrollableLocalMusic extends StatelessWidget {
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
          child: TodaMusica(),
        );
      },
    );
  }

  TodaMusica() {
    return Column(
      children: [
        Expanded(
          child: FutureBuilder<List<SongModel>>(
            future: AllSongs(),
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
                          nullArtworkWidget: const Icon(
                              Icons.image_not_supported,
                              size: 48,
                              color: Colors.grey),
                        ),
                        onTap: () {
                          songs = item.data!;
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
        ),
      ],
    );
  }
}
