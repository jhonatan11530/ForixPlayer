import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:forixplayer/Navigator/navigator.dart';
import 'package:forixplayer/Providers/ChangeTheme.dart';
import 'package:forixplayer/Providers/MusicPlayer.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid) {
    await JustAudioBackground.init(
      androidNotificationChannelId: 'com.ryanhzeise.bg_demo.channel.audio',
      androidNotificationChannelName: 'Audio playback',
      androidNotificationOngoing: true,
    );
  }
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<MusicPlayer>(create: (ctx) => MusicPlayer()),
    //ChangeNotifierProvider(create: (_) => SearchProvider())
  ], child: const ForixPlayer()));
}

class ForixPlayer extends StatefulWidget {
  const ForixPlayer({super.key});

  @override
  State<ForixPlayer> createState() => _ForixPlayerState();
}

class _ForixPlayerState extends State<ForixPlayer> {
  ChangeTheme themeChangeProvider = ChangeTheme();
  final OnAudioQuery _audioQuery = OnAudioQuery();
  // primary color nabvar - second color footer - tree color theme body
  List<Color> _colorAplicacion = [Colors.blue, Colors.blue, Colors.white];

  @override
  void initState() {
    super.initState();
    requestStoragePermission();
    getCurrentAppTheme();
  }

  void getCurrentAppTheme() async {
    themeChangeProvider.isdarktheme =
        await themeChangeProvider.darkThemePreferences.getTheme();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (value) {
            return themeChangeProvider;
          }),
        ],
        child: Consumer<ChangeTheme>(
          builder: (context, Theme, child) {
            return MaterialApp(
              theme: themeChangeProvider.isdarktheme
                  ? ThemeData.dark()
                  : ThemeData.light(),
              home: Scaffold(
                bottomNavigationBar: MyNavigationBar(),
              ),
            );
          },
        ));
  }

  void requestStoragePermission() async {
    //only if the platform is not web, coz web have no permissions
    if (!kIsWeb) {
      bool permissionStatus = await _audioQuery.permissionsStatus();
      if (!permissionStatus) {
        await _audioQuery.permissionsRequest();
      }
      //ensure build method is called
      setState(() {});
    }
  }
}
