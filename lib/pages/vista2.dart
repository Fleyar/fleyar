import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class Vista2 extends StatefulWidget {
  const Vista2({Key? key});

  @override
  _Vista2State createState() => _Vista2State();
}

class _Vista2State extends State<Vista2> {
  late TextEditingController _textEditingController;
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _initPrefs();
    _textEditingController = TextEditingController();
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _textEditingController.text = _prefs.getString('texto_guardado') ?? '';
    });
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  Future<void> _guardarTexto() async {
    await _prefs.setString('texto_guardado', _textEditingController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amberAccent,
        title: Text("Titulo Nota"),
      ),
      body: cuerpo(),
    );
  }

  Widget cuerpo() {
    return Container(
      //decoration: BoxDecoration(color: Colors.amber.shade200),
      child: campoNota(),
    );
  }

  Widget campoNota() {
    // DateTime now = DateTime.now();
    //String formattedDate = DateFormat.yMMMEd().format(now);
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 15),
      child: Column(
        children: [
          // Text(formattedDate),
          fecha(),
          Expanded(
            child: TextField(
              controller: _textEditingController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              onChanged: (value) {
                _guardarTexto();
              },
              decoration: InputDecoration(
                hintText: "Escribe una nueva nota",
                // hintStyle: TextStyle(color: Colors.grey),
                fillColor: Colors.white,
                filled: true,
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                focusedBorder: UnderlineInputBorder(
                    //borderSide: BorderSide(color: Colors.white),
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget fecha() {
  DateTime now = DateTime.now();
  String formattedDate = DateFormat.yMMMEd().format(now);
  print(formattedDate);
  return Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      Text(
        formattedDate,
        style:
            TextStyle(color: Colors.blueGrey[300], fontWeight: FontWeight.bold),
      )
    ],
  );
}
