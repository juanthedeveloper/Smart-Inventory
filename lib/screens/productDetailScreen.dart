import 'package:flutter/material.dart';
import 'package:smart_inventory/Items.dart';


import '../main.dart';
import 'materiallistscreen.dart';

Future<double> _displayChangedouble(
    BuildContext context, String updateField) async {
  final _textFieldController = TextEditingController();
  double newdouble = 0;

  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Enter new $updateField:'),
        content: Row(
          children: <Widget>[
            Expanded(
              child: TextField(
                onChanged: (materialQuanity) {},
                controller: _textFieldController,
                decoration: InputDecoration(hintText: "\$"),
              ),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: Text('OK'),
            onPressed: () {
              newdouble = double.parse(_textFieldController.text);
              Navigator.pop(context);
              _textFieldController.dispose();
            },
          ),
          TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
                _textFieldController.dispose();
                return;
              })
        ],
      );
    },
  );
  return newdouble;
}

class ProductDetailScreen extends StatefulWidget {
  late int i;
  ProductDetailScreen({Key? key, required int i}) : super(key: key) {
    this.i = i;
  }

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[400],
      body: ListView(
        children: <Widget>[
          Card(
            color: Colors.grey[600],
            child: ListTile(
              title: (Text(mapI[widget.i]['name'].toString(),
                  style: TextStyle(fontSize: 50, color: Colors.white))),
            ),
          ),
          Card(
            //price
            child: ListTile(
              title: Text("\$" + mapI[widget.i]['price'].toString()),
              leading: Image.asset('assets/icons/moneyIco.png'),
              trailing: IconButton(
                icon: Image.asset('assets/icons/toolboxIco.png'),
                onPressed: () async {
                  final double newValue =
                      await _displayChangedouble(context, 'price');
                  if (newValue != 0) {
                    await updateItemDouble(
                        context, mapI[widget.i]['name'], 'price', newValue);
                    setState(() {});
                  }
                },
              ),
            ),
          ),
          if (mapI[widget.i]['material1'].toString() != "None")
            Card(
              //MATERIAL1
              color: getColor(mapI[widget.i]['material1'].toString()),
              child: ListTile(
                title: Text(
                  mapI[widget.i]['material1'].toString(),
                  textScaleFactor: 1.5,
                ),
                leading: Image.asset('assets/icons/filamentRoll.png'),
                subtitle: Text(mapI[widget.i]['m1Use'].toString() + "mm",
                    textScaleFactor: 1.5,
                    style: TextStyle(color: Colors.black)),
              ),
            ),
          if (mapI[widget.i]['material2'].toString() != "None")
            Card(
              //MATERIAL 2
              color: getColor(mapI[widget.i]['material2'].toString()),
              child: ListTile(
                title: Text(
                  mapI[widget.i]['material2'].toString(),
                  textScaleFactor: 1.5,
                ),
                leading: Image.asset('assets/icons/filamentRoll.png'),
                subtitle: Text(mapI[widget.i]['m2Use'].toString() + "mm",
                    textScaleFactor: 1.5,
                    style: TextStyle(color: Colors.black)),
              ),
            ),
          if (mapI[widget.i]['material3'].toString() != "None")
            Card(
              //MATERIAL 3
              color: getColor(mapI[widget.i]['material3'].toString()),
              child: ListTile(
                title: Text(
                  mapI[widget.i]['material3'].toString(),
                  textScaleFactor: 1.5,
                ),
                leading: Image.asset('assets/icons/filamentRoll.png'),
                subtitle: Text(mapI[widget.i]['m3Use'].toString() + "mm",
                    textScaleFactor: 1.5,
                    style: TextStyle(color: Colors.black)),
              ),
            ),
          /*Card(
            //firebase ID
            child: ListTile(
              title: Text(
                mapI[widget.i]['id'],
                textScaleFactor: 1.5,
              ),
              leading: Image.asset('assets/icons/filamentRoll.png'),
            ),
          ),*/
          if (mapI[widget.i]['material3'].toString() == "None" &&
              mapI[widget.i]['material2'].toString() == "None" &&
              mapI[widget.i]['material1'].toString() == "None")
            Card(
              child: Text(
                "No materials. Delete item and add again with correct materials.",
                style: TextStyle(fontSize: 40),
              ),
            )
        ],
      ),
    );
  }
}
