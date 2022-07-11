import 'package:firebase_database/firebase_database.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:smart_inventory/Items.dart';
import 'package:smart_inventory/screens/itemformscreen.dart';
import 'package:smart_inventory/main.dart';
import 'package:flutter/material.dart';
import 'package:smart_inventory/screens/productDetailScreen.dart';

Future<void> displayDeleteDialog(
    BuildContext context, String name, String id) async {
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
              await deleteItem(context, name, id);
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
    required this.uid,
  }) : super(key: key);
  final String? uid;

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  late Stream<Map> productNameStream;
  late DatabaseReference productnameStreamRef;
  //allows the state to be updated when a value is changed
  void setState(VoidCallback fn) {
    super.setState(fn);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    productNameStream = FirebaseDatabase.instance
        .ref('Users/${widget.uid}/products')
       .onValue
        .map((event) => event.snapshot.value as Map<dynamic,dynamic>? ?? {} );
        
  }

  @override
  Widget build(BuildContext context) {
   // Items pokebal =  Items(name: "Pokeball");
    productnameStreamRef= FirebaseDatabase.instance
        .ref('Users/${widget.uid}/materials');

        //productnameStreamRef.update(name=pokebal.name);
    return StreamBuilder<Map>(
        stream: productNameStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return JumpingDotsProgressIndicator();
          } else if (snapshot.connectionState == ConnectionState.done ||
              snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else {
              //IF EVERYTHING WORKS IT WOULD BE THIS CASE
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
                     /* for (int index = 0;
                          index < snapshot.data!.length;
                          index++)*/
                        Stack(
                          children: [
                            Card(
                              //gets the background color based in string data
                              child: Column(
                                children: [
                                  ListTile(
                                    title: Text(snapshot.data!.keys.elementAt(0)),
                                    leading: Image.asset(
                                        "assets/icons/filamentRoll.png"),
                                    subtitle: Text(
                                      "KG: " +snapshot.data!.values.first.toString(),
                                      style: TextStyle(
                                          fontSize: 17, color: Colors.black),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                  /*
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
          ]*/
                  floatingActionButton: FloatingActionButton(
                    onPressed: () {},
                    child: Ink(
                      decoration: ShapeDecoration(
                          color: Colors.grey[400], shape: CircleBorder()),
                      child: IconButton(
                        iconSize: 100,
                        onPressed: () {
                          setState(() {});

                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ItemForm()));
                        },
                        icon: Image.asset('assets/icons/addBasketIco.png'),
                      ),
                    ),
                  ));
            }
          } else {
            return Text("error");
          }
        });
  }
}
