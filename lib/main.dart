import 'package:smart_inventory/itemscreen.dart';
import 'package:smart_inventory/materialscreen.dart';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'inventoryscreen.dart';
 

late final db;
late final database;
late List<Map<String, dynamic>> mapI;
late List<Map<String, dynamic>> mapM;

main() async {
  runApp(const MaterialApp(
    home: MyApp(),
  ));

  WidgetsFlutterBinding.ensureInitialized();
// Open the database and store the reference.
  database = openDatabase(
    // Set the path to the database. Note: Using the `join` function from the
    // `path` package is best practice to ensure the path is correctly
    // constructed for each platform.
    join(await getDatabasesPath(), 'itemMaterial.db'),

// When the database is first created, create a table to store items.
    onCreate: (db, version) {
      // Run the CREATE TABLE statement on the database.
      db.execute('CREATE TABLE items(name TEXT PRIMARY KEY, price REAL, material1 TEXT, material2 TEXT, material3 TEXT, m1Use REAL, m2Use REAL, m3Use REAL)',);
      db.execute('CREATE TABLE materials(name TEXT PRIMARY KEY, quanity REAL)');
    },
    
    version: 1,
  );

  db = await database; //this is for initializing db query for inventory display
  mapI = await db.query('items');
  mapM = await db.query('materials');
  addMaptoList();//initialize materialList with mapM names
  

}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  //_ turns classes into private classes

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        //the entire screen becomes this widget with custom settings
        appBar: AppBar( centerTitle: true,
            //the tittle header
            title: Text("Smart Inventory",)),
        body: Center(
          child: Column(
            children: [
              Image.asset('assets/images/main.png'),
              SizedBox(
                width: 110,
                child: ElevatedButton(
                  child: Text("Inventory"),
                  onPressed: () async {
                    mapI = await db.query('items');
                    addMaptoList(); //update count
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => InventoryScreen()));
                  },
                ),
              ),
              SizedBox(
                width: 110,
                child: ElevatedButton(
                  child: Text("Items"),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ItemScreen()));
                  },
                ),
              ),
              SizedBox(
                width: 110,
                child: ElevatedButton(
                  child: Text(
                    "Material",
                  ),
                  //same as the .elementAt etc
                  onPressed: () async {
                    mapM = await db.query('materials');
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MaterialScreen()));
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
