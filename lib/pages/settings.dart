import 'package:flutter/material.dart';
import 'package:forixplayer/Providers/ChangeTheme.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  late final String AppVersion;
  final List<String> entries = <String>[
    'Cambiar Tema',
    'Ponte en Contacto',
    'Terminos del servicio',
    'Acerca de',
  ];
  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      AppVersion = info.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeChangeProvider = Provider.of<ChangeTheme>(context);

    return MaterialApp(
      theme: themeChangeProvider.isdarktheme ? ThemeData.dark() : ThemeData.light(),
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
                    onTap: () {
                      setState(() {
                        switch (entries[index]) {
                          case "Cambiar Tema":
                            _showAlertTheme(context, themeChangeProvider);
                            break;
                          case "Ponte en Contacto":
                            break;
                          case "Terminos del servicio":
                            break;
                          case "Acerca de":
                            _showAlertAcerca(context);
                            break;
                          default:
                        }
                      });
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAlertAcerca(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Version de la aplicacion"),
        content: Text(AppVersion),
        actions: <Widget>[
          TextButton(
            child: const Text('Entendido'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _showAlertTheme(BuildContext context, ChangeTheme themeChangeProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Cambiar tema"),
        content: Column(
          children: [
            Row(
              children: [
                const Text("Modo Noche"),
                Switch(
                  value: themeChangeProvider.isdarktheme,
                  onChanged: (value) {
                    themeChangeProvider.isdarktheme = value;
                  },
                ),
              ],
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Entendido'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
