import 'package:smart_inventory/Items.dart';
import 'package:smart_inventory/screens/itemformscreen.dart';
import 'package:smart_inventory/main.dart';
import 'package:flutter/material.dart';
import 'package:smart_inventory/screens/productDetailScreen.dart';

Future<void> displayDeleteDialog(BuildContext context, String name, String id) async {
  //this brings up an alert dialog to input material

  return await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Are you sure you would like to remove $name material?'),
        actions: <Widget>[
          TextButton(
            child: Text('OK'),
            onPressed: () async {
              await deleteItem(context, name,id);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(name + " removed."),
              ));
              Navigator.pop(context);
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
        backgroundColor: Colors.grey[400],
        appBar: AppBar(
          backgroundColor: Colors.grey[600],
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: Text("Products"),
        ),
        body: ListView(
          children: [
            for (int index = 0; index < mapI.length; index++)
              Card(
                child: Column(
                  children: [
                    ListTile(
                      title: Text(
                        mapI[index]['name'],
                        style: TextStyle(
                          fontSize: 25,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductDetailScreen(
                              i: index,
                            ),
                          ),
                        );
                      },
                      onLongPress: () async {
                        await displayDeleteDialog(context, mapI[index]['name'],mapI[index]['id']);
                        setState(() {});
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        
                        SizedBox(
                          height: 30,
                          child: TextButton(
                            child: Text("Delete",
                                style: TextStyle(color: Colors.black)),
                            onPressed: () async {
                              await displayDeleteDialog(
                                  context, mapI[index]['name'],mapI[index]['id']);
                              setState(() {});
                            },
                          ),
                        )
                      ],
                    )
                  ],
                ),
              )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: Ink(
            decoration:
                ShapeDecoration(color: Colors.grey[400], shape: CircleBorder()),
            child: IconButton(
              iconSize: 100,
              onPressed: () {
                setState(() {});

                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => ItemForm()));
              },
              icon: Image.asset('assets/icons/addBasketIco.png'),
            ),
          ),
        ));
  }
}
