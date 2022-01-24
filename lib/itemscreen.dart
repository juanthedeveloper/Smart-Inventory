import 'package:smart_inventory/main.dart';
import 'package:flutter/material.dart';

import 'itemformscreen.dart';

class Item {
  String label = "";
  double price = 0;
  String material1 = "none";
  String material2 = "none";
  String material3 = "none";

  Item(
      {String label = "null",
      double price = 0,
      String material1 = "None",
      String material2 = "None",
      String material3 = "None"}) {
    this.label = label;
    this.price = price;
    this.material1 = material1;
    this.material2 = material2;
    this.material3 = material3;
  }

  String get getLabel {
    return label;
  }

  void set setLabel(String label) {
    this.label = label;
  }

  void setPrice(double price) {
    this.price = price;
  }

  void setMaterial1(String name) {
    material1 = name;
  }

  void setMaterial2(String name) {
    material2 = name;
  }

  void setMaterial3(String name) {
    material3 = name;
  }
}

class ItemScreen extends StatelessWidget {
  const ItemScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true,
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
        title: Text("Items"),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              width: 110,
              child: ElevatedButton(
                child: Text("Add Item"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ItemForm(),
                    ),
                  );
                },
              ),
            ),
            Container( width: 110,
              child: ElevatedButton(
                //show items
                child: Text("Delete Item"),
                onPressed: () {
                  
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
