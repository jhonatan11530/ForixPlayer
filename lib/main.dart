import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:forixplayer/Providers/ChangeTheme.dart';
import 'package:forixplayer/Providers/MusicPlayer.dart';
import 'package:forixplayer/class/SeachMusic.dart';
import 'package:forixplayer/pages/home.dart';
import 'package:forixplayer/pages/library.dart';
import 'package:forixplayer/pages/settings.dart';
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

ValueNotifier<int> buttonClickedTimes = ValueNotifier(0);

class ForixPlayer extends StatefulWidget {
  const ForixPlayer({super.key});

  @override
  State<ForixPlayer> createState() => _ForixPlayerState();
}

class _ForixPlayerState extends State<ForixPlayer> {
  ChangeTheme themeChangeProvider = ChangeTheme();
  final OnAudioQuery _audioQuery = OnAudioQuery();
  final List<Widget> _pages = [
    const Home(),
    const Biblioteca(),
    const Settings(),
    const Settings()
  ];
  int _selectedIndex = 0;

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
              debugShowCheckedModeBanner: false,
              theme: themeChangeProvider.isdarktheme
                  ? ThemeData.dark()
                  : ThemeData.light(),
              home: Scaffold(
                body: ValueListenableBuilder(
                  valueListenable: buttonClickedTimes,
                  builder: (context, value, child) {
                    return _pages[value];
                  },
                ),
                bottomNavigationBar: BottomNavigationBar(
                  selectedIconTheme: IconThemeData(
                      color: (themeChangeProvider.isdarktheme)
                          ? Colors.white
                          : Colors.black87),
                  selectedItemColor: (themeChangeProvider.isdarktheme)
                      ? Colors.white
                      : Colors.black87,
                  unselectedItemColor: (themeChangeProvider.isdarktheme)
                      ? Colors.grey
                      : Colors.grey,
                  unselectedIconTheme: IconThemeData(
                      color: (themeChangeProvider.isdarktheme)
                          ? Colors.grey
                          : Colors.grey),
                  showSelectedLabels: true,
                  showUnselectedLabels: true,
                  currentIndex: _selectedIndex,
                  onTap: (value) {
                    setState(() {
                      _selectedIndex = value;
                      buttonClickedTimes.value = value;
                    });
                  },
                  items: const <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home),
                      label: 'Principal',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.video_collection_sharp),
                      label: 'Biblioteca',
                    ),
                    BottomNavigationBarItem(
                      icon: const Icon(Icons.settings),
                      label: 'Herramientas',
                    ),
                  ],
                ),
              ),
            );
          },
        ));
  }

  void requestStoragePermission() async {
    if (!kIsWeb) {
      bool permissionStatus = await _audioQuery.permissionsStatus();
      if (!permissionStatus) {
        await _audioQuery.permissionsRequest();
      }
      setState(() {});
    }
  }
}
