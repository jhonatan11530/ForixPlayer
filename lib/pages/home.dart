import 'dart:io';
import 'package:flutter/material.dart';
import 'package:forixplayer/pages/Music/music.dart';
import 'package:path_provider/path_provider.dart';

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
  List<File> _musicFiles = [];
  @override
  void initState() {
    super.initState();

    getMusicFiles().then((value) {
      setState(() {
        _musicFiles = value;
      });
    });
  }

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
                child: ListView.builder(
                  itemCount: _musicFiles?.length ?? 0,
                  itemBuilder: (context, index) {
                    final file = _musicFiles[index];
                    return ListTile(
                      title: Text(file.path.split('/').last),
                      leading: CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.transparent,
                        backgroundImage: NetworkImage(
                            "https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg"),
                      ),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => Music(),
                        ));
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

  Future<List<File>> getMusicFiles() async {
    // obtener la ruta de la carpeta de archivos del dispositivo
    final directory = await getExternalStorageDirectory();
    final musicFiles = <File>[];
    final musicExtensions = ['.mp3', '.m4a'];
    // buscar archivos en todas las carpetas
    final files = await _searchAllFiles(directory!, musicExtensions);
    musicFiles.addAll(files);
    return musicFiles;
  }

  Future<List<File>> _searchAllFiles(Directory dir, List<String> extensions) async {
    final files = <File>[];
    final lister = dir.list(recursive: true);
    await for (final file in lister) {
      if (file is File && extensions.contains(file.path.split('.').last)) {
        files.add(file);
      }
    }
    return files;
  }
}
