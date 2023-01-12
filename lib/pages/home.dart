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
          Container(
            width: double.infinity,
            height: 120,
            child: Padding(
              padding: new EdgeInsets.symmetric(horizontal: 0, vertical: 40),
              child: Row(
                children: [
                  Padding(padding: EdgeInsets.all(15)),
                  Text(
                    "Tu Musica",
                    style: TextStyle(
                        fontSize: 40,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold),
                  )
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
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text("Titulo Musica"),
                  subtitle: Text("Sub titulo"),
                  leading: CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.transparent,
                    backgroundImage: NetworkImage(
                        "https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg"),
                  ),
                  onTap: () {},
                );
              },
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
                    )),
              ),
            ),
          ],
        ),
      );
}
