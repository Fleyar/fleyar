import 'package:flutter/material.dart';

void main() => runApp(MiApp());

class MiApp extends StatelessWidget {
  const MiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Fleyar",
      home: Inicio(),
    );
  }
}

class Inicio extends StatefulWidget {
  const Inicio({super.key});

  @override
  State<Inicio> createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Fleyarin"),
        backgroundColor: Colors.deepOrange,
      ),
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            child: Image.network(
                "https://qph.cf2.quoracdn.net/main-qimg-6f468411fafa8e06ddb5557fe67bb79d"),
          ),
          Container(
            padding: EdgeInsets.all(15),
            child: Image.asset('assets/images/1.png'),
          )
        ],
      ),
    );
  }
}
