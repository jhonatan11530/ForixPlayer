import 'package:flutter/material.dart';
import 'package:forixplayer/class/SeachMusic.dart';
import 'package:forixplayer/pages/WidgetMusicLocal/Reproductor/MusicAlbum.dart';
import 'package:on_audio_query/on_audio_query.dart';

class DraggableScrollableLocalMusicAlbum extends StatelessWidget {
  final MusicLocal _musicLocal = MusicLocal();
  
  DraggableScrollableLocalMusicAlbum({super.key});

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
    return FutureBuilder<List<AlbumModel>>(
      future: _musicLocal.AllSongsAlbums(),
      builder: (context, item) {
        if (item.data == null) {
          return const SizedBox(
              width: 100,
              height: 100,
              child: CircularProgressIndicator());
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
                  type: ArtworkType.ALBUM,
                  nullArtworkWidget: const Icon(Icons.image_not_supported,
                      size: 62, color: Colors.grey),
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => MusicAlbum(
                        titleAlbum: "Álbum",
                        titleArtist: "Artista",
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
