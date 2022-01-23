import 'dart:async';

import 'package:smart_inventory/inventoryscreen.dart';
import 'package:smart_inventory/main.dart';
import 'package:smart_inventory/materiallistscreen.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class Items {
  String name;
  double? price;
  String? material1;
  String? material2;
  String? material3;

  Items({
    required this.name,
    required this.price,
    this.material1,
    this.material2,
    this.material3,
  });

  Map<String, dynamic> toMapI() {
    return {
      'name': name,
      'price': price,
      'material1': material1,
      'material2': material2,
      'material3': material3,
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

  Materials({
    required this.name,
    this.quanity
  });

  Map<String, dynamic> toMapM() {
    return {
      'name': name,
      'quanity':quanity
    };
  }

  @override
  String toString() {
    return 'Materials{name:$name}';
  }
}

Future<void> insertMaterial(Materials materials) async {
  // Get a reference to the database.
  final db = await database;

  // Insert the Dog into the correct table. You might also specify the
  // `conflictAlgorithm` to use in case the same dog is inserted twice.
  //
  // In this case, replace any previous data.
  await db.insert(
    'materials',
    materials.toMapM(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<void> deleteMaterial(BuildContext context, String name) async {
  final db = await database;
  db.delete("materials", where: "name = ?", whereArgs: [name]);
  mapM = await db.query('materials');
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => MaterialListScreen()));
}
