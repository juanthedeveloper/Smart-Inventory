import 'package:smart_inventory/databasedetails.dart';
import 'package:smart_inventory/itemscreen.dart';
import 'package:smart_inventory/materiallistscreen.dart';
import 'package:flutter/material.dart';
import 'package:smart_inventory/materialscreen.dart';

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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ItemScreen()));
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
  String? value1;
  String? value2;
  String? value3;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myControllerName.dispose();
    myControllerPrice.dispose();
    myControllerMaterial1.dispose();
    myControllerMaterial2.dispose();
    myControllerMaterial3.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    addMaptoList(); //update materialList
    materialList.add("None"); //adding a blank option

   const enterMatStyle = TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                );
    const enterMatHint =Text("Select material");


    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Item Details"),
      ),
      body: Stack(
        children: [
          Positioned(
            width: 400,
            height: 50,
            child: TextField(
                controller: myControllerName,
                decoration:
                    InputDecoration(hintText: "Enter name, then press enter."),
                onSubmitted: (String nameInput) {}),
          ),
          Positioned(
            top: 50,
            left: 0,
            width: 400,
            height: 50,
            child: TextField(
                controller: myControllerPrice,
                decoration:
                    InputDecoration(hintText: "Enter price, then press enter."),
                onSubmitted: (String priceInput) {}),
          ),
          Positioned(
            top: 100,
            left:0,
            height: 50,
            width: 250,
            child: DropdownButton<String>(
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
                  this.value1 = value1;
                });
              },
            ),
          ),
          Positioned(
            top: 150,
            left: 0,
            height: 50,
            width: 250,
            child: DropdownButton<String>(
                //Material 2
                //this allows materials to be selcted from the list
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
                    this.value2 = value2;
                  });
                }),
          ),
          Positioned(
            top: 200,
            left: 0,
            height: 50,
            width: 250,
            child: DropdownButton<String>(
              //Material 3
              //this allows materials to be selcted from the list
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
                  this.value3 = value3;
                });
              },
            ),
          ),
          Positioned(
            top: 300,
            child: ElevatedButton(
              child: Text("Submit"),
              onPressed: () async {
                var newItem = Items(
                  name: myControllerName.text,
                  price: double.parse(myControllerPrice.text),
                  material1: value1,
                  material2: value2,
                  material3: value3,
                );
                await insertItem(newItem);
                displaySuccessDialog(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
