import 'package:flutter/cupertino.dart';
import 'package:forixplayer/Preferences/DarkThemePreferences.dart';

class ChangeReplay with ChangeNotifier {
  ReproductorPreferences reproductor = ReproductorPreferences();

  bool _isMusicReplay = false;

  bool get isReplay => _isMusicReplay;

  set isReplay(bool value) {
    _isMusicReplay = value;
    reproductor.setReplay(value);
  }
}
