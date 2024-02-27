import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fleyar/pages/vista2.dart';
import 'package:fleyar/pages/vistaConfig.dart';

void main() => runApp(MiApp());

class MiApp extends StatelessWidget {
  const MiApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
  List<String> notasGuardadas = [];

  @override
  void initState() {
    super.initState();
    cargarNotas();
  }
  
  void vistaConfig() {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => ConfiguracionVista()),
  );
}


  Future<void> cargarNotas() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      notasGuardadas = prefs.getStringList('notas_guardadas') ?? [];
    });
  }

  Future<void> guardarNota(String nota) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> notas = prefs.getStringList('notas_guardadas') ?? [];
    notas.add(nota);
    await prefs.setStringList('notas_guardadas', notas);
    setState(() {
      notasGuardadas = notas;
    });
  }

  Future<void> editarNota(int index, String nota) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> notas = prefs.getStringList('notas_guardadas') ?? [];
    notas[index] = nota;
    await prefs.setStringList('notas_guardadas', notas);
    setState(() {
      notasGuardadas = notas;
    });
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
  backgroundColor: Colors.amberAccent,
  title: Text(widget.title),
  actions: [
    IconButton(
      icon: Icon(Icons.settings),
      onPressed: () {
        vistaConfig();
      },
    ),
    IconButton(
      icon: Icon(Icons.help),
      onPressed: () {
        // Aquí puedes realizar alguna otra acción cuando se presiona el botón de ayuda
      },
    ),
  ],
),
    body: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          color: Colors.amberAccent,
          padding: EdgeInsets.all(16),
          child: SingleChildScrollView( 
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Vista2();
                  },
                  child: Text('Opción 1'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Vista2();
                  },
                  child: Text('Opción 2'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Vista2();
                  },
                  child: Text('Opción 3'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Vista2();
                  },
                  child: Text('Opción 4'),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: notasGuardadas.length,
            itemBuilder: (context, index) {
              return tarjetaNota(notasGuardadas[index], index);
            },
          ),
        ),
      ],
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: () async {
        final nota = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Vista2()),
        );
        if (nota != null) {
          await guardarNota(nota);
        }
      },
      child: Icon(Icons.add),
    ),
  );
}


  Widget tarjetaNota(String nota, int index) {
    return SizedBox(
      height: 100,
      child: GestureDetector(
        onTap: () async {
          final notaEditada = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Vista2(notaInicial: nota)),
          );
          if (notaEditada != null) {
            await editarNota(index, notaEditada);
          }
        },
        child: Card(
          child: ListTile(
            title: Text(nota),
          ),
        ),
      ),
    );
  }
}
