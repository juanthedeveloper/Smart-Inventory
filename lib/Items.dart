
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:smart_inventory/main.dart';
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
  final baseUrl = Uri.https('', id);

  print(id);
  http.delete(baseUrl);

 
  db.delete("items", where: "name = ?", whereArgs: [name]);
  mapI = await db.query('items');
  //Navigator.push(
  //  context, MaterialPageRoute(builder: (context) => InventoryScreen()));
}

Future<void> updateItemDouble(BuildContext context, String name,
    String valueToChange, double updateAmount) async {
 
  await db.rawUpdate(
      'UPDATE items SET $valueToChange = $updateAmount WHERE name = "$name" ');
  mapI = await db.query('items');
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text("Changed $valueToChange to $updateAmount"),
  ));
}
