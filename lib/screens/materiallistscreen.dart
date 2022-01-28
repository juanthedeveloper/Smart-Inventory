import 'dart:async';

import 'package:smart_inventory/databasedetails.dart';
import 'package:smart_inventory/main.dart';
import 'package:smart_inventory/nolongerused/materialscreenREMOVED.dart';
import 'package:flutter/material.dart';

//displays all the materials and quanity
late List<String> materialList = [];
late String material;
late List<String> keysList = [];

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
  return showDialog(
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
              var newMaterial =
                  Materials(name: material.toUpperCase(), quanity: materialKG);
              await insertMaterial(newMaterial);
              mapM = await db.query('materials');
              //add to map for drop down menu purposes
              addMaptoList(); //update the materialList values
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MaterialListScreen()));
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

Future<void> displayDeleteDialog(
    BuildContext context, String deleteName) async {
  //this brings up an alert dialog to input material

  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Are you sure you would like to remove material?'),
        actions: <Widget>[
          TextButton(
            child: Text('OK'),
            onPressed: () {
              deleteMaterial(context, deleteName);
              addMaptoList();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(deleteName + " removed."),
              ));
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
    // TODO: implement setState
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      body: ListView(
        children: [
          for (int index = 0; index < mapM.length; index++)
            Stack(
              children: [
                Container(
                  width: 250,
                  child: ElevatedButton(
                    child: Text(mapM[index]['name']),
                    onPressed: () {},
                    onLongPress: () {
                      displayDeleteDialog(context, mapM[index]['name']);
                    },
                  ),
                ),
                Positioned(
                  width: 150,
                  left: 260,
                  child: ElevatedButton(
                    child: Text("KG: " + mapM[index]['quanity'].toString()),
                    onPressed: () {},
                    onLongPress: () {},
                  ),
                ),
              ],
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: IconButton(
          onPressed: () {
            //_displayTextInputDialog(context);
            displayTextInputDialog(context);
          },
          icon: Image.asset('assets/icons/addBasketIco.png'),
        ),
      ),
    );
  }
}
