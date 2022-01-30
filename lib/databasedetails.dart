import 'dart:async';

import 'package:smart_inventory/screens/productsscreen.dart';
import 'package:smart_inventory/main.dart';
import 'package:smart_inventory/screens/materiallistscreen.dart';
import 'package:flutter/material.dart';
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

  Items(
      {this.name = 'null',
      this.price = 0,
      this.material1 = 'None',
      this.material2 = 'None',
      this.material3 = 'None',
      this.m1Use = 0,
      this.m2Use = 0,
      this.m3Use = 0});

  Map<String, dynamic> toMapI() {
    return {
      'name': name,
      'price': price,
      'material1': material1,
      'material2': material2,
      'material3': material3,
      'm1Use': m1Use,
      'm2Use': m2Use,
      'm3Use': m3Use
    };
  }

  @override
  String toString() {
    return 'Item{name:$name}';
  }
}

Future<void> insertItem(Items item) async {
  // Get a reference to the database.
  final db = await database;

  // Insert the Dog into the correct table. You might also specify the
  // `conflictAlgorithm` to use in case the same dog is inserted twice.
  //
  // In this case, replace any previous data.
  await db.insert(
    'items',
    item.toMapI(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<void> deleteItem(BuildContext context, String name) async {
  final db = await database;
  db.delete("items", where: "name = ?", whereArgs: [name]);
  mapI = await db.query('items');
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => InventoryScreen()));
}

class Materials {
  String name;
  double? quanity;

  Materials({required this.name, this.quanity});

  Map<String, dynamic> toMapM() {
    return {'name': name, 'quanity': quanity};
  }

  @override
  String toString() {
    return 'Materials{quanity:$quanity}';
  }
}

Future<void> insertMaterial(Materials materials) async {
  // Get a reference to the database.
  final db = await database;

  // `conflictAlgorithm` to use in case the same material is inserted twice.\
  // In this case, replace any previous data.
  await db.insert(
    'materials',
    materials.toMapM(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
  mapM = await db.query('materials');
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
