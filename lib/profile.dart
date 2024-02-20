import 'package:assignment_project/database.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'mainmenu.dart';

import 'package:flutter/rendering.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({super.key, required this.title});
  final String title;
  @override
  Key? get key => const Key("MainMenu");

  double levelUpPercent = 0.0;
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  _ProfilePageState();

  @override
  Widget build(BuildContext context) {
    String currentName = DatabaseHelper.currentUser;
    String currentLevel = 32.toString();
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
                //Name
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Text(
                    "Name: $currentName",
                    style: const TextStyle(fontSize: 30),
                    textAlign: TextAlign.left,
                  ),
                ),
                //Level
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Text(
                    "Level: $currentLevel",
                    style: const TextStyle(fontSize: 30),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ), //Name and current level text row
          //Watched movies list
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.45,
            child: ListView(),
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
}
