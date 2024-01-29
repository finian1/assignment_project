import 'dart:async';

import 'package:assignment_project/mainmenu.dart';
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
      onCreate: (db, version) {
        db.execute(
          'CREATE TABLE movieGroups(id INTEGER PRIMARY KEY, groupName TEXT, movie1 INTEGER, movie2 INTEGER, movie3 INTEGER, movie4 INTEGER, movie5 INTEGER)',
        );
        print("created movieGroup table");

        db.execute(
          'CREATE TABLE movies(id INTEGER PRIMARY KEY, watched BIT)',
        );
        print("created movies table");
      },
      version: 1,
    );
    if (_database == null) {
      print("DB failed to init for some reason");
    } else {
      print("DB init succesful");
    }
    return _database;
  }

  static Future<void> createTables() async {
    Database db = await openDatabase(
        join(await getDatabasesPath(), "movie_groups_database.db"));

    print("Test");

    addNewMovie(0, false);
    addNewMovie(1, false);
    addNewMovie(2, false);
    addNewMovie(3, false);
    addNewMovie(4, false);
    addNewGroup(1, "test", [0, 1, 2, 3, 4]);
  }

  static Future<void> addNewMovie(int uniqueID, bool watched) async {
    Database db = await openDatabase(
        join(await getDatabasesPath(), "movie_groups_database.db"));
    Map<String, dynamic> input = {'id': uniqueID, 'watched': watched};
    int success = await db.insert(
      'movies',
      input,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print(success);
    if (success == 0) {
      print("Faild to add movie");
    }
  }

  static Future<void> addNewGroup(
      int uniqueID, String header, List<int> movieIDs) async {
    if (movieIDs.length < 5) {
      return;
    }

    Database db = await openDatabase(
        join(await getDatabasesPath(), "movie_groups_database.db"));
    Map<String, dynamic> input = {
      'id': uniqueID,
      //'groupName': header,
      'movie1': movieIDs[0],
      'movie2': movieIDs[1],
      'movie3': movieIDs[2],
      'movie4': movieIDs[3],
      'movie5': movieIDs[4],
    };
    int success = await db.insert(
      'movieGroups',
      input,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print(success);
    if (success == 0) {
      print("Faild to add group");
    }
  }

  static Future<List<MovieGroupData>> getMovieGroups() async {
    print("Opening database");
    Database db = await openDatabase(
        join(await getDatabasesPath(), "movie_groups_database.db"));
    print("Attempting to get group maps");
    final List<Map<String, dynamic>> groupMaps = await db.query('movieGroups');
    print("Got group maps");
    final List<Map<String, dynamic>> movieMaps = await db.query('movies');

    return List.generate(
      groupMaps.length,
      (i) {
        final List<MovieData> movieDatas = [
          MovieData(
              movieID: movieMaps[groupMaps[i]['movie1'] as int]['id'] as int,
              isCompleted:
                  movieMaps[groupMaps[i]['movie1'] as int]['watched'] == 0
                      ? false
                      : true),
          MovieData(
              movieID: movieMaps[groupMaps[i]['movie2'] as int]['id'] as int,
              isCompleted:
                  movieMaps[groupMaps[i]['movie2'] as int]['watched'] == 0
                      ? false
                      : true),
          MovieData(
              movieID: movieMaps[groupMaps[i]['movie3'] as int]['id'] as int,
              isCompleted:
                  movieMaps[groupMaps[i]['movie3'] as int]['watched'] == 0
                      ? false
                      : true),
          MovieData(
              movieID: movieMaps[groupMaps[i]['movie4'] as int]['id'] as int,
              isCompleted:
                  movieMaps[groupMaps[i]['movie4'] as int]['watched'] == 0
                      ? false
                      : true),
          MovieData(
              movieID: movieMaps[groupMaps[i]['movie5'] as int]['id'] as int,
              isCompleted:
                  movieMaps[groupMaps[i]['movie5'] as int]['watched'] == 0
                      ? false
                      : true),
        ];

        return MovieGroupData(
          id: groupMaps[i]['id'] as int,
          header: "TBD", //groupMaps[i]['header'] as String,
          data: movieDatas,
        );
      },
    );
  }
}
