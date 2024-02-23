import 'package:assignment_project/database.dart';
import 'package:flutter/material.dart';
import 'package:tmdb_api/tmdb_api.dart';
import 'dart:async';
import 'mainmenu.dart';

import 'package:flutter/rendering.dart';

const int XP_PER_LEVEL = 100;

class ProfilePage extends StatefulWidget {
  ProfilePage({super.key, required this.title});
  final String title;
  @override
  Key? get key => const Key("MainMenu");

  List<Map<String, dynamic>> watchedMovies = [];
  Map<String, dynamic> user = {};
  double levelUpPercent = 0.0;
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  _ProfilePageState();

  @override
  void initState() {
    super.initState();
    getWatchedMovies();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    String currentName = "N/A";
    String currentLevel = "N/A";
    if (widget.user.isNotEmpty) {
      currentName = DatabaseHelper.currentUser.username;
      currentLevel =
          (DatabaseHelper.currentUser.xpValue ~/ XP_PER_LEVEL).toString();
    }
    return Scaffold(
      body: Column(
        children: [
          //Header image
          Image.network(
            'https://picsum.photos/seed/746/600',
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.15,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: MediaQuery.of(context).size.height * 0.15,
                color: const Color.fromARGB(255, 59, 255, 157),
              );
            },
          ),
          //Name and current level text row
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
            child: Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.05,
                ),
                //Name
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.45,
                  child: Text(
                    "Name: $currentName",
                    style: const TextStyle(fontSize: 30),
                    textAlign: TextAlign.left,
                  ),
                ),
                //Level
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.45,
                  child: Text(
                    "Level: $currentLevel",
                    style: const TextStyle(fontSize: 30),
                    textAlign: TextAlign.right,
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.05,
                ),
              ],
            ),
          ), //Name and current level text row
          //Watched movies list
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.04,
            child: const Text(
              "Watched Movies",
              style: TextStyle(fontSize: 30),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.45,
            color: Color.fromARGB(255, 227, 240, 255),
            child: MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: ListView.builder(
                itemCount: widget.watchedMovies.length,
                itemBuilder: (context, index) {
                  return Container(
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 141, 194, 255),
                        border: Border.all(
                          width: 1.0,
                          color: Color.fromARGB(255, 227, 240, 255),
                        ),
                      ),
                      child: Text(
                        widget.watchedMovies[index]['title'],
                        textAlign: TextAlign.center,
                      ));
                },
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width * 0.3,
            child: ElevatedButton(
              child: const Text("Back"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          )
        ],
      ),
    );
  }

  Future<void> getWatchedMovies() async {
    List<Map<String, dynamic>> movies = await DatabaseHelper.getWatchedMovies();
    setState(() {
      widget.watchedMovies = movies;
    });
  }

  Future<void> getUser() async {
    Map<String, dynamic> user =
        await DatabaseHelper.getUser(DatabaseHelper.currentUser.username);
    setState(() {
      widget.user = user;
    });
  }
}
