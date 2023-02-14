import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:on_audio_query/on_audio_query.dart';

class MusicPlayer extends ValueNotifier {
  int currentSongID = 0;
  List<SongModel> songs = [];
  Duration position = Duration.zero;
  Duration duration = Duration.zero;
  String currentSongTitle = '';
  final AudioPlayer _advancedPlayer = AudioPlayer();
  double volume = 1;

  get player => _advancedPlayer;

  InitState(List<SongModel> song, int valueIndex) {
    songs.clear();
    songs = song;

    _advancedPlayer.setAudioSource(createPlaylist(songs),
        initialIndex: valueIndex,
        initialPosition: Duration.zero,
        preload: true);
  }

  MusicPlayer() : super(null) {
    _advancedPlayer.setPitch(1.0);
    _advancedPlayer.setSkipSilenceEnabled(false);

    _advancedPlayer.playerStateStream.listen((state) async {});

    _advancedPlayer.positionStream.listen((Duration p) {
      position = p;
      notifyListeners();
    });

    _advancedPlayer.durationStream.listen((d) {
      duration = d!;
      notifyListeners();
    });

    _advancedPlayer.currentIndexStream.listen((index) {
      if (index != null) {
        currentSongID = songs[index].id;
        currentSongTitle = songs[index].title;
        notifyListeners();
      }
    });

    _advancedPlayer.sequenceStream.listen((event) {
      notifyListeners();
    });

    _advancedPlayer.loopModeStream.listen((event) {
      notifyListeners();
    });

    _advancedPlayer.shuffleModeEnabledStream.listen((event) {
      notifyListeners();
    });
  }

  Positions() {
    return position;
  }

  Durations() {
    return duration;
  }

  PositionSlider() {
    return position.inSeconds.toDouble();
  }

  DurationSlider() {
    return duration.inSeconds.toDouble();
  }

  void dispose() {
    _advancedPlayer.dispose();
    notifyListeners();
  }

  void play() {
    _advancedPlayer.play();
    notifyListeners();
  }

  void stop() {
    _advancedPlayer.stop();
    notifyListeners();
  }

  void SpeedX1() {
    _advancedPlayer.setSpeed(1);
    notifyListeners();
  }

  void SpeedX2() {
    _advancedPlayer.setSpeed(2);
    notifyListeners();
  }

  void SpeedX3() {
    _advancedPlayer.setSpeed(3);
    notifyListeners();
  }

  void VolumenUp() {
    if (volume < 1) {
      volume += 0.1;
      _advancedPlayer.setVolume(volume);
    }
  }

  void VolumenDowm() {
    if (volume != 0) {
      volume -= 0.1;
      _advancedPlayer.setVolume(volume);
    }
  }

  void ShuffleModeEnabledTrue() {
    _advancedPlayer.shuffle();
    _advancedPlayer.setShuffleModeEnabled(true);
    notifyListeners();
  }

  void ShuffleModeEnabledFalse() {
    _advancedPlayer.shuffle();
    _advancedPlayer.setShuffleModeEnabled(false);
    notifyListeners();
  }

  void seekToPrevious() {
    _advancedPlayer.seekToPrevious();
    notifyListeners();
  }

  void seekToNext() {
    _advancedPlayer.seekToNext();
    notifyListeners();
  }

  void setLoopModeAll() {
    _advancedPlayer.setLoopMode(LoopMode.all);
    notifyListeners();
  }

  void setLoopModeOne() {
    _advancedPlayer.setLoopMode(LoopMode.one);
    notifyListeners();
  }

  void setLoopModeOff() {
    _advancedPlayer.setLoopMode(LoopMode.off);
    notifyListeners();
  }

  ConcatenatingAudioSource createPlaylist(List<SongModel> songs) {
    List<AudioSource> sources = [];

    for (var song in songs) {
      sources.add(
        AudioSource.uri(
          Uri.parse(song.uri!),
          tag: MediaItem(
            id: '${song.id}',
            title: song.title,
            artist: song.artist,
            artUri: Uri.parse(song.uri!),
          ),
        ),
      );
    }
    return ConcatenatingAudioSource(
        useLazyPreparation: true,
        shuffleOrder: DefaultShuffleOrder(),
        children: sources);
  }
}
