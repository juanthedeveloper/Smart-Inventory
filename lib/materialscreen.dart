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
              var newMaterial = Materials(name: material, quanity: materialKG);
              await insertMaterial(newMaterial);
              mapM = await db.query('materials');
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
}

class MaterialScreen extends StatelessWidget {
  const MaterialScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
