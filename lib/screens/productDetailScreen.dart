import 'package:flutter/material.dart';

import '../main.dart';

enum popList { edit, delete }

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
      body: ListView(
        children: <Widget>[
          
          ListTile(
            title: (Text(mapI[widget.i]['name'].toString(),
                style: TextStyle(fontSize: 60))),
          ),
          Card(
            child: ListTile(
              title: Text("\$" + mapI[widget.i]['price'].toString()),
              leading: Image.asset('assets/icons/moneyIco.png'),
              trailing: IconButton(
                icon: Image.asset('assets/icons/toolboxIco.png'),
                onPressed: () {},
              ),
            ),
          ),
          Card(
            child: ListTile(
              title: Text(mapI[widget.i]['material1'].toString()),
              leading: Image.asset('assets/icons/filamentRoll.png'),
              subtitle: Text(mapI[widget.i]['m1Use'].toString() + "mm"),
              trailing: IconButton(
                icon: Image.asset('assets/icons/toolboxIco.png'),
                onPressed: () {},
              ),
            ),
          ),
          Card(
            child: ListTile(
              title: Text(mapI[widget.i]['material2'].toString()),
              leading: Image.asset('assets/icons/filamentRoll.png'),
              subtitle: Text(mapI[widget.i]['m2Use'].toString() + "mm"),
              trailing: IconButton(
                icon: Image.asset('assets/icons/toolboxIco.png'),
                onPressed: () {},
              ),
            ),
          ),
          Card(
            child: ListTile(
              title: Text(mapI[widget.i]['material3'].toString()),
              leading: Image.asset('assets/icons/filamentRoll.png'),
              subtitle: Text(mapI[widget.i]['m3Use'].toString() + "mm"),
              trailing: IconButton(
                icon: Image.asset('assets/icons/toolboxIco.png'),
                onPressed: () {},
              ),
            ),
          ),
        ],
      ),
    );
  }
}
