import 'package:flutter/material.dart';

class Music extends StatelessWidget {
  const Music({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(scaffoldBackgroundColor: Colors.amber),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: Icon(Icons.keyboard_arrow_down_sharp),
          elevation: 0,
          title: Text('Press the button with a label below!'),
        ),
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(35),
              child: Image.network(
                  "https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg"),
            ),
            Container(
              width: 300,
              child: Text("[ Megurine Luka ] Dreamin Chu Chu — sub español",
                  overflow: TextOverflow.ellipsis,
                  
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
            ),
            
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.home),
                  Text("data"),
                  Icon(Icons.home),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.pop(context);
          },
          label: const Text('Atras'),
          icon: const Icon(Icons.arrow_back),
          backgroundColor: Colors.blue,
        ),
      ),
    );
  }
}
