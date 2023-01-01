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
    return Column(
      children: [
        Container(
          child: Row(children: [
            SizedBox(height: 50, width: 10),
            Icon(
              Icons.settings,
              color: Colors.blue,
              size: 35,
            ),
            SizedBox(width: 10),
            Text("Configuracion",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Divider(height: 20, thickness: 1),
          ]),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(10),
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
    );
  }
}