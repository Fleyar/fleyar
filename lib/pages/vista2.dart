import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class Vista2 extends StatefulWidget {
  final String? notaInicial;

  const Vista2({Key? key, this.notaInicial}) : super(key: key);

  @override
  _Vista2State createState() => _Vista2State();
}

class _Vista2State extends State<Vista2> with WidgetsBindingObserver {
  late TextEditingController textEditingController;
  late SharedPreferences prefs;
  bool isKeyboardVisible = false;

  @override
  void initState() {
    super.initState();
    initPrefs();
    textEditingController = TextEditingController(text: widget.notaInicial);
    WidgetsBinding.instance?.addObserver(this);
  }

  Future<void> initPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  Future<void> guardarTexto() async {
    await prefs.setString('texto_guardado_${DateTime.now().millisecondsSinceEpoch}', textEditingController.text);
  }

  @override
  void didChangeMetrics() {
    final mediaQuery = MediaQuery.of(context);
    final isKeyboardNowVisible = mediaQuery.viewInsets.bottom > 0;
    if (isKeyboardNowVisible != isKeyboardVisible) {
      setState(() {
        isKeyboardVisible = isKeyboardNowVisible;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amberAccent,
        title: Text("Nueva Nota"),
      ),
      body: cuerpo(),
      floatingActionButton: !isKeyboardVisible ? FloatingActionButton(
        onPressed: () {
          guardarTexto();
          Navigator.pop(context, textEditingController.text);
        },
        child: Icon(Icons.save),
      ) : null,
    );
  }

  Widget cuerpo() {
    return Container(
      child: Stack(
        children: [
          campoNota(),
          if (isKeyboardVisible) Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Acción para el primer botón
                    },
                    child: Icon(Icons.image),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      // Acción para el segundo botón
                    },
                    child: Icon(Icons.draw),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget campoNota() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 15),
      child: Column(
        children: [
          fecha(),
          Expanded(
            child: TextField(
              controller: textEditingController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: InputDecoration(
                hintText: "Escribe una nueva nota",
                fillColor: Colors.white,
                filled: true,
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                focusedBorder: UnderlineInputBorder(),
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
  return Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      Text(
        formattedDate,
        style: TextStyle(color: Colors.blueGrey[300], fontWeight: FontWeight.bold),
      )
    ],
  );
}
