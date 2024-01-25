import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Database? _database;

  ///Returns db instance if already opened
  ///else call the initDatabase
  static Future<Database?> getDBConnector() async {
    if (_database != null) {
      return _database;
    }

    return await _initDatabase();
  }

  ///Open DB Connection, returns a Database instance.
  ///
  static Future<Database?> _initDatabase() async {
    WidgetsFlutterBinding.ensureInitialized();
    _database = await openDatabase(
      join(await getDatabasesPath(), "movie_groups_database.db"),
      onCreate: (db, version) async {
        //on create
        db.execute(
          'CREATE TABLE movieGroups(id INTEGER PRIMARY KEY, movie1 INTEGER, movie2 INTEGER, movie3 INTEGER, movie4 INTEGER, movie5 INTEGER)',
        );
        db.execute(
          'CREATE TABLE movies(id INTEGER PRIMARY KEY, watched BIT, tmdbID INTEGER)',
        );
      },
      version: 1,
    );

    return _database;
  }
  //the same with edit, delete
}
