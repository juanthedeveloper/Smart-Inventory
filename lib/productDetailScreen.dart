import 'package:flutter/material.dart';

import 'main.dart';

class ProductDetailScreen extends StatelessWidget {
  late int i;
  ProductDetailScreen({Key? key, required int i}) : super(key: key) {
    this.i = i;
  }

  @override
  Widget build(BuildContext context) {
    String material1;

    return Scaffold(
        body: ListView(children: <Widget>[
      ListTile(
        title: (Text(mapI[i]['name'], style: TextStyle(fontSize: 60))),
      ),
      Card(
        child: ListTile(
          title: Text("\$" + mapI[i]['price'].toString()),
          leading: Image.asset('assets/icons/moneyIco.png'),
          
        ),
      ),
      Card(
        child: ListTile(
          title: Text(mapI[i]['material1'].toString()),
          leading: Image.asset('assets/icons/filamentRoll.png'),
          subtitle: Text(mapI[i]['m1Use'].toString()+"mm") ,
        ),
      ),
      Card(
        child: ListTile(
          title: Text(mapI[i]['material2'].toString()),
          leading: Image.asset('assets/icons/filamentRoll.png'),
        ),
      ),
      Card(
        child: ListTile(
          title: Text(mapI[i]['material3'].toString()),
          leading: Image.asset('assets/icons/filamentRoll.png'),
        ),
      ),
    ]));
  }
}
