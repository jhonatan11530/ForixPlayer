import 'package:flutter/material.dart';
import 'package:forixplayer/main.dart';

class Music extends StatelessWidget {
  const Music({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text('Press the button with a label below!'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pop(context);
        },
        label: const Text('Atras'),
        icon: const Icon(Icons.arrow_back),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
