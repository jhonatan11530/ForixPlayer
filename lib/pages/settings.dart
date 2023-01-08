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
        Flexible(
          child: Container(
            padding: new EdgeInsets.symmetric(horizontal: 0, vertical: 40),
            child: Row(
              children: [
                Icon(
                  Icons.settings,
                  color: Colors.blue,
                  size: 35,
                ),
                Text("Configuracion",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
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
