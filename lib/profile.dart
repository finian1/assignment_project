import 'package:assignment_project/database.dart';
import 'package:assignment_project/settings.dart';
import 'package:flutter/material.dart';
import 'dart:async';

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

//Profile page, displays the user's current name and level, as well as all the movies that the user has watched.
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
            color: const Color.fromARGB(255, 227, 240, 255),
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
                        color: const Color.fromARGB(255, 141, 194, 255),
                        border: Border.all(
                          width: 1.0,
                          color: const Color.fromARGB(255, 227, 240, 255),
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
            height: MediaQuery.of(context).size.height * 0.07,
            width: MediaQuery.of(context).size.width * 1.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.07,
                width: MediaQuery.of(context).size.width * 0.3,
                child: ElevatedButton(
                  child: const Text("Back"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.07,
                width: MediaQuery.of(context).size.width * 0.1,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.07,
                width: MediaQuery.of(context).size.width * 0.3,
                //Settings button
                child: ElevatedButton.icon(
                  label: const Text(""),
                  icon: const Icon(
                    Icons.settings,
                    color: Color.fromARGB(255, 255, 255, 255),
                    size: 40,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SettingsPage(
                          title: 'Settings',
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    fixedSize: const Size(100, 100),
                    padding: const EdgeInsets.only(left: 10.0),
                    backgroundColor: const Color.fromARGB(255, 0, 255, 242),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  //Returns the current user's watched movies
  Future<void> getWatchedMovies() async {
    List<Map<String, dynamic>> movies = await DatabaseHelper.getWatchedMovies();
    setState(() {
      widget.watchedMovies = movies;
    });
  }

  //Gets the current user's name and sets the user string variable
  Future<void> getUser() async {
    Map<String, dynamic> user =
        await DatabaseHelper.getUser(DatabaseHelper.currentUser.username);
    setState(() {
      widget.user = user;
    });
  }
}
