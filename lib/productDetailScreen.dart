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
          title: Text(mapI[i]['material1']),
          leading: Image.asset('assets/icons/filamentRoll.png'),
        ),
      )
    ]));
  }
}
