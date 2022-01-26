import 'package:smart_inventory/databasedetails.dart';
import 'package:smart_inventory/itemdetail.dart';
import 'package:smart_inventory/main.dart';
import 'package:flutter/material.dart';
import 'package:smart_inventory/productDetailScreen.dart';

Future<void> displayDeleteDialog(BuildContext context, String name) async {
  //this brings up an alert dialog to input material

  //deleteName = deleteName;

  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Are you sure you would like to remove the item?'),
        actions: <Widget>[
          TextButton(
            child: Text('OK'),
            onPressed: () {
              deleteItem(context, name);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(name+ " removed."),));
              //SnackBar(content: Text("Item deleted"),);
            },
          ),
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}

class InventoryScreen extends StatefulWidget {
  InventoryScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {

  //allows the state to be updated when a value is changed
  void setState(VoidCallback fn) {
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const MyApp(),
            ),
          ),
        ),
        title: Text("InventoryScreen"),
      ),
      body: ListView(
        children: [
          for (int index = 0; index < mapI.length; index++)
            ElevatedButton(
              child: Text(mapI[index]['name']),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailScreen(
                      i: index,
                    ),
                  ),
                );
              },
              onLongPress: () {
                displayDeleteDialog(context, mapI[index]['name']);
              },
            ),
        ],
      ),
    );
  }
}
