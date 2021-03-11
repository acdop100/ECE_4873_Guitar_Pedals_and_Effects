import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/widgets.dart';
import 'main.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();
}

// Standard effect class
class Effect {
  int id;
  String name;
  int enabled = 0;

  Effect({
    this.id,
    this.name,
    this.enabled = 0,
  });

  // Convert an effect into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'enabled': enabled,
    };
  }
}

class Patch {
  int id;
  String name;
  List<Effect> effects;

  Patch({
    this.id,
    this.name,
    this.effects,
  });

  // Convert an effect into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'effects': effects,
    };
  }
}

Future<void> insertPatch(Patch patch) async {
  // Get a reference to the database.
  final Database db = await database;
  print("inserted");
  // Insert the Patch into the correct table. Also specify the
  // `conflictAlgorithm`. In this case, if the same patch is inserted
  // multiple times, it replaces the previous data.
  await db.insert(
    'patches',
    patch.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<void> deletePatch(int id) async {
  // Get a reference to the database.
  final db = await database;

  // Remove the Patch from the database.
  await db.delete(
    'patches',
    // Use a `where` clause to delete a specific patch.
    where: "id = ?",
    // Pass the Patch's id as a whereArg to prevent SQL injection.
    whereArgs: [id],
  );
}

Future<List<Patch>> patches() async {
  // Get a reference to the database.
  final Database db = await database;

  // Query the table for all The Patches.
  final List<Map<String, dynamic>> maps = await db.query('patches');

  // Convert the List<Map<String, dynamic> into a List<Patch>.
  return List.generate(maps.length, (i) {
    return Patch(
      id: maps[i]['id'],
      name: maps[i]['name'],
      effects: maps[i]['effects'],
    );
  });
}