import 'package:flutter/material.dart';

class Biblioteca extends StatefulWidget {
  const Biblioteca({super.key});

  @override
  State<Biblioteca> createState() => _BibliotecaState();
}

class _BibliotecaState extends State<Biblioteca> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          child: Text("data #2"),
        ),
      ),
    );
  }
}
