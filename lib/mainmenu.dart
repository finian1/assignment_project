import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tmdb_api/tmdb_api.dart';
import 'dart:io';

import 'database.dart';

class MovieData {
  MovieData({required this.movieID, required this.isCompleted});
  bool isCompleted;
  int movieID;
}

class MovieGroupData {
  MovieGroupData(
      {required this.id, required this.header, this.data = const []});
  int id;
  String header;
  List<MovieData> data;
}

class MainMenuPage extends StatefulWidget {
  const MainMenuPage({super.key, required this.title});
  final String title;
  @override
  Key? get key => const Key("MainMenu");

  @override
  State<MainMenuPage> createState() => _MainMenuPageState();
}

class _MainMenuPageState extends State<MainMenuPage> {
  _MainMenuPageState();
  CarouselController movieGroupsController = CarouselController();
  List<MovieGroupData> groupData = [];

  List<MovieGroup>? movieGroups;
  bool dataGrabbed = false;

  @override
  void initState() {
    super.initState();
    initGroupData();
    //while (!dataGrabbed) {}
  }

  @override
  Widget build(BuildContext context) {
    print("Buildin");
    return Scaffold(
      body: ListView(
        children: [
          SizedBox(
            width: double.infinity,
            height: 408,
            child: CarouselSlider(
              items: movieGroups,
              carouselController: movieGroupsController,
              options: CarouselOptions(
                initialPage: 1,
                viewportFraction: 0.5,
                disableCenter: true,
                enlargeCenterPage: true,
                enlargeFactor: 0.25,
                enableInfiniteScroll: true,
                scrollDirection: Axis.horizontal,
                autoPlay: false,
              ),
            ),
          ),
          SizedBox(
            height: 201,
            child: Row(
              children: [
                Align(
                  alignment: AlignmentDirectional(-1, 0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      'https://picsum.photos/seed/426/600',
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Level: 5\nXP: 929'),
                    Slider(
                      value: 0.5,
                      onChanged: (val) {},
                    )
                  ],
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Profile'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void onMovieChanged(int groupIndex, int movieIndex, bool val) {
    setState(() {
      groupData[groupIndex].data[movieIndex].isCompleted = val;
    });
  }

  Future<void> initGroupData() async {
    print("grabbing data");
    groupData = await DatabaseHelper.getMovieGroups();
    setState(() {
      movieGroups = List<MovieGroup>.generate(
        groupData.length,
        (index) => MovieGroup(
          header: groupData[index].header,
          index: index,
          onMovieChanged: onMovieChanged,
          movieData: groupData[index].data,
        ),
      );
      dataGrabbed = true;
    });
    print("Data grabbed");
  }
}

//A movie group is a panel within the carrousel that shows five movies and a completion value.
class MovieGroup extends StatefulWidget {
  MovieGroup(
      {super.key,
      this.header = "",
      required this.index,
      required this.onMovieChanged,
      required this.movieData});
  final String header;
  final int index;
  final Function(int, int, bool) onMovieChanged;
  final List<MovieData> movieData;
  @override
  State<MovieGroup> createState() => _MovieGroupState();
}

class _MovieGroupState extends State<MovieGroup> {
  List<MovieCard> movies = [];
  @override
  Widget build(BuildContext context) {
    movies = List<MovieCard>.generate(
        widget.movieData.length,
        (index) => MovieCard(
              index: index,
              onMovieCompleted: onMovieChanged,
              movieName: "",
              isCompleted: widget.movieData[index].isCompleted,
            ));
    return Column(
      children: [
        Text(widget.header),
        ListView(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          children: movies,
        ),
        const Divider(
          thickness: 1,
        ),
        Text(
          'Completion %',
        ),
        Slider(
          value: 0.5,
          onChanged: (val) {},
        ),
      ],
    );
  }

  void onMovieChanged(int index, bool val) {
    widget.onMovieChanged(widget.index, index, val);
  }
}

//Movie cards display the movie's name and if the movie has been watched.
class MovieCard extends StatefulWidget {
  MovieCard({
    super.key,
    this.movieName = "",
    required this.index,
    required this.onMovieCompleted,
    required this.isCompleted,
  });

  final String movieName;
  final int index;
  final Function(int, bool) onMovieCompleted;
  bool isCompleted;
  @override
  State<MovieCard> createState() => _MovieCardState();
}

class _MovieCardState extends State<MovieCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 190,
      height: 59,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Color(0xFF00D2FF),
        shape: BoxShape.rectangle,
        border: Border.all(
          width: 2,
        ),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(widget.movieName),
            Theme(
              data: ThemeData(
                checkboxTheme: CheckboxThemeData(
                  visualDensity: VisualDensity.compact,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              child: Checkbox(
                value: widget.isCompleted,
                onChanged: (val) {
                  setState(() {
                    widget.isCompleted = val!;
                    widget.onMovieCompleted(widget.index, val);
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
