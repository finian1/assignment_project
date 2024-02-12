import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'dart:async';

class AddGroupPage extends StatefulWidget {
  AddGroupPage({super.key, required this.title});
  final String title;
  @override
  State<AddGroupPage> createState() => _AddGroupPageState();
}

class _AddGroupPageState extends State<AddGroupPage> {
  _AddGroupPageState();

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          SizedBox(
            width: double.infinity,
            height: 50,
            child: Text(
              "Add Group",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 30),
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: 90,
            child: Row(
              children: [
                SizedBox(
                  width: 20,
                  height: 90,
                ),
                SizedBox(
                  width: 300,
                  height: 90,
                  child: TextFormField(
                    controller: searchController,
                    decoration: const InputDecoration(
                      labelText: 'Search...',
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.search),
                  label: Text(""),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: 500,
            child: ListView(children: [
              Card(child: Text("Movie 1")),
            ]),
          ),
          SizedBox(
            width: double.infinity,
            height: 100,
            child: Container(
              decoration:
                  BoxDecoration(color: Color.fromARGB(255, 186, 241, 255)),
              child: Column(
                children: [
                  Text("Selected1"),
                  Text("Selected2"),
                  Text("Selected3"),
                  Text("Selected4"),
                  Text("Selected5"),
                ],
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: 100,
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(onPressed: () {}, child: Text("Back")),
                  SizedBox(
                    width: 50,
                    height: 100,
                  ),
                  ElevatedButton(onPressed: () {}, child: Text("Create Group")),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
