import 'package:smart_inventory/databasedetails.dart';
import 'package:smart_inventory/main.dart';
import 'package:smart_inventory/materiallistscreen.dart';
import 'package:flutter/material.dart';

Future<void> displayDuplicateDialog(BuildContext context) async {
  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Duplicate Material'),
        actions: <Widget>[
          TextButton(
            child: Text("Ok"),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      );
    },
  );
}

addMaptoList() async {
  materialList
      .clear(); //needed so that the list isent being added infinite items every update/call

//adds the mapM list from db and adds it to a local materialist to display dropdown menu options
  for (int index = 0; index < mapM.length; index++) {
    materialList.add(mapM[index]['name']);
  }
}

Future<void> _displayTextInputDialog(BuildContext context) async {
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
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(material + " added."),
              ));
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

class MaterialScreen extends StatelessWidget {
  const MaterialScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        //the leading: is only so that when you press the back arrow it goes to the itemscreen if not it will
        //go back to the dialog menu from when you hit delete
        //this really needs to be fixed with an update UI on the dialog method but it will work for now
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const MyApp(),
            ),
          ),
        ),
        title: Text("Materials"),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              width: 150,
              child: ElevatedButton(
                child: Text("Add Material"), //show items
                onPressed: () {
                  _displayTextInputDialog(context);
                },
              ),
            ),
            Container(
              width: 150,
              child: ElevatedButton(
                child: Text("Show Materials"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MaterialListScreen(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
