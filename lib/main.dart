import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fleyar/pages/vista2.dart';

void main() => runApp(MiApp());

class MiApp extends StatelessWidget {
  const MiApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Fleyar",
      home: Inicio(title: "Fleyarin"),
    );
  }
}

class Inicio extends StatefulWidget {
  final String title;

  const Inicio({Key? key, required this.title}) : super(key: key);

  @override
  State<Inicio> createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  List<String> _notasGuardadas = [];

  @override
  void initState() {
    super.initState();
    _cargarNotas();
  }

  Future<void> _cargarNotas() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notasGuardadas = prefs.getStringList('notas_guardadas') ?? [];
    });
  }

  Future<void> _guardarNota(String nota) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> notas = prefs.getStringList('notas_guardadas') ?? [];
    notas.add(nota);
    await prefs.setStringList('notas_guardadas', notas);
    setState(() {
      _notasGuardadas = notas;
    });
  }

  Future<void> _editarNota(int index, String nota) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> notas = prefs.getStringList('notas_guardadas') ?? [];
    notas[index] = nota;
    await prefs.setStringList('notas_guardadas', notas);
    setState(() {
      _notasGuardadas = notas;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amberAccent,
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount: _notasGuardadas.length,
        itemBuilder: (context, index) {
          return _tarjetaNota(_notasGuardadas[index], index);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final nota = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Vista2()),
          );
          if (nota != null) {
            await _guardarNota(nota);
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _tarjetaNota(String nota, int index) {
    return GestureDetector(
      onTap: () async {
        final notaEditada = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Vista2(notaInicial: nota)),
        );
        if (notaEditada != null) {
          await _editarNota(index, notaEditada);
        }
      },
      child: Card(
        child: ListTile(
          title: Text(nota),
        ),
      ),
    );
  }
}
