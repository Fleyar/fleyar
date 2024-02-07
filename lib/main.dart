import 'package:flutter/material.dart';

void main() => runApp(MiApp());

class MiApp extends StatelessWidget {
  const MiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Fleyar",
      home: Inicio("Fleyarin"),
    );
  }
}

class Inicio extends StatefulWidget {
  String title = "";
  Inicio(String title, {super.key}) {
    this.title = title;
  }

  @override
  State<Inicio> createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.deepOrange,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(widget.title),
          Text("Fleyarin"),
        ],
      ),
    );
  }
}
