import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:image_field/image_field.dart';

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

  @override
  void initState() {
    super.initState();
    initPrefs();
    textEditingController = TextEditingController(text: widget.notaInicial);
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
                      position: RelativeRect.fromLTRB(0, 100, 0, 0), // Ajusta la posición del menú emergente según sea necesario
                      items: [
                              PopupMenuItem(
                                value: SampleItem.itemOne,
                                child: InkWell(
                                  onTap: () {
                                    // Acción al presionar el botón de tomar foto
                                    Navigator.of(context).pop(); // Cerrar el menú emergente
                                    // Llamar a la función para tomar una foto
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
                                    Navigator.of(context).pop(); 
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
                            child: Icon(Icons.image), // Icono del botón padre
                          ),
                ),


                      /* itemBuilder: (BuildContext context) => <PopupMenuEntry<SampleItem>>[
                        const PopupMenuItem<SampleItem>(
                          value: SampleItem.itemOne,
                          child: Text('Item 1'),
                        ),
                        const PopupMenuItem<SampleItem>(
                          value: SampleItem.itemTwo,
                          child: Text('Item 2'),
                        ),
                        /* const PopupMenuItem<SampleItem>(
                          value: SampleItem.itemThree,
                          child: Text('Item 3'),
                        ), */
                      ], */
                      
                      /* child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                          ),
                          child: TextButton(
                            onPressed: () {
                              // No necesitamos una acción para el botón padre ya que abre el menú emergente
                            },
                            child: Icon(Icons.image), // Icono del botón padre
                          ),
                        ), */
                  //  ),
                /* PopupMenuButton(
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 'camera',
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: TextButton(
                                onPressed: () {
                                  // Tomar foto
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
                          ),
                          PopupMenuItem(
                            value: 'image',
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: TextButton(
                                onPressed: () {
                                  // Seleccionar imagen
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
                          ),
                        ],
                        onSelected: (value) {
                          // Acción al seleccionar un elemento del menú emergente
                          if (value == 'camera') {
                            // Acción para el botón de tomar foto
                          } else if (value == 'image') {
                            // Acción para el botón de seleccionar imagen
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                          ),
                          child: TextButton(
                            onPressed: () {
                              // No necesitamos una acción para el botón padre ya que abre el menú emergente
                            },
                            child: Icon(Icons.image), // Icono del botón padre
                          ),
                        ),
                      ), */
                //SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200]
                  ),
                  child: TextButton(
                    onPressed: () {
                      // Acción para el segundo botón
                    },
                    child: Icon(Icons.draw),
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
  
  void tomarFoto() {
    
  }
  
  void seleccionarImagen() {

    ImageField(onSave:(List<ImageAndCaptionModel>? imageAndCaptionList){
      
    });
  }



} //widget observer

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
