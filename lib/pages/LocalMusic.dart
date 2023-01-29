import 'package:flutter/material.dart';
import 'package:forixplayer/pages/Music/MusicAlbum.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:marquee_widget/marquee_widget.dart';
import 'package:on_audio_query/on_audio_query.dart';

class LocalMusic extends StatefulWidget {
  const LocalMusic({super.key});

  @override
  State<LocalMusic> createState() => _LocalMusicState();
}

class _LocalMusicState extends State<LocalMusic> {
  bool iconChange = false, iconChangeshuffle = false, ShowView = true;
  int iconChangeRepat = 0, currentIndex = 0;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  List<SongModel> songs = [];
  String currentSongTitle = '';
  final advancedPlayer = AudioPlayer();
  final OnAudioQuery _audioQuery = OnAudioQuery();

  @override
  void initState() {
    super.initState();
    songs.clear();
  }

  _musicInit(int index, List<SongModel> MusicSongs) async {
    await advancedPlayer.setAudioSource(createPlaylist(MusicSongs),
        initialIndex: index);

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
    if (ShowView == false) {
      return MusicAll();
    }
    return Original();
  }

  Widget Original() {
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 120,
            child: Padding(
              padding: new EdgeInsets.symmetric(horizontal: 0, vertical: 30),
              child: Row(
                children: [
                  Padding(padding: EdgeInsets.all(15)),
                  Text(
                    "Tu Musica",
                    style: TextStyle(
                        fontSize: 40,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: 150,
            child: FutureBuilder<List<SongModel>>(
              future: AllSongs(),
              builder: (context, item) {
                if (item.data == null)
                  return Center(
                    child: Container(
                        width: 100,
                        height: 100,
                        child: CircularProgressIndicator()),
                  );
                if (item.data!.isEmpty) return const Text("Nothing found!");
                return ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.all(10),
                  itemCount: item.data!.length,
                  separatorBuilder: (context, index) => SizedBox(
                    width: 12,
                  ),
                  itemBuilder: (context, index) {
                    return buildCardAlbum(context, index, item);
                  },
                );
              },
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: FutureBuilder<List<SongModel>>(
              future: AllSongs(),
              builder: (context, item) {
                if (item.data == null)
                  return Center(
                    child: Container(
                        width: 100,
                        height: 100,
                        child: CircularProgressIndicator()),
                  );
                if (item.data!.isEmpty) return const Text("Nothing found!");
                return ListView.builder(
                  itemCount: item.data!.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(item.data![index].title ?? "No Artist"),
                      subtitle: Text(item.data![index].displayName ?? ""),
                      leading: QueryArtworkWidget(
                        keepOldArtwork: true,
                        artworkQuality: FilterQuality.high,
                        id: item.data![index].id,
                        type: ArtworkType.AUDIO,
                        nullArtworkWidget: Icon(Icons.image_not_supported,
                            size: 48, color: Colors.grey),
                      ),
                      onTap: () {
                        setState(() {
                          ShowView = !ShowView;
                          songs = item.data!;
                          _musicInit(index, item.data!);
                        });
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.arrow_back),
      ),
    );
  }

  Widget MusicAll() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(100, 114, 114, 114),
        leading: IconButton(
            onPressed: () {
              setState(() {
                ShowView = !ShowView;
              });
            },
            icon: Icon(Icons.keyboard_arrow_down_sharp)),
        elevation: 0,
        title: Text('${songs[currentIndex].title}'),
      ),
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(20),
            child: QueryArtworkWidget(
              artworkBorder: BorderRadius.circular(0),
              artworkQuality: FilterQuality.high,
              keepOldArtwork: true,
              id: songs[currentIndex].id,
              type: ArtworkType.AUDIO,
              nullArtworkWidget: Icon(Icons.image_not_supported,
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
              color: const Color.fromARGB(100, 114, 114, 114),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: AudioControl(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<List<SongModel>> AllSongs() {
    return _audioQuery.querySongs(
      sortType: SongSortType.TITLE,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
    );
  }

  Widget buildCardAlbum(
      BuildContext context, int index, AsyncSnapshot<List<SongModel>> item) {
    return Container(
      child: Column(
        children: [
          Expanded(
            child: AspectRatio(
              aspectRatio: 4 / 4,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Material(
                  child: InkWell(
                    child: QueryArtworkWidget(
                      keepOldArtwork: true,
                      artworkBorder: BorderRadius.circular(0),
                      artworkQuality: FilterQuality.high,
                      id: item.data![index].id,
                      type: ArtworkType.AUDIO,
                      nullArtworkWidget: Icon(Icons.image_not_supported,
                          size: 62, color: Colors.grey),
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => MusicAlbum(
                            MusicArtistAll: item.data!,
                            index: index,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
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
      child: Container(
        child: Center(
          child: Text(title,
              style:
                  const TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  List<Widget> AudioControl(BuildContext context) {
    return <Widget>[
      IconButton(
        padding: const EdgeInsets.all(8.0),
        iconSize: 32,
        icon: (iconChangeshuffle == false)
            ? Icon(
                Icons.shuffle,
                color: Colors.grey,
              )
            : Icon(Icons.shuffle),
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
        icon: Icon(Icons.skip_previous),
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
        icon: Icon(Icons.skip_next),
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
