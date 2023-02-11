import 'package:flutter/material.dart';
import 'package:forixplayer/Providers/ChangeTheme.dart';
import 'package:forixplayer/Providers/MusicPlayer.dart';
import 'package:forixplayer/pages/LocalMusic.dart';
import 'package:just_audio/just_audio.dart';
import 'package:marquee_widget/marquee_widget.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class Music extends StatefulWidget {
  final List<SongModel> MusicSongs;
  final int index;
  const Music({super.key, required this.MusicSongs, required this.index});
  @override
  State<Music> createState() => _MusicState();
}

class _MusicState extends State<Music> {
  bool iconChange = false, iconChangeshuffle = false;
  int iconChangeRepat = 0;
  final MusicPlayer _musicPlayer = MusicPlayer();
  @override
  void initState() {
    super.initState();

    _musicPlayer.players = widget.MusicSongs;
    _musicPlayer.IndexMusic = widget.index;

    _musicPlayer.play();
    iconChange = !iconChange;
  }

  @override
  Widget build(BuildContext context) {
    AudioPlayer player = context.watch<MusicPlayer>().player;
    final themeChangeProvider = Provider.of<ChangeTheme>(context);
    return MaterialApp(
      theme: themeChangeProvider.isdarktheme
          ? ThemeData.dark()
          : ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                _musicPlayer.dispose();
                Navigator.pop(context);
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => LocalMusic()),
                );
              },
              icon: const Icon(Icons.keyboard_arrow_down_sharp)),
          elevation: 0,
          title: Text('${_musicPlayer.currentSongTitle}'),
        ),
        body: Stack(
          children: [
            Column(
              children: [
                ValueListenableBuilder(
                  valueListenable: _musicPlayer,
                  builder: (context, value, child) {
                    return Container(
                      height: MediaQuery.of(context).size.height * 0.5,
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.all(20),
                      child: QueryArtworkWidget(
                        artworkFit: BoxFit.contain,
                        artworkBorder: BorderRadius.circular(0),
                        artworkQuality: FilterQuality.high,
                        keepOldArtwork: true,
                        id: _musicPlayer.currentSongID,
                        type: ArtworkType.AUDIO,
                        nullArtworkWidget: const Icon(Icons.image_not_supported,
                            size: 120, color: Colors.grey),
                      ),
                    );
                  },
                ),
                ValueListenableBuilder(
                  valueListenable: _musicPlayer,
                  builder: (context, value, child) {
                    return SizedBox(
                      width: MediaQuery.of(context).size.width / 1.5,
                      height: 30,
                      child:
                          _buildComplexMarquee(_musicPlayer.currentSongTitle),
                    );
                  },
                ),
                ValueListenableBuilder(
                  valueListenable: _musicPlayer,
                  builder: (context, value, child) {
                    return Slider(
                      value: _musicPlayer.PositionSlider(),
                      max: _musicPlayer.DurationSlider() + 0.0,
                      onChanged: (value) {
                        setState(() {
                          player.seek(Duration(seconds: value.toInt()));
                        });
                      },
                    );
                  },
                ),
                ValueListenableBuilder(
                  valueListenable: _musicPlayer,
                  builder: (context, value, child) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(FormatTime(_musicPlayer.Positions())),
                            Text(FormatTime(_musicPlayer.Durations()!)),
                          ]),
                    );
                  },
                ),
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: AudioControl(context),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                DraggableScroll(
                  AllSongs: widget.MusicSongs,
                  Player: _musicPlayer,
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  String FormatTime(Duration value) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final Hours = twoDigits(value.inHours);
    final Minutes = twoDigits(value.inMinutes.remainder(60));
    final Seconds = twoDigits(value.inSeconds.remainder(60));
    return [if (value.inHours > 0) Hours, Minutes, Seconds].join(":");
  }

  Widget _buildComplexMarquee(String title) {
    return Marquee(
      autoRepeat: true,
      animationDuration: const Duration(seconds: 1),
      backDuration: const Duration(seconds: 2),
      pauseDuration: const Duration(milliseconds: 1500),
      directionMarguee: DirectionMarguee.TwoDirection,
      child: Text(
        title,
        style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
      ),
    );
  }

  List<Widget> AudioControl(BuildContext context) {
    return <Widget>[
      IconButton(
        iconSize: 32,
        icon: (iconChangeshuffle == false)
            ? const Icon(
                Icons.shuffle,
                color: Colors.grey,
              )
            : const Icon(Icons.shuffle),
        onPressed: () {
          setState(() {
            switch (iconChangeshuffle) {
              case false:
                _musicPlayer.ShuffleModeEnabledFalse();
                iconChangeshuffle = !iconChangeshuffle;
                break;
              case true:
                _musicPlayer.ShuffleModeEnabledTrue();
                iconChangeshuffle = !iconChangeshuffle;
                break;
              default:
            }
          });
        },
      ),
      IconButton(
        iconSize: 48,
        icon: const Icon(Icons.skip_previous),
        onPressed: () {
          setState(() {
            _musicPlayer.seekToPrevious();
          });
        },
      ),
      IconButton(
        iconSize: 64,
        icon:
            Icon((iconChange == false) ? Icons.play_arrow : Icons.pause_sharp),
        onPressed: () {
          setState(() {
            switch (iconChange) {
              case false:
                _musicPlayer.play();
                iconChange = !iconChange;
                break;
              case true:
                _musicPlayer.stop();
                iconChange = !iconChange;
                break;
              default:
            }
          });
        },
      ),
      IconButton(
        iconSize: 48,
        icon: const Icon(Icons.skip_next),
        onPressed: () {
          setState(() {
            _musicPlayer.seekToNext();
          });
        },
      ),
      IconButton(
        iconSize: 32,
        icon: Icon((iconChangeRepat == 0)
            ? Icons.repeat
            : (iconChangeRepat == 1)
                ? Icons.repeat_on_rounded
                : (iconChangeRepat == 2)
                    ? Icons.repeat_one
                    : null),
        onPressed: () {
          setState(() {
            switch (iconChangeRepat) {
              case 0:
                iconChangeRepat = 1;
                _musicPlayer.setLoopModeAll();
                break;
              case 1:
                iconChangeRepat = 2;
                _musicPlayer.setLoopModeOne();
                break;
              case 2:
                iconChangeRepat = 0;
                _musicPlayer.setLoopModeOff();
                break;
            }
          });
        },
      ),
    ];
  }
}

