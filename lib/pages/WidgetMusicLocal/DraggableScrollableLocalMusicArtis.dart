import 'package:flutter/material.dart';
import 'package:forixplayer/class/SeachMusic.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'Reproductor/MusicArtist.dart';

class DraggableScrollableLocalMusicArtis extends StatelessWidget {
  final MusicLocal _musicLocal = MusicLocal();

  DraggableScrollableLocalMusicArtis({super.key});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      minChildSize: 0.0,
      maxChildSize: 0.9,
      initialChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          child: GridViewArtists(),
        );
      },
    );
  }

  GridViewArtists() {
    return FutureBuilder<List<ArtistModel>>(
      future: _musicLocal.AllSongsArtists(),
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
            crossAxisCount: 3,
          ),
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
                      builder: (context) => MusicArtist(
                        titleArtist: _musicLocal.titleArtist(),
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
