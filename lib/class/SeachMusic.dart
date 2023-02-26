import 'package:on_audio_query/on_audio_query.dart';

class MusicLocal {
  final OnAudioQuery _audioQuery = OnAudioQuery();

  Future<List<SongModel>> AllSongs() async {
    return await _audioQuery.querySongs();
  }

  Future<List<AlbumModel>> AllSongsAlbums() async {
    return await _audioQuery.queryAlbums();
  }

  Future<List<SongModel>> AllSongsAlbumsFiltre(String Album) {
    return _audioQuery.queryAudiosFrom(
      AudiosFromType.ALBUM,
      Album,
      sortType: SongSortType.TITLE,
      orderType: OrderType.ASC_OR_SMALLER,
      ignoreCase: true,
    );
  }

  Future<List<ArtistModel>> AllSongsArtists() async {
    return await _audioQuery.queryArtists();
  }

  Future<List<SongModel>> AllSongsArtistsFiltre(String Artists) {
    return _audioQuery.queryAudiosFrom(
      AudiosFromType.ARTIST,
      Artists,
      sortType: SongSortType.TITLE,
      orderType: OrderType.ASC_OR_SMALLER,
      ignoreCase: true,
    );
  }

  titleAlbum() {
    return "Álbum";
  }

  titleArtist() {
    return "Artista";
  }
}
