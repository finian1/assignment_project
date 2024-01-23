import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class MovieData {
  MovieData({required this.movieID, required this.isCompleted});
  bool isCompleted;
  int movieID;
}

class MovieGroupData {
  MovieGroupData({required this.header, this.data});
  String header;
  List<MovieData>? data;
}

class MainMenuPage extends StatefulWidget {
  const MainMenuPage({super.key, required this.title, this.tmdb});
  final tmdb;
  final String title;

  @override
  State<MainMenuPage> createState() => _MainMenuPageState();
}

class _MainMenuPageState extends State<MainMenuPage> {
  _MainMenuPageState();
  CarouselController movieGroupsController = CarouselController();
  final List<MovieGroupData> groupData = [
    //Group 1
    MovieGroupData(
      header: "Test 1",
      data: [
        MovieData(movieID: 1, isCompleted: false),
        MovieData(movieID: 2, isCompleted: false),
        MovieData(movieID: 3, isCompleted: false),
        MovieData(movieID: 4, isCompleted: false),
        MovieData(movieID: 5, isCompleted: false),
      ],
    ),
    MovieGroupData(
      header: "Test 2",
      data: [
        MovieData(movieID: 6, isCompleted: false),
        MovieData(movieID: 7, isCompleted: false),
        MovieData(movieID: 8, isCompleted: false),
        MovieData(movieID: 9, isCompleted: false),
        MovieData(movieID: 10, isCompleted: false),
      ],
    ),
    MovieGroupData(
      header: "Test 3",
      data: [
        MovieData(movieID: 11, isCompleted: false),
        MovieData(movieID: 12, isCompleted: false),
        MovieData(movieID: 13, isCompleted: false),
        MovieData(movieID: 14, isCompleted: false),
        MovieData(movieID: 15, isCompleted: false),
      ],
    ),
    MovieGroupData(
      header: "Test 4",
      data: [
        MovieData(movieID: 16, isCompleted: false),
        MovieData(movieID: 17, isCompleted: false),
        MovieData(movieID: 18, isCompleted: false),
        MovieData(movieID: 19, isCompleted: false),
        MovieData(movieID: 20, isCompleted: false),
      ],
    ),
  ];
  List<MovieGroup>? movieGroups;

  @override
  Widget build(BuildContext context) {
    movieGroups = List<MovieGroup>.generate(
      5,
      (index) => MovieGroup(
        header: groupData[index].header,
        index: index,
      ),
    );
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
}

class MovieGroup extends StatefulWidget {
  MovieGroup({super.key, this.header = "", required this.index});
  final String header;
  final int index;
  @override
  State<MovieGroup> createState() => _MovieGroupState();
}

class _MovieGroupState extends State<MovieGroup> {
  List<Widget> movies = [];

  @override
  Widget build(BuildContext context) {
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
}

class MovieCard extends StatefulWidget {
  MovieCard({super.key, this.movieName = "", required this.index});
  final String movieName;
  final int index;
  @override
  State<MovieCard> createState() => _MovieCardState();
}

class _MovieCardState extends State<MovieCard> {
  final key = GlobalKey<_MovieGroupState>();
  bool isChecked = false;
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
                value: isChecked,
                onChanged: (val) {
                  setState(() {
                    isChecked = val!;
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