class DraggableScroll extends StatelessWidget {
  final List<SongModel> AllSongs;
  final MusicPlayer Player;
  const DraggableScroll(
      {super.key, required this.AllSongs, required this.Player});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.1,
      minChildSize: 0.1,
      maxChildSize: 1,
      builder: (context, scrollController) {
        return Container(
          child: ListViewMusic(
            scrollController: scrollController,
            SongsList: AllSongs,
            Players: Player,
          ),
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
        );
      },
    );
  }
}

class ListViewMusic extends StatelessWidget {
  final ScrollController scrollController;
  final List<SongModel> SongsList;
  final MusicPlayer Players;
  const ListViewMusic(
      {super.key,
      required this.scrollController,
      required this.SongsList,
      required this.Players});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: scrollController,
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            return ListTile(
              title: Text(SongsList[index].title ?? "No Artist"),
              subtitle: Text(SongsList[index].artist ?? ""),
              leading: QueryArtworkWidget(
                keepOldArtwork: true,
                artworkQuality: FilterQuality.high,
                id: SongsList[index].id,
                type: ArtworkType.AUDIO,
                nullArtworkWidget: const Icon(Icons.image_not_supported,
                    size: 48, color: Colors.grey),
              ),
              onTap: () {
                Players.stop();
                Navigator.pop(context);

                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => Music(
                            MusicSongs: SongsList,
                            index: index,
                          )),
                );
              },
            );
          }, childCount: SongsList.length),
        ),
      ],
    );
  }
}
