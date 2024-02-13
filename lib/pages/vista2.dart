import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Vista2 extends StatefulWidget {
  final String? notaInicial;

  const Vista2({Key? key, this.notaInicial}) : super(key: key);

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
    _textEditingController = TextEditingController(text: widget.notaInicial);
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  Future<void> _guardarTexto() async {
    await _prefs.setString('texto_guardado_${DateTime.now().millisecondsSinceEpoch}', _textEditingController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amberAccent,
        title: Text("Nueva Nota"),
      ),
      body: cuerpo(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _guardarTexto();
          Navigator.pop(context, _textEditingController.text);
        },
        child: Icon(Icons.save),
      ),
    );
  }

  Widget cuerpo() {
    return Container(
      decoration: BoxDecoration(color: Colors.amber.shade200),
      child: campoNota(),
    );
  }

  Widget campoNota() {
    return Container(
      color: Colors.amber.shade200,
      padding: EdgeInsets.symmetric(horizontal: 17),
      child: Column(
        children: [
          Expanded(
            child: TextField(
              controller: _textEditingController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: InputDecoration(
                hintText: "Escribe una nueva nota",
                hintStyle: TextStyle(color: Colors.grey),
                fillColor: Colors.amber.shade100,
                filled: true,
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
