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
      debugShowCheckedModeBanner: false,
      theme: themeChangeProvider.isdarktheme
          ? ThemeData.dark()
          : ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(
          title: const Center(
            child: Text("Configuracion"),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(0),
                itemCount: entries.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(entries[index], style: TextStyle(fontSize: 15)),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
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
                            _showAlertAcerca(context, themeChangeProvider);
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

  void _showAlertAcerca(BuildContext context, ChangeTheme themeChangeProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Version de la aplicacion"),
        content: Text(AppVersion),
        actions: <Widget>[
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  (themeChangeProvider.isdarktheme) ? Colors.grey : Colors.blue,
              foregroundColor: (themeChangeProvider.isdarktheme)
                  ? Colors.white
                  : Colors.white,
            ),
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
          mainAxisSize: MainAxisSize.min,
          children: [
            SwitchListTile(
              title: const Text(
                "Modo Noche",
              ),
              value: themeChangeProvider.isdarktheme,
              onChanged: (value) => themeChangeProvider.isdarktheme = value,
            ),
          ],
        ),
        actions: <Widget>[
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  (themeChangeProvider.isdarktheme) ? Colors.grey : Colors.blue,
              foregroundColor: (themeChangeProvider.isdarktheme)
                  ? Colors.white
                  : Colors.white,
            ),
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
