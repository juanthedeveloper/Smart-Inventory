import 'dart:async';

import 'package:smart_inventory/databasedetails.dart';
import 'package:smart_inventory/main.dart';
import 'package:flutter/material.dart';

//displays all the materials and quanity
late List<String> materialList = [];
late String material;
late List<String> keysList = [];
//late double amountToAdd = 0;

addMaptoList() async {
  materialList
      .clear(); //needed so that the list isent being added infinite items every update/call

//adds the mapM list from db and adds it to a local materialist to display dropdown menu options
  for (int index = 0; index < mapM.length; index++) {
    materialList.add(mapM[index]['name']);
  }
}

Future<void> displayTextInputDialog(
  BuildContext context,
) async {
  //this brings up an alert dialog to input material
  final _textFieldController = TextEditingController();
  final _textFieldControllerQuanity = TextEditingController();
  late String material;
  late double materialKG;
  return await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Enter material name'),
        content: Row(
          children: <Widget>[
            Expanded(
              flex: 6,
              child: TextField(
                onChanged: (materialInput) {
                  material = materialInput;
                },
                controller: _textFieldController,
                decoration: InputDecoration(hintText: "Material"),
              ),
            ),
            Expanded(
              child: TextField(
                onChanged: (String materialQuanity) {
                  materialKG = double.parse(materialQuanity);
                },
                controller: _textFieldControllerQuanity,
                decoration: InputDecoration(hintText: "KG"),
              ),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: Text('OK'),
            onPressed: () async {
              //add to db
              var newMaterial = Materials(
                  name: material.toUpperCase().trimRight(),
                  quanity: materialKG);
              await insertMaterial(newMaterial);
              mapM = await db.query('materials');
              //add to map for drop down menu purposes
              addMaptoList(); //update the materialList values
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(material + " added."),
                ),
              );
            },
          ),
          TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              })
        ],
      );
    },
  );
}

Future<double> displayAmountToAdd(
  BuildContext context,
  int index,
) async {
  final _textFieldController = TextEditingController();
  double materialKG = 0;

  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Enter amount to add'),
        content: Row(
          children: <Widget>[
            Expanded(
              child: TextField(
                onChanged: (materialQuanity) {},
                controller: _textFieldController,
                decoration: InputDecoration(hintText: "KG"),
              ),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: Text('OK'),
            onPressed: () {
              materialKG = double.parse(_textFieldController.text);

              Navigator.pop(context);
            },
          ),
          TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              })
        ],
      );
    },
  );
  //return Future.delayed(Duration(seconds: 4),()=>materialKG);
  //return Future.microtask((i) => materialKG);
  return materialKG;
}

Future<void> displayDeleteDialog(
    BuildContext context, String deleteName) async {
  //this brings up an alert dialog to input material

  return await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Are you sure you would like to remove $deleteName?'),
        actions: <Widget>[
          TextButton(
            child: Text('OK'),
            onPressed: () async {
             await deleteMaterial(context, deleteName);
              addMaptoList();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(deleteName + " removed."),
              ));
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}

class MaterialListScreen extends StatefulWidget {
  const MaterialListScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MaterialListScreenState();
  }
}

class MaterialListScreenState extends State<MaterialListScreen> {
  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[400],
        appBar: AppBar(
          backgroundColor: Colors.grey[600],
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MyApp(),
              ),
            ),
          ),
          centerTitle: true,
          title: Text("Material List"),
        ),
        body: ListView(children: [
          for (int index = 0; index < mapM.length; index++)
            Stack(children: [
              Card(
                color: getColor(mapM[index]['name']),
                child: Column(
                  children: [
                    ListTile(
                      title: Text(
                        mapM[index]['name'],
                        style: TextStyle(
                          fontSize: 25,
                        ),
                      ),
                      leading: Image.asset('assets/icons/filamentRoll.png'),
                      subtitle: Text(
                        "KG: " + mapM[index]['quanity'].toString(),
                        style: TextStyle(fontSize: 17, color: Colors.black),
                      ),
                    ),
                    Row(
                      //Add and delete buttons
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 30,
                          child: TextButton(
                            child: Text(
                              "Add",
                              style: TextStyle(color: Colors.black),
                            ),
                            onPressed: () async {
                              final double amount =
                                  await displayAmountToAdd(context, index);

                              await addStock(context, mapM[index]['quanity'],
                                  mapM[index]['name'], amount);
                                  setState(() { });
                            },
                          ),
                        ),
                        SizedBox(
                          height: 30,
                          child: TextButton(
                            child: Text(
                              "Delete",
                              style: TextStyle(color: Colors.black),
                            ),
                            onPressed: () async {
                              await displayDeleteDialog(context, mapM[index]['name']);

                              setState(() {});
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ])
        ]),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: Ink(
            decoration:
                ShapeDecoration(color: Colors.grey[400], shape: CircleBorder()),
            child: IconButton(
              iconSize: 60,
              onPressed: () async {
                //_displayTextInputDialog(context);
               await  displayTextInputDialog(context);
               setState(() { });
               
              },
              icon: Image.asset('assets/icons/filamentPlusIco.png'),
            ),
          ),
        ));
  }

  getColor(String colorName) {
    //based on text
    if (colorName.contains("WHITE")) {
      return Colors.white;
    }
    if (colorName.contains("GREEN")) {
      return Colors.green[800];
    }
    if (colorName.contains("PURPLE")) {
      return Colors.purple;
    }
    if (colorName.contains("BLUE")) {
      return Colors.blue;
    }
    if (colorName.contains("GREY")) {
      return Colors.grey;
    }
    if (colorName.contains("YELLOW")) {
      return Colors.yellow;
    }
    if (colorName.contains("BROWN")) {
      return Colors.brown;
    }
    if (colorName.contains("ORANGE")) {
      return Colors.orange;
    }
    if (colorName.contains("RED")) {
      return Colors.red[800];
    }
    if (colorName.contains("BLACK")) {
      return Colors.black54;
    }
    if (colorName.contains("PINK")) {
      return Colors.pink;
    }
    if (colorName.contains("WOOD")) {
      return Colors.brown[300];
    }
    if (colorName.contains("TEAL")) {
      return Colors.teal;
    }
    if (colorName.contains("CYAN")) {
      return Colors.cyan;
    }
    if (colorName.contains("INDIGO")) {
      return Colors.indigo;
    }
  }
}
