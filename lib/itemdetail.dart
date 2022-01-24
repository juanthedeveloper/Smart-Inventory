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

const dividerMain = Divider(height: 20,thickness: 10,);
const divider = Divider(height: 20,thickness: 10,color: Colors.black,);

    return Scaffold(
      appBar: AppBar(
        title: Text(mapI[i]['name'].toUpperCase() + " details"),
      ),
      body: ListView(
        children: [
          Text(
            mapI[i]['name'].trim(),
            style: TextStyle(fontSize: 30),
          ),
          dividerMain,
          Text(
            "Price: \$" + mapI[i]['price'].toString(),
          ),
          divider,
          Row(
           children: [
            Text( mapI[i]['material1']),
            Text(" filament" +
                " per item: " +
                mapI[i]['m1Use'].toString()+" meters")
          ]),
          divider,
          //Text("Material 1: " + mapI[i]['material1']),
          //Text(mapI[i]['material1']+" per print: "+ mapI[i]['m1Use'].toString()),
          Text("Material 2: " + mapI[i]['material2']),
          divider,
          Text("Material 3: " + mapI[i]['material3']),
        ],
      ),
    );
  }
}
