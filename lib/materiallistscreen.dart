

import 'package:smart_inventory/main.dart';
import 'package:smart_inventory/materialscreen.dart';
import 'package:flutter/material.dart';



//displays all the materials only currently

final materialList = <String>[];
late String material;
final Map<String, double> materialMap = {};
late List<String> keysList = [];

Future<void> displayDeleteDialog(
    BuildContext context, String deleteName) async {
  //this brings up an alert dialog to input material

  //deleteName = deleteName;

  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Are you sure you would like to remove material?'),
        actions: <Widget>[
          TextButton(
            child: Text('OK'),
            onPressed: () {
              materialMap.removeWhere((key, value) => key == deleteName);
              //materialList.remove(materialList[indexDeleteM]);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const MaterialListScreen(), //navigates to the material screen, it really should just reload ui but this is a bandaid
                ),
              );
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

class MaterialListScreen extends StatefulWidget {
  const MaterialListScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MaterialListScreenState();
  }
}

class MaterialListScreenState extends State<MaterialListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //the leading: is only so that when you press the back arrow it goes to the itemscreen if not it will
        //go back to the dialog menu from when you hit delete
        //this really needs to be fixed with an update UI on the dialog method but it will work for now
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const MaterialScreen(),
            ),
          ),
        ),
        title: Text("Material List"),
      ),
      body: ListView(
        children: [
          for (int index=0; index<mapM.length;index++)
            Stack(
              children: [
                Container( width: 250,
                  child: ElevatedButton(
                    child: Text(mapM[index]['name']),
                    onPressed: () {},
                    onLongPress: () {
                      displayDeleteDialog(context, mapM[index]['name']);
                    },
                  ),
                ),
                Positioned( width:150,  left: 260,
                  child: ElevatedButton(
                    child: Text("KG: " + mapM[index]['quanity'].toString()),
                    onPressed: () {},
                    onLongPress: () {
                      
                    },
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
