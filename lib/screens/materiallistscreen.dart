import 'dart:async';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:smart_inventory/Materials.dart';
import 'package:smart_inventory/main.dart';
import 'package:flutter/material.dart';

//TODO remove all positioned widgets with rows and columns

//this brings up an alert dialog to input material
Future<void> _displayMaterialInput(BuildContext context, var uid) async {
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
              await insertMaterial(newMaterial, uid);
              mapM = await db.query('materials');
              //add to map for drop down menu purposes
              // addMaptoList(); //update the materialList values
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

//this brings up an dialog to take an input to add quanity to stock
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
  return materialKG;
}

//to delete a material
Future<void> displayDeleteDialog(
    BuildContext context, var uid, var material) async {
  return await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Are you sure you would like to remove $material?'),
        actions: <Widget>[
          TextButton(
            child: Text('OK'),
            onPressed: () async {
              deleteMaterial(uid, material);

              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(material + " removed."),
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
  const MaterialListScreen({Key? key, required this.uid}) : super(key: key);
  final String? uid;

  @override
  State<StatefulWidget> createState() {
    return MaterialListScreenState();
  }
}

class MaterialListScreenState extends State<MaterialListScreen> {
  late Stream<Map<dynamic, dynamic>> stream;
  late DatabaseReference materials;

  @override
  void initState() {
    super.initState();

    stream = FirebaseDatabase.instance
        .ref('Users/${widget.uid}/materials')
        .onValue
        .map((event) => event.snapshot.value as Map<dynamic, dynamic>);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<dynamic, dynamic>>(
        stream: stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return JumpingDotsProgressIndicator();
          } else if (snapshot.connectionState == ConnectionState.done ||
              snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else {
              //IF EVERYTHING WORKS IT WOULD BE THIS CASE
              return Scaffold(
                backgroundColor: Colors.grey[400],
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: Colors.grey[600],
                  centerTitle: true,
                  title: Text("Material List"),
                ),
                body: ListView(children: [
                  for (int index = 0; index < snapshot.data!.length; index++)
                    Stack(children: [
                      Card(
                        color: getColor(snapshot.data!.keys
                            .elementAt(index)
                            .toString()
                            .toUpperCase()), //gets the background color based in string data
                        child: Column(
                          children: [
                            ListTile(
                              title: Text(snapshot.data!.keys
                                  .elementAt(index)
                                  .toString()),
                              leading:
                                  Image.asset("assets/icons/filamentRoll.png"),
                              subtitle: Text(
                                "KG: " +
                                    snapshot.data!.values
                                        .elementAt(index)
                                        .toString(),
                                style: TextStyle(
                                    fontSize: 17, color: Colors.black),
                              ),
                            ),
                            Row(
                              //Add and delete buttons
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(
                                  height: 30,
                                  child: TextButton(
                                    child: Text(
                                      "Add",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    onPressed: () async {
                                      //wait for amount to be return
                                      final double amount =
                                          await displayAmountToAdd(
                                              context, index);
                                      if (amount > 0) {
                                        addStock(
                                            currentQuanity: snapshot
                                                .data!.values
                                                .elementAt(index),
                                            material: snapshot.data!.keys
                                                .elementAt(index)
                                                .toString(),
                                            amountToAdd: amount,
                                            uid: widget.uid);

                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text(
                                              "Added $amount to ${snapshot.data!.keys.elementAt(index).toString()}"),
                                        ));

                                        setState(() {});
                                      }
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                  child: TextButton(
                                    child: const Text(
                                      "Delete",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    onPressed: () async {
                                      displayDeleteDialog(
                                          context,
                                          widget.uid,
                                          snapshot.data!.keys
                                              .elementAt(index)
                                              .toString());
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
                  //bottom right button to add materials
                  onPressed: () {},
                  child: Ink(
                    decoration: ShapeDecoration(
                        color: Colors.grey[400], shape: CircleBorder()),
                    child: IconButton(
                      iconSize: 60,
                      onPressed: () async {
                        //enter material
                        await _displayMaterialInput(context, widget.uid);
                        setState(() {});
                      },
                      icon: Image.asset('assets/icons/filamentPlusIco.png'),
                    ),
                  ),
                ),
              );
            }
          } else {
            return Text("idfk");
          }
        });
  }
}

//return a color if string matches a color

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
