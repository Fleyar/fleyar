import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfiguracionVista extends StatefulWidget {
  @override
  _ConfiguracionVistaState createState() => _ConfiguracionVistaState();
}

class _ConfiguracionVistaState extends State<ConfiguracionVista> {
  bool _modoOscuro = false;

  @override
  void initState() {
    super.initState();
    modoOscuro();
  }

  Future<void> modoOscuro() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _modoOscuro = prefs.getBool('modoOscuro') ?? false;
    });
  }

  Future<void> guardarModoOscuro(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('modoOscuro', value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configuración'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Modo Oscuro',
              style: TextStyle(fontSize: 20.0),
            ),
            Switch(
              value: _modoOscuro,
              onChanged: (value) async {
                setState(() {
                  _modoOscuro = value;
                });
                await guardarModoOscuro(value);
                if (_modoOscuro) {

                  ThemeMode.dark;

                } else {

                  ThemeMode.light;

                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
