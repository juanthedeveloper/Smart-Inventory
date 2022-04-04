import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:smart_inventory/screens/productsscreen.dart';
import 'package:smart_inventory/screens/materiallistscreen.dart';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:smart_inventory/screens/signup.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:sqflite/sqflite.dart';
import 'screens/home.dart';
import 'screens/productsscreen.dart';

late final db;
late final database;
late List<Map<String, dynamic>> mapI;
late List<Map<String, dynamic>> mapM;

main() async {
  

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
 

// Open the database and store the reference.
  database = openDatabase(
    // Set the path to the database. Note: Using the `join` function from the
    // `path` package is best practice to ensure the path is correctly
    // constructed for each platform.
    join(await getDatabasesPath(), 'itemMaterial.db'),

// When the database is first created, create a table to store items.
    onCreate: (db, version) {
      // Run the CREATE TABLE statement on the database.
      db.execute(
        'CREATE TABLE items(name TEXT PRIMARY KEY, price REAL, material1 TEXT, material2 TEXT, material3 TEXT, m1Use REAL, m2Use REAL, m3Use REAL, id TEXT)',
      );
      db.execute(
          'CREATE TABLE materials(name TEXT PRIMARY KEY, quanity REAL, id TEXT)');
    },

    version: 1,
  );

  db = await database; //this is for initializing db query for inventory display
  mapI = await db.query('items');
  mapM = await db.query('materials');
  addMaptoList(); //initialize materialList with mapM names
runApp(MaterialApp(
    home: IntroScreen(),
  ));
}

class IntroScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User? result = FirebaseAuth.instance.currentUser;
    return  SplashScreen(
      //navigateAfterFuture: updateValue(result.uid),
        useLoader: true,
        loadingTextPadding: EdgeInsets.all(0),
        loadingText: Text(""),
        navigateAfterSeconds: result != null ? Home(uid: result.uid) : SignUp(),
        seconds: 5,
        title:Text(
          'Welcome To Smart Inventory!',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
        ),
        //image: Image.asset('assets/images/dart.png', fit: BoxFit.scaleDown),
        backgroundColor: Colors.white,
        styleTextUnderTheLoader: new TextStyle(),
        photoSize: 100.0,
        onClick: () => print("flutter"),
        loaderColor: Colors.red);
  }
}


