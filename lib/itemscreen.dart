import 'package:smart_inventory/main.dart';
import 'package:flutter/material.dart';

import 'itemformscreen.dart';

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
        title: Text("Products"),
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
