import 'package:flutter/material.dart';

class Music extends StatefulWidget {
  const Music({super.key});

  @override
  State<Music> createState() => _MusicState();
}

class _MusicState extends State<Music> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(appBar: AppBar(
        
        leading: Icon(Icons.keyboard_arrow_down),
          title: const Text('Forix Multimedia'),
          backgroundColor: Colors.amber,
        ),
        ),
    );
  }
}