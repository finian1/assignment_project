import 'dart:async';
import 'package:flutter/material.dart';
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

class UserData {
  UserData(
      {required this.username, required this.settings, required this.xpValue});
  String username;
  List<Setting> settings;
  int xpValue;
}

class Setting {
  Setting({required this.settingName, required this.selected});
  String settingName = "";
  bool selected = false;

  Setting copy() {
    return Setting(selected: selected, settingName: settingName);
  }
}

class DatabaseHelper {
  static Database? _database;
  static TMDB tmdb = TMDB(ApiKeys('1701c7dbb0e18d0bd9948fd6d5ae94d7',
      'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIxNzAxYzdkYmIwZTE4ZDBiZDk5NDhmZDZkNWFlOTRkNyIsInN1YiI6IjY1YTM2OTlhZTljMGRjMDExZGE0NmU0NCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.lQkSajLr6dl5GpgIbktKqYdsTT7jOhbUxpV1XCb8rsw'));

  static const String baseUrl = "https://api.themoviedb.org/3";
  static const String imageBaseUrl = "https://image.tmdb.org/t/p/w500";
  static UserData currentUser =
      UserData(username: "", settings: [], xpValue: 0);
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
            'CREATE TABLE movieGroups(id INTEGER PRIMARY KEY, user STRING, groupName INTEGER, movie1 INTEGER, movie2 INTEGER, movie3 INTEGER, movie4 INTEGER, movie5 INTEGER)');
        db.execute(
            'CREATE TABLE movies(id STRING, user STRING, watched BIT, title STRING, PRIMARY KEY(id, user))');
        db.execute(
            'CREATE TABLE users(username STRING PRIMARY KEY, password STRING, xpValue INTEGER)');
        db.execute(
            'CREATE TABLE watchedMovies(id STRING, user STRING, title STRING, PRIMARY KEY(id, user))');
        db.execute(
            'CREATE TABLE settings(username STRING PRIMARY KEY, darkMode BIT, leftHand BIT, autoComplete BIT)');
      },
      version: 1,
    );
    return _database;
  }

  static Future<int> addNewUser(String username, String password) async {
    Database db = await openDatabase(
        join(await getDatabasesPath(), "movie_groups_database.db"));
    var checkResult =
        await db.rawQuery('SELECT * FROM users WHERE username = "$username"');
    if (checkResult.isNotEmpty) {
      //If user already exists...
      return -1;
    }
    Map<String, dynamic> user = {
      'username': username,
      'password': password,
      'xpValue': 0,
    };
    Map<String, dynamic> settings = {
      'username': username,
      'darkMode': false,
      'leftHand': false,
      'autoComplete': false,
    };
    await db.insert('users', user);
    await db.insert('settings', settings);
    return 1;
  }

  static Future<void> addUserExperience(int amount) async {
    Database db = await openDatabase(
        join(await getDatabasesPath(), "movie_groups_database.db"));
    Map<String, dynamic> input = {
      'xpValue': currentUser.xpValue + amount,
    };
    currentUser.xpValue += amount;
    db.update("users", input,
        where: "username = ?", whereArgs: [currentUser.username]);
  }

  static Future<Map<String, dynamic>> getUser(String username) async {
    Database db = await openDatabase(
        join(await getDatabasesPath(), "movie_groups_database.db"));
    final result =
        await db.query("users", where: "username = ?", whereArgs: [username]);
    return result[0];
  }

  static Future<int> attemptLogin(String username, String password) async {
    Database db = await openDatabase(
        join(await getDatabasesPath(), "movie_groups_database.db"));
    List<Map<String, dynamic>> checkResult;
    try {
      checkResult =
          await db.rawQuery('SELECT * FROM users WHERE username = "$username"');
    } catch (e) {
      return -1;
    }
    if (checkResult.isEmpty) {
      return -1;
    }
    List<Setting> userSettings = await DatabaseHelper.getSettings(username);
    Map userMap = checkResult[0];
    if (userMap['password'] == password) {
      currentUser = UserData(
          username: userMap['username'] as String,
          settings: userSettings,
          xpValue: userMap['xpValue'] as int);
      return 1;
    }
    return -1;
  }

  static Future<void> updateSettings(List<Setting> settings) async {
    Database db = await openDatabase(
        join(await getDatabasesPath(), "movie_groups_database.db"));
    Map<String, dynamic> input = {
      settings[0].settingName: settings[0].selected,
      settings[1].settingName: settings[1].selected,
      settings[2].settingName: settings[2].selected,
    };
    currentUser.settings = settings;
    db.update("settings", input,
        where: "username = ?", whereArgs: [currentUser.username]);
  }

  static Future<List<Setting>> getSettings(String username) async {
    Database db = await openDatabase(
        join(await getDatabasesPath(), "movie_groups_database.db"));
    List<Map<String, dynamic>> checkResult;
    try {
      checkResult = await db
          .rawQuery('SELECT * FROM settings WHERE username = "$username"');
    } catch (e) {
      return [];
    }
    if (checkResult.isEmpty) {
      return [];
    }
    Map userSettings = checkResult[0];
    return [
      Setting(
          settingName: "darkMode",
          selected: userSettings["darkMode"] as int == 0 ? false : true),
      Setting(
          settingName: "leftHand",
          selected: userSettings["leftHand"] as int == 0 ? false : true),
      Setting(
          settingName: "autoComplete",
          selected: userSettings["autoComplete"] as int == 0 ? false : true)
    ];
  }

  static Future<void> addNewMovie(
      String uniqueID, bool watched, String title) async {
    Database db = await openDatabase(
        join(await getDatabasesPath(), "movie_groups_database.db"));
    Map<String, dynamic> input = {
      'id': uniqueID,
      'user': currentUser.username,
      'watched': watched,
      'title': title
    };
    await db.insert(
      'movies',
      input,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> addWatchedMovie(String id, String title) async {
    Database db = await openDatabase(
        join(await getDatabasesPath(), "movie_groups_database.db"));
    Map<String, dynamic> input = {
      'id': id,
      'user': currentUser.username,
      'title': title
    };

    await db.insert("watchedMovies", input,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<void> removeWatchedMovie(String id) async {
    Database db = await openDatabase(
        join(await getDatabasesPath(), "movie_groups_database.db"));

    db.rawDelete('DELETE FROM watchedMovies WHERE id = ? AND user = ?',
        [id, currentUser.username]);
  }

  static Future<void> addNewGroup(String header, List<String> movieIDs) async {
    if (movieIDs.length < 5) {
      return;
    }

    Database db = await openDatabase(
        join(await getDatabasesPath(), "movie_groups_database.db"));
    final List<Map<String, dynamic>> groupMaps = await db.query('movieGroups');
    int uniqueID = groupMaps.length + 1;
    Map<String, dynamic> input = {
      'id': uniqueID,
      'user': currentUser.username,
      'groupName': header,
      'movie1': movieIDs[0],
      'movie2': movieIDs[1],
      'movie3': movieIDs[2],
      'movie4': movieIDs[3],
      'movie5': movieIDs[4],
    };
    await db.insert(
      'movieGroups',
      input,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> getWatchedMovies() async {
    Database db = await openDatabase(
        join(await getDatabasesPath(), "movie_groups_database.db"));
    return await db.query("watchedMovies",
        where: 'user = ?', whereArgs: [currentUser.username]);
  }

  static Future<List<MovieGroupData>> getMovieGroups() async {
    Database db = await openDatabase(
        join(await getDatabasesPath(), "movie_groups_database.db"));

    final List<Map<String, dynamic>> groupMaps = await db.query('movieGroups',
        where: 'user = ?', whereArgs: [currentUser.username]);
    final movieMaps = <Map<String, dynamic>>[];
    int movieID = -1;
    String username = currentUser.username;
    for (int i = 0; i < groupMaps.length; i++) {
      movieID = groupMaps[i]["movie1"] as int;
      List<Map<String, dynamic>> movieMap = await db.rawQuery(
          'SELECT * FROM movies WHERE "id" = $movieID AND "user" = "$username"');
      movieMaps.add(movieMap[0]);
      movieID = groupMaps[i]["movie2"] as int;
      movieMap = await db.rawQuery(
          'SELECT * FROM movies WHERE "id" = $movieID AND "user" = "$username"');
      movieMaps.add(movieMap[0]);
      movieID = groupMaps[i]["movie3"] as int;
      movieMap = await db.rawQuery(
          'SELECT * FROM movies WHERE "id" = $movieID AND "user" = "$username"');
      movieMaps.add(movieMap[0]);
      movieID = groupMaps[i]["movie4"] as int;
      movieMap = await db.rawQuery(
          'SELECT * FROM movies WHERE "id" = $movieID AND "user" = "$username"');
      movieMaps.add(movieMap[0]);
      movieID = groupMaps[i]["movie5"] as int;
      movieMap = await db.rawQuery(
          'SELECT * FROM movies WHERE "id" = $movieID AND "user" = "$username"');
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

  static Future<void> removeGroup(int id) async {
    Database db = await openDatabase(
        join(await getDatabasesPath(), "movie_groups_database.db"));

    db.rawDelete('DELETE FROM movieGroups WHERE id = ?', [id]);
  }

  static Future<void> updateMovieData(List<MovieGroupData> data) async {
    Database db = await openDatabase(
        join(await getDatabasesPath(), "movie_groups_database.db"));

    for (MovieGroupData groupData in data) {
      for (MovieData movieData in groupData.data) {
        Map<String, dynamic> input = {
          'watched': movieData.isCompleted,
        };
        int movieID = movieData.movieID;
        db.update("movies", input,
            where: "id = ? AND user = ?",
            whereArgs: [movieID, currentUser.username]);
      }
    }
  }

  static MovieData generateMovieData(Map<String, dynamic> movieMap) {
    return MovieData(
        movieID: movieMap['id'] as int,
        isCompleted: movieMap['watched'] == 0 ? false : true,
        movieName: movieMap['title'] as String);
  }
}
