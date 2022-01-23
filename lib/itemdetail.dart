import 'package:smart_inventory/main.dart';
import 'package:flutter/material.dart';



//shows item details currently 

class ItemDetail extends StatelessWidget {
  late int i;
  ItemDetail({Key? key, required int i}) : super(key: key) {
    this.i = i;
  }

  @override
  Widget build(BuildContext context) {
    String material1;

    return Scaffold(
      appBar: AppBar(
        title: Text(mapI[i]['name'].toUpperCase() +
            " details"), 
      ),
      body: ListView(
        children: [
          Text(
            mapI[i]['name'].trim(),
            style: TextStyle(fontSize: 30),
          ),
          Text(
            "Price: \$" + mapI[i]['price'].toString(),
          ),
          Text("Material 1: " + mapI[i]['material1']),
          Text("Material 2: " + mapI[i]['material2']),
          Text("Material 3: " + mapI[i]['material3']),
        ],
      ),
    );
  }
}
