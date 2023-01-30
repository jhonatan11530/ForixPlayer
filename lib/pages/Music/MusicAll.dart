import 'package:flutter/material.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:marquee_widget/marquee_widget.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Music extends StatefulWidget {
  final List<SongModel> MusicSongs;
  final int index;
  const Music({super.key, required this.MusicSongs, required this.index});
  @override
  State<Music> createState() => _MusicState();
}

class _MusicState extends State<Music> {
  bool iconChange = false, iconChangeshuffle = false;
  int iconChangeRepat = 0, currentIndex = 0;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  List<SongModel> songs = [];
  String currentSongTitle = '';
  final advancedPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    songs.clear();
    songs = widget.MusicSongs;
    _musicInit();
  }

  _musicInit() async {
    await advancedPlayer.setAudioSource(createPlaylist(widget.MusicSongs),
        initialIndex: widget.index);

    advancedPlayer.positionStream.listen((Duration p) {
      setState(() => position = p);
    });

    advancedPlayer.durationStream.listen((d) {
      setState(() => duration = d!);
    });

    advancedPlayer.currentIndexStream.listen((index) {
      if (index != null) {
        _updateCurrentPlayingSongDetails(index);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    advancedPlayer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor:Colors.blue,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.keyboard_arrow_down_sharp)),
          elevation: 0,
          title: Text('Estas Escuchando ${songs[currentIndex].title}'),
        ),
        body: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(20),
              child: QueryArtworkWidget(
                artworkBorder: BorderRadius.circular(0),
                artworkQuality: FilterQuality.high,
                keepOldArtwork: true,
                id: songs[currentIndex].id,
                type: ArtworkType.AUDIO,
                nullArtworkWidget: const Icon(Icons.image_not_supported,
                    size: 120, color: Colors.grey),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 1.5,
              height: 30,
              child: _buildComplexMarquee(currentSongTitle),
            ),
            Slider(
              value: position.inSeconds.toDouble(),
              max: duration.inSeconds.toDouble() + 0.0,
              onChanged: (value) {
                setState(() {
                  advancedPlayer.seek(Duration(seconds: value.toInt()));
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(FormatTime(position)),
                    Text(FormatTime(duration)),
                  ]),
            ),
            Expanded(
              child: Container(
                color: Colors.blue,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: AudioControl(context),
                ),
              ),
            ),
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
      animationDuration: const Duration(seconds: 5),
      backDuration: const Duration(milliseconds: 5000),
      pauseDuration: const Duration(milliseconds: 2500),
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
        padding: const EdgeInsets.all(8.0),
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
                advancedPlayer.shuffle();
                advancedPlayer.setShuffleModeEnabled(false);
                iconChangeshuffle = !iconChangeshuffle;
                break;
              case true:
                advancedPlayer.shuffle();
                advancedPlayer.setShuffleModeEnabled(true);
                iconChangeshuffle = !iconChangeshuffle;
                break;
              default:
            }
          });
        },
      ),
      IconButton(
        padding: const EdgeInsets.all(8.0),
        iconSize: 48,
        icon: const Icon(Icons.skip_previous),
        onPressed: () {
          setState(() {
            advancedPlayer.seekToPrevious();
          });
        },
      ),
      IconButton(
        padding: const EdgeInsets.all(8.0),
        iconSize: 64,
        icon:
            Icon((iconChange == false) ? Icons.play_arrow : Icons.pause_sharp),
        onPressed: () {
          setState(() {
            switch (iconChange) {
              case false:
                advancedPlayer.play();
                iconChange = !iconChange;
                break;
              case true:
                advancedPlayer.stop();
                iconChange = !iconChange;
                break;
              default:
            }
          });
        },
      ),
      IconButton(
        padding: const EdgeInsets.all(8.0),
        iconSize: 48,
        icon: const Icon(Icons.skip_next),
        onPressed: () {
          setState(() {
            advancedPlayer.seekToNext();
          });
        },
      ),
      IconButton(
        padding: const EdgeInsets.all(8.0),
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
                advancedPlayer.setLoopMode(LoopMode.all);
                break;
              case 1:
                iconChangeRepat = 2;
                advancedPlayer.setLoopMode(LoopMode.one);
                break;
              case 2:
                iconChangeRepat = 0;
                advancedPlayer.setLoopMode(LoopMode.off);
                break;
            }
          });
        },
      ),
    ];
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
            artUri: Uri.parse(song.uri!),
          ),
        ),
      );
    }
    return ConcatenatingAudioSource(children: sources);
  }

  void _updateCurrentPlayingSongDetails(int index) {
    setState(() {
      if (songs.isNotEmpty) {
        currentSongTitle = songs[index].title;
        currentIndex = index;
      }
    });
  }
}
