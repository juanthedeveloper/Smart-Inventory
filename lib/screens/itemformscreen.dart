import 'package:smart_inventory/databasedetails.dart';
import 'package:smart_inventory/screens/productsscreen.dart';
import 'package:smart_inventory/screens/materiallistscreen.dart';
import 'package:flutter/material.dart';

import '../main.dart';

displaySuccessDialog(BuildContext context) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Added Item'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => InventoryScreen()));
              },
            ),
          ],
        );
      });
}

class ItemForm extends StatefulWidget {
  const ItemForm({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return ItemFormState();
  }
}

class ItemFormState extends State<ItemForm> {
  final myControllerName = TextEditingController();
  final myControllerPrice = TextEditingController();
  final myControllerMaterial1 = TextEditingController();
  final myControllerMaterial2 = TextEditingController();
  final myControllerMaterial3 = TextEditingController();
  final myControllerm1Use = TextEditingController();
  final myControllerm2Use = TextEditingController();
  final myControllerm3Use = TextEditingController();
  String value1 = "None";
  String value2 = "None";
  String value3 = "None";
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myControllerName.dispose();
    myControllerPrice.dispose();
    myControllerMaterial1.dispose();
    myControllerMaterial2.dispose();
    myControllerMaterial3.dispose();
    myControllerm1Use.dispose();
    myControllerm2Use.dispose();
    myControllerm3Use.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    addMaptoList(); //update materialList
    materialList.add("None"); //adding a blank option

    const enterMatStyle = TextStyle(
      fontSize: 20,
      color: Colors.black,
    );
    const enterMatHint = Text("Select material");

    return Scaffold(
      backgroundColor: Colors.grey[400],
      body: Stack(
        children: [
          Positioned(
              top: 80,
              width: 400,
              height: 50,
              child: Card(
                child: TextField(
                    controller: myControllerName,
                    decoration: InputDecoration(
                        hintText: "Enter name, then press enter.",
                        border: OutlineInputBorder()),
                    onSubmitted: (String nameInput) {}),
              )),
          Positioned(
            top: 140,
            left: 0,
            width: 400,
            height: 50,
            child: Card(
              child: TextField(
                  controller: myControllerPrice,
                  decoration: InputDecoration(
                      hintText: "Enter price, then press enter.",
                      border: OutlineInputBorder()),
                  onSubmitted: (String priceInput) {}),
            ),
          ),
          Positioned(
            top: 193,
            left: 0,
            height: 58,
            width: 250,
            child: Card(
              child: DropdownButton<String>(
                underline: SizedBox(),
                //Material 1
                //this allows materials to be selcted from the list
                hint: enterMatHint,
                isExpanded: true,
                value: value1,
                style: enterMatStyle,
                items: materialList.map((String items) {
                  return DropdownMenuItem(
                    value: items,
                    child: Text(items),
                  );
                }).toList(),
                onChanged: (value1) {
                  setState(() {
                    this.value1 = value1.toString();
                  });
                },
              ),
            ),
          ),
          Positioned(
            top: 194,
            left: 260,
            width: 140,
            child: Card(
              child: TextField(
                controller: myControllerm1Use,
                decoration: InputDecoration(hintText: "Material use(mm)"),
              ),
            ),
          ),
          Positioned(
            top: 248,
            left: 0,
            height: 58,
            width: 250,
            child: Card(
              child: DropdownButton<String>(
                  //Material 2
                  underline: SizedBox(),
                  hint: enterMatHint,
                  isExpanded: true,
                  value: value2,
                  style: enterMatStyle,
                  items: materialList.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );
                  }).toList(),
                  onChanged: (value2) {
                    setState(() {
                      this.value2 = value2.toString();
                    });
                  }),
            ),
          ),
          Positioned(
            top: 249,
            left: 260,
            width: 140,
            child: Card(
              child: TextField(
                controller: myControllerm2Use,
                decoration: InputDecoration(hintText: "Material use(mm)"),
              ),
            ),
          ),
          Positioned(
            top: 302,
            left: 0,
            height: 58,
            width: 250,
            child: Card(
              child: DropdownButton<String>(
                //Material 3
                underline: SizedBox(),
                hint: enterMatHint,
                isExpanded: true,
                value: value3,
                style: enterMatStyle,
                items: materialList.map((String items) {
                  return DropdownMenuItem(
                    value: items,
                    child: Text(items),
                  );
                }).toList(),
                onChanged: (value3) {
                  setState(() {
                    this.value3 = value3.toString();
                  });
                },
              ),
            ),
          ),
          Positioned(
            top: 303,
            left: 260,
            width: 140,
            child: Card(
              child: TextField(
                controller: myControllerm3Use,
                decoration: InputDecoration(hintText: "Material use(mm)"),
              ),
            ),
          ),
          Positioned(
            top: 400,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.grey[600]),
              child: Text(
                "Submit",
              ),
              onPressed: () async {
                double m1use;
                double m2use;
                double m3use;
                if (myControllerm1Use.text == "") {
                  m1use = 0;
                } else {
                  m1use = double.parse(myControllerm1Use.text);
                }

                if (myControllerm2Use.text == "") {
                  m2use = 0;
                } else {
                  m2use = double.parse(myControllerm2Use.text);
                }

                if (myControllerm3Use.text == "") {
                  m3use = 0;
                } else {
                  m3use = double.parse(myControllerm3Use.text);
                }

                var newItem = Items(
                  name: myControllerName.text,
                  price: double.parse(myControllerPrice.text),
                  material1: value1.toString(),
                  material2: value2.toString(),
                  material3: value3.toString(),
                  m1Use: m1use,
                  m2Use: m2use,
                  m3Use: m3use,
                );
                await insertItem(newItem);
                mapI = await db.query(
                    'items'); //query new db item and go back to last screen
                addMaptoList(); //update count
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(newItem.name + " added"),
                ));
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => InventoryScreen()));
              },
            ),
          ),
        ],
      ),
    );
  }
}
