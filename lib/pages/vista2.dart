import 'package:flutter/material.dart';

class Vista2 extends StatelessWidget {
  const Vista2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.amberAccent,
          title: Text("Titulo Nota"),
        ),
        body: cuerpo());
  }
}

Widget cuerpo() {
  return Container(
    decoration: BoxDecoration(color: Colors.amber.shade200),
    child: Column(
      //mainAxisAlignment: MainAxisAlignment.center,
      children: [campoNota()],
    ),
  );
}

Widget campoNota() {
  return Container(
    color: Colors.amber.shade200,
    padding: EdgeInsets.symmetric(horizontal: 17, vertical: 50),
    child: TextField(
      keyboardType: TextInputType.multiline,
      maxLines: null,
      decoration: InputDecoration(
        hintText: "Escribe una nueva nota",
        fillColor: Colors.amber.shade100,
        filled: true,
      ),
    ),
  );
}
