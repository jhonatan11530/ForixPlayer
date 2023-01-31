import 'package:flutter/cupertino.dart';
import 'package:forixplayer/Providers/DarkThemePreferences.dart';

class ChangeTheme with ChangeNotifier {
   DarkThemePreferences darkThemePreferences = DarkThemePreferences();
  bool _isdarktheme = false;

  bool get isdarktheme => _isdarktheme;

  set isdarktheme(bool value) {
    _isdarktheme = value;
    darkThemePreferences.setDarkTheme(value);
    notifyListeners();
  }

}
