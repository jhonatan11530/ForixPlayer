import 'package:flutter/material.dart';
import 'package:forixplayer/pages/Music/music.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<String> _Image = [
    "https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg",
    "https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg",
    "https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg",
    "https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg"
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: new EdgeInsets.symmetric(horizontal: 0, vertical: 40),
            child: Row(
              children: [
                Padding(padding: EdgeInsets.all(15)),
                Text(
                  "Tu Musica",
                  style: TextStyle(
                      fontSize: 35,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
          Flexible(
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
          Expanded(
            child: Text("data"),
          ),
          Expanded(
            child: Row(
              children: [
                Text("data"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCard(BuildContext context, int index) => Container(
        child: Column(
          children: [
            Expanded(
              child: AspectRatio(
                aspectRatio: 2 / 2.7,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Material(
                      child: Ink.image(
                        image: NetworkImage(_Image[index]),
                        fit: BoxFit.cover,
                        width: 136,
                        height: 150,
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Music(),
                            ));
                          },
                        ),
                      ),
                    )),
              ),
            ),
          ],
        ),
      );
}
