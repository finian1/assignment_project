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
      onCreate: (db, version) async {
        //on create
        db.execute(
          'CREATE TABLE movieGroups(id INTEGER PRIMARY KEY, header TEXT, movie1 INTEGER, movie2 INTEGER, movie3 INTEGER, movie4 INTEGER, movie5 INTEGER)',
        );
        db.execute(
          'CREATE TABLE movies(id INTEGER PRIMARY KEY, watched BIT)',
        );

        addNewMovie(1, false);
        addNewMovie(2, false);
        addNewMovie(3, false);
        addNewMovie(4, false);
        addNewMovie(5, false);
        addNewGroup(1, "test", [1, 2, 3, 4, 5]);
      },
      version: 1,
    );

    return _database;
  }

  static Future<void> addNewMovie(int uniqueID, bool watched) async {
    Map<String, dynamic> input = {'id': uniqueID, 'watched': watched};
    await _database!.insert(
      'movies',
      input,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> addNewGroup(
      int uniqueID, String header, List<int> movieIDs) async {
    if (movieIDs.length < 5) {
      return;
    }
    Map<String, dynamic> input = {
      'id': uniqueID,
      'header': header,
      'movie1': movieIDs[0],
      'movie2': movieIDs[1],
      'movie3': movieIDs[2],
      'movie4': movieIDs[3],
      'movie5': movieIDs[4],
    };
    await _database!.insert(
      'movieGroups',
      input,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<MovieGroupData>> getMovieGroups() async {
    final List<Map<String, dynamic>> groupMaps =
        await _database!.query('movieGroups');
    final List<Map<String, dynamic>> movieMaps =
        await _database!.query('movies');

    return List.generate(
      groupMaps.length,
      (i) {
        final List<MovieData> movieDatas = [
          MovieData(
              movieID: movieMaps[groupMaps[i]['movie1'] as int]['id'] as int,
              isCompleted:
                  movieMaps[groupMaps[i]['movie1'] as int]['watched'] as bool),
          MovieData(
              movieID: movieMaps[groupMaps[i]['movie2'] as int]['id'] as int,
              isCompleted:
                  movieMaps[groupMaps[i]['movie2'] as int]['watched'] as bool),
          MovieData(
              movieID: movieMaps[groupMaps[i]['movie3'] as int]['id'] as int,
              isCompleted:
                  movieMaps[groupMaps[i]['movie3'] as int]['watched'] as bool),
          MovieData(
              movieID: movieMaps[groupMaps[i]['movie4'] as int]['id'] as int,
              isCompleted:
                  movieMaps[groupMaps[i]['movie4'] as int]['watched'] as bool),
          MovieData(
              movieID: movieMaps[groupMaps[i]['movie5'] as int]['id'] as int,
              isCompleted:
                  movieMaps[groupMaps[i]['movie5'] as int]['watched'] as bool),
        ];

        return MovieGroupData(
          id: groupMaps[i]['id'] as int,
          header: groupMaps[i]['header'] as String,
          data: movieDatas,
        );
      },
    );
  }
}
