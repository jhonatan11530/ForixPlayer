import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:on_audio_query/on_audio_query.dart';

class MusicPlayer extends ChangeNotifier {
  int currentSongID = 0;
  List<SongModel> songs = [];
  Duration position = Duration.zero;
  Duration duration = Duration.zero;
  String currentSongTitle = '';
  final AudioPlayer _advancedPlayer = AudioPlayer();

  set players(List<SongModel> value) {
    songs.clear();
    songs = value;
    _advancedPlayer.setAudioSource(createPlaylist(value),
        initialIndex: 0, initialPosition: Duration.zero, preload: true);
  }

  get player => _advancedPlayer;

  MusicPlayer() {
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
  }

  seek(int value) {
    _advancedPlayer.seek(Duration(seconds: value.toInt()));
    notifyListeners();
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
            album: song.album,
            artUri: Uri.parse('${song.uri}'),
          ),
        ),
      );
    }
    return ConcatenatingAudioSource(children: sources);
  }
}
