import 'package:flutter/material.dart';
import 'package:forixplayer/pages/Music/music.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<String> _Image = [
    "https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg",
    "https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg",
    "https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg",
    "https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg"
  ];
  final OnAudioQuery _audioQuery = OnAudioQuery();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 120,
                child: Padding(
                  padding:
                      new EdgeInsets.symmetric(horizontal: 0, vertical: 40),
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
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.all(10),
                  itemCount: _Image.length,
                  separatorBuilder: (context, index) => SizedBox(
                    width: 12,
                  ),
                  itemBuilder: (context, index) {
                    return buildCard(context, index);
                  },
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: FutureBuilder<List<SongModel>>(
                  future: _audioQuery.querySongs(
                    sortType: null,
                    orderType: OrderType.ASC_OR_SMALLER,
                    uriType: UriType.EXTERNAL,
                    ignoreCase: true,
                  ),
                  builder: (context, item) {
                    if (item.data == null)
                      return const CircularProgressIndicator();
                    if (item.data!.isEmpty) return const Text("Nothing found!");
                    return ListView.builder(
                      itemCount: item.data!.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(item.data![index].title ?? "No Artist"),
                          subtitle: Text(item.data![index].displayName ?? ""),
                          leading: QueryArtworkWidget(
                            id: item.data![index].id,
                            type: ArtworkType.AUDIO,
                          ),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Music(),
                            ));
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCard(BuildContext context, int index) => Container(
        child: Column(
          children: [
            Expanded(
              child: AspectRatio(
                aspectRatio: 4 / 4,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Material(
                    child: Ink.image(
                      image: NetworkImage(_Image[index]),
                      fit: BoxFit.cover,
                      width: 150,
                      height: 150,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => Music(),
                          ));
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}
