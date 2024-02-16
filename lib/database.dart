import 'dart:async';

import 'package:assignment_project/mainmenu.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tmdb_api/tmdb_api.dart';

class MovieData {
  MovieData(
      {required this.movieID,
      required this.isCompleted,
      required this.movieName});
  bool isCompleted;
  int movieID;
  String movieName;
}

class MovieGroupData {
  MovieGroupData(
      {required this.id, required this.header, this.data = const []});
  int id;
  String header;
  List<MovieData> data;
}

class DatabaseHelper {
  static Database? _database;
  static TMDB tmdb = TMDB(ApiKeys('1701c7dbb0e18d0bd9948fd6d5ae94d7',
      'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIxNzAxYzdkYmIwZTE4ZDBiZDk5NDhmZDZkNWFlOTRkNyIsInN1YiI6IjY1YTM2OTlhZTljMGRjMDExZGE0NmU0NCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.lQkSajLr6dl5GpgIbktKqYdsTT7jOhbUxpV1XCb8rsw'));

  static const String baseUrl = "https://api.themoviedb.org/3";
  static const String imageBaseUrl = "https://image.tmdb.org/t/p/w500";

  static Future<String> getNameFromID(int id) async {
    Map movie = await tmdb.v3.movies.getDetails(id);
    try {
      return movie['title'] as String;
    } catch (e) {
      return "Error Finding Name";
    }
  }

  static Future<List<dynamic>> searchForMovies(String name) async {
    Map movies = await tmdb.v3.search.queryMovies(name);

    return movies['results'];
  }

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
          'CREATE TABLE movieGroups(id INTEGER PRIMARY KEY, groupName INTEGER, movie1 INTEGER, movie2 INTEGER, movie3 INTEGER, movie4 INTEGER, movie5 INTEGER)',
        );
        print("created movieGroup table");

        db.execute(
          'CREATE TABLE movies(id STRING PRIMARY KEY, watched BIT, title STRING)',
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
    //Database db = await openDatabase(
    //    join(await getDatabasesPath(), "movie_groups_database.db"));
    //await addNewMovie(0, false);
    //await addNewMovie(1, false);
    //await addNewMovie(2, false);
    //await addNewMovie(3, false);
    //await addNewMovie(4, false);
    //await addNewGroup(1, "test", [0, 1, 2, 3, 4]);
    //await addNewGroup(2, "hello", [2, 3, 1, 3, 4]);
  }

  static Future<void> addNewMovie(
      String uniqueID, bool watched, String title) async {
    Database db = await openDatabase(
        join(await getDatabasesPath(), "movie_groups_database.db"));
    Map<String, dynamic> input = {
      'id': uniqueID,
      'watched': watched,
      'title': title
    };
    int success = await db.insert(
      'movies',
      input,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print(success);
  }

  static Future<void> addNewGroup(String header, List<String> movieIDs) async {
    if (movieIDs.length < 5) {
      return;
    }

    Database db = await openDatabase(
        join(await getDatabasesPath(), "movie_groups_database.db"));
    final List<Map<String, dynamic>> groupMaps = await db.query('movieGroups');
    //List<Map> uniqueIDrow =
    //await db.rawQuery('SELECT MAX(id) FROM movieGroups');
    int uniqueID = groupMaps.length + 1;
    //try {
    //  uniqueID = uniqueIDrow[0]['id'] as int;
    //} catch (e) {
    //  uniqueID = -1;
    //}
    //uniqueID++;
    Map<String, dynamic> input = {
      'id': uniqueID,
      'groupName': header,
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
  }

  static Future<List<MovieGroupData>> getMovieGroups() async {
    print("Opening database");
    Database db = await openDatabase(
        join(await getDatabasesPath(), "movie_groups_database.db"));

    final List<Map<String, dynamic>> groupMaps = await db.query('movieGroups');
    final movieMaps = <Map<String, dynamic>>[];
    int movieID = -1;
    for (int i = 0; i < groupMaps.length; i++) {
      movieID = groupMaps[i]["movie1"] as int;
      List<Map<String, dynamic>> movieMap =
          await db.rawQuery('SELECT * FROM movies WHERE "id" = $movieID');
      movieMaps.add(movieMap[0]);
      movieID = groupMaps[i]["movie2"] as int;
      movieMap =
          await db.rawQuery('SELECT * FROM movies WHERE "id" = $movieID');
      movieMaps.add(movieMap[0]);
      movieID = groupMaps[i]["movie3"] as int;
      movieMap =
          await db.rawQuery('SELECT * FROM movies WHERE "id" = $movieID');
      movieMaps.add(movieMap[0]);
      movieID = groupMaps[i]["movie4"] as int;
      movieMap =
          await db.rawQuery('SELECT * FROM movies WHERE "id" = $movieID');
      movieMaps.add(movieMap[0]);
      movieID = groupMaps[i]["movie5"] as int;
      movieMap =
          await db.rawQuery('SELECT * FROM movies WHERE "id" = $movieID');
      movieMaps.add(movieMap[0]);
    }
    //We need to go through

    return List.generate(
      groupMaps.length,
      (i) {
        final List<MovieData> movieDatas = [
          generateMovieData(movieMaps[i * 5 + 0]),
          generateMovieData(movieMaps[i * 5 + 1]),
          generateMovieData(movieMaps[i * 5 + 2]),
          generateMovieData(movieMaps[i * 5 + 3]),
          generateMovieData(movieMaps[i * 5 + 4]),
        ];

        return MovieGroupData(
          id: groupMaps[i]['id'] as int,
          header: groupMaps[i]['groupName'] as String,
          data: movieDatas,
        );
      },
    );
  }

  static MovieData generateMovieData(Map<String, dynamic> movieMap) {
    return MovieData(
        movieID: movieMap['id'] as int,
        isCompleted: movieMap['watched'] == 0 ? false : true,
        movieName: movieMap['title'] as String);
  }
}
