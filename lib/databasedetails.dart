import 'dart:async';
import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;

import 'package:smart_inventory/main.dart';
import 'package:flutter/material.dart';
import 'package:smart_inventory/screens/materiallistscreen.dart';
import 'package:sqflite/sqflite.dart';

class Items {
  String name = "";
  double price;
  String material1;
  String material2;
  String material3;
  double m1Use = 0;
  double m2Use = 0;
  double m3Use = 0;
  String id = "Empty";

  Items({
    this.name = 'null',
    this.price = 0,
    this.material1 = 'None',
    this.material2 = 'None',
    this.material3 = 'None',
    this.m1Use = 0,
    this.m2Use = 0,
    this.m3Use = 0,
    this.id = "Empty",
  });

  Map<String, dynamic> toMapI() {
    return {
      'name': name,
      'price': price,
      'material1': material1,
      'material2': material2,
      'material3': material3,
      'm1Use': m1Use,
      'm2Use': m2Use,
      'm3Use': m3Use,
      'id': id
    };
  }

  @override
  String toString() {
    return 'Item{name:$name}';
  }
}

Future<void> insertItem(Items item) async {
  final url =
      Uri.https('flutterapitest-default-rtdb.firebaseio.com', '/products.json');
  return http
      .post(url,
          body: json.encode({
            'name': item.name,
            'price': item.price,
            'material1': item.material1,
            'material2': item.material2,
            'material3': item.material3,
            'm1Use': item.m1Use,
            'm2Use': item.m2Use,
            'm3Use': item.m3Use,
          }))
      .then((response) async {
    item.id = json.decode(response.body)['name'];
    //after loading to server is complete, add to local DB
    final db = await database;
    await db.insert('items', item.toMapI(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }).catchError((error) {
    print(error);
    throw error;
  });
}

Future<void> deleteItem(BuildContext context, String name, String id) async {
  final baseUrl =
      Uri.https('',id);


print(id);
  http.delete(baseUrl);

  final db = await database;
  db.delete("items", where: "name = ?", whereArgs: [name]);
  mapI = await db.query('items');
  //Navigator.push(
  //  context, MaterialPageRoute(builder: (context) => InventoryScreen()));
}

Future<void> updateItemDouble(BuildContext context, String name,
    String valueToChange, double updateAmount) async {
  final db = await database;
  await db.rawUpdate(
      'UPDATE items SET $valueToChange = $updateAmount WHERE name = "$name" ');
  mapI = await db.query('items');
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text("Changed $valueToChange to $updateAmount"),
  ));
}

class Materials {
  String name;
  double? quanity;
  String? id;

  Materials({required this.name, this.quanity, this.id});

  Map<String, dynamic> toMapM() {
    return {'name': name, 'quanity': quanity, 'id': id};
  }

  @override
  String toString() {
    return 'Materials{quanity:$quanity}';
  }
}

Future<void> insertMaterial(Materials materials, var uid) async {
  // Get a reference to the database.
   DatabaseReference materialsDb =FirebaseDatabase.instance.ref();
   materialsDb.child('Users/$uid/materials/').update({materials.name:materials.quanity});
 // materialsDb.child('Users/$uid/materials/${materials.name}').set('${materials.quanity}');

 
 
}

Future<void> deleteMaterial(BuildContext context, String name) async {
  final db = await database;
  db.delete("materials", where: "name = ?", whereArgs: [name]);
  mapM = await db.query('materials');
  //Navigator.push(
  //  context, MaterialPageRoute(builder: (context) => MaterialListScreen()));
}

Future<void> addStock(BuildContext context, double currentQuanity, String name,
    double amountToAdd) async {
  //final db = await database;
  double newStock;

  late double materialKG;
  newStock = currentQuanity + amountToAdd;
  await db.rawUpdate(
      'UPDATE materials SET quanity = $newStock WHERE name = "$name" ');
  mapM = await db.query('materials'); //update values
  //the following is only because setState is not working properly on other screen

  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text("Added $amountToAdd KG to $name"),
  ));
}
