import 'package:on_audio_query/on_audio_query.dart';

class MusicLocal {
  final OnAudioQuery _audioQuery = OnAudioQuery();

  Future<List<SongModel>> AllSongs() async {
    return await _audioQuery.querySongs();
  }

  Future<List<AlbumModel>> AllSongsAlbums() async {
    return await _audioQuery.queryAlbums();
  }

  Future<List<ArtistModel>> AllSongsArtists() async {
    return await _audioQuery.queryArtists();
  }

  titleAlbum() {
    return "Álbum";
  }

  titleArtist() {
    return "Artista";
  }
}
