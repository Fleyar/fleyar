import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_field/image_field.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
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
  bool isEditingTitle = false;
  String appBarTitle = "Nueva Nota";
  SampleItem? selectedItem;
  File? imageFile;

   // Lista para almacenar las imágenes seleccionadas
  List<File> imageFiles = [];

  @override
  void initState() {
    super.initState();
    initPrefs();
    textEditingController = TextEditingController(text: widget.notaInicial);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      textEditingController.addListener(() {
        setState(() {
            // Handle changes in the text field selection here
          // You can access the cursor position using textEditingController.selection
          textEditingController.selection;
        });
      });
    });
    WidgetsBinding.instance.addObserver(this);
  }

  Future<void> initPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> guardarTexto() async {
    await prefs.setString('texto_guardado_${DateTime.now().millisecondsSinceEpoch}', textEditingController.text);
  }

  Future<void> seleccionarImagen() async {
  final picker = ImagePicker();
  final pickedImage = await picker.pickImage(source: ImageSource.gallery);
  if (pickedImage != null) {
    final File imageFile = File(pickedImage.path);
    // Insertar la imagen en la posición actual del cursor
    final currentPosition = textEditingController.selection.base.offset;
    final currentText = textEditingController.text;
    final newText = currentText.substring(0, currentPosition) +
        "\n\n" + // Insertar dos saltos de línea para separar el texto y la imagen
        "![Image description](${imageFile.path})" +
        "\n\n" + // Insertar dos saltos de línea después de la imagen
        currentText.substring(currentPosition);
    setState(() {
      textEditingController.value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(
          offset: currentPosition + 4, // Ajustar el desplazamiento para la posición del cursor después de la inserción
        ),
      );
    });
  }
}




  void guardarTitulo() {
    setState(() {
      appBarTitle = textEditingController.text;
      isEditingTitle = false;
    });
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
        title: isEditingTitle
            ? TextField(
                controller: textEditingController,
                autofocus: true,
                decoration: InputDecoration(
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  setState(() {
                    appBarTitle = value;
                  });
                },
                onEditingComplete: guardarTitulo,
              )
            : Text(appBarTitle),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isEditingTitle = true;
              });
            },
            icon: Icon(Icons.edit),
          ),
        ],
      ),
      body: cuerpo(),
      floatingActionButton: !isKeyboardVisible ? FloatingActionButton(
        onPressed: () {
          guardarTitulo();
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
                Container(
                  decoration: BoxDecoration(
                              color: Colors.grey[200],
                            ),
                  child: TextButton(
                  onPressed: () {
                    showMenu(
                      context: context,
                      position: RelativeRect.fromLTRB(0, 100, 0, 0),
                      items: [
                              PopupMenuItem(
                                value: SampleItem.itemOne,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                    tomarFoto();
                                  },
                                  child: Row(
                                    children: [
                                      Icon(Icons.camera),
                                      SizedBox(width: 8),
                                      Text('Tomar foto'),
                                    ],
                                  ),
                                ),
                              ),

                              PopupMenuItem(
                                value: SampleItem.itemTwo,
                                child: InkWell(
                                  onTap: () {
                                    //Navigator.of(context).pop(); 
                                    seleccionarImagen();
                                  },
                                  child: Row(
                                    children: [
                                      Icon(Icons.image),
                                      SizedBox(width: 8),
                                      Text('Seleccionar imagen'),
                                    ],
                                  ),
                                ),
                              ),

                            ],
                          );
                        },          
                            child: Icon(Icons.image), 
                          ),
                ),
                //SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200]
                  ),
                  child: TextButton(
                    onPressed: () {
                      seleccionarImagen();
                    },
                    child: Icon(Icons.draw),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200]
                  ),
                  child: TextButton(
                    onPressed: () {
                    },
                    child: Icon(Icons.text_fields),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200]
                  ),
                  child: TextButton(
                    onPressed: () {
                    },
                    child: Icon(Icons.voice_chat),
                  ),
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
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        fecha(),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Campo de nota editable
                TextField(
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
                SizedBox(height: 10), 
                ...textoConImagen(),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

List<Widget> textoConImagen() {
  List<Widget> children = [];
  List<String> sections = textEditingController.text.split('\n');
  for (var section in sections) {
    children.add(
      MarkdownBody(data: section),
    );

    if (imageFiles.isNotEmpty) {
      for (var imageFile in imageFiles) {
        children.add(
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.file(
                  imageFile,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 8),
              ],
            ),
          ),
        );
      }
      imageFiles.clear();
    }
  }

  return children;
}


  
  void tomarFoto() {
    
  }
  

}

enum SampleItem { itemOne, itemTwo, itemThree }

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
