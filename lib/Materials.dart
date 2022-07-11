import 'dart:async';
import 'package:firebase_database/firebase_database.dart';



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
  DatabaseReference materialsDb = FirebaseDatabase.instance.ref();
  materialsDb
      .child('Users/$uid/materials/')
      .update({materials.name: materials.quanity});
}

Future<void> deleteMaterial(var uid, var material) async {
  FirebaseDatabase.instance.ref('Users/$uid/materials/$material').remove();
}

Future<void> addStock(
    {required var currentQuanity,
    required String material,
    required double amountToAdd,
    required var uid}) async {
  FirebaseDatabase.instance
      .ref('Users/$uid/materials/')
      .update({material: currentQuanity + amountToAdd});
}
