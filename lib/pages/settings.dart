import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final List<String> entries = <String>[
    'Cambiar Tema',
    'Buscar Actualizaciones',
    'Ponte en Contacto',
    'Terminos del servicio',
    'Acerca de',
  ];
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
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
                      "Configuracion",
                      style: TextStyle(
                          fontSize: 30,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(0),
                itemCount: entries.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(entries[index], style: TextStyle(fontSize: 15)),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.blue,
                      size: 15,
                    ),
                    onLongPress: () {},
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
