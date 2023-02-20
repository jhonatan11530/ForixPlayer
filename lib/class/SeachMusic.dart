import 'package:on_audio_query/on_audio_query.dart';

class MusicLocal {
  final OnAudioQuery _audioQuery = OnAudioQuery();

  Future<List<SongModel>> AllSongs() {
    return _audioQuery.querySongs(
      sortType: SongSortType.TITLE,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
    );
  }

  Future<List<AlbumModel>> AllSongsAlbums() {
    return _audioQuery.queryAlbums(
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
      sortType: AlbumSortType.ALBUM,
    );
  }

  Future<List<ArtistModel>> AllSongsArtists() {
    return _audioQuery.queryArtists(
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
      sortType: ArtistSortType.ARTIST,
    );
  }

  titleAlbum() {
    return "Álbum";
  }

  titleArtist() {
    return "Artista";
  }
}
