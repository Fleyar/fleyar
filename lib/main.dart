import 'package:fleyar/pages/vista2.dart';
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
        backgroundColor: Colors.amberAccent,
        title: Text(widget.title),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
              onPressed: () => {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Vista2()))
                  },
              child: Icon(Icons.add)),
        ],
      ),
    );
  }
}

Widget cuerpo() {
  return Container(
    decoration: BoxDecoration(
      image: DecorationImage(
          image: AssetImage('assets/images/1.png'), fit: BoxFit.cover),
    ),
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          nombre(),
          campoUsuario(),
          campoContrasena(),
          SizedBox(height: 10),
          botonEntrar()
        ],
      ),
    ),
  );
}

Widget nombre() {
  return Text(
    "Sign in",
    style: TextStyle(
        color: Colors.white, fontSize: 35.0, fontWeight: FontWeight.bold),
  );
}

Widget campoUsuario() {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 17, vertical: 5),
    child: TextField(
      decoration: InputDecoration(
        hintText: "User",
        fillColor: Colors.white60,
        filled: true,
      ),
    ),
  );
}

Widget campoContrasena() {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 17, vertical: 5),
    child: TextField(
      obscureText: true,
      decoration: InputDecoration(
        hintText: "Password",
        fillColor: Colors.white60,
        filled: true,
      ),
    ),
  );
}

Widget botonEntrar() {
  return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.greenAccent,
          foregroundColor: Colors.black,
          padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10)),
      onPressed: () {},
      child: Text("Log in"));
}
