import 'package:assignment_project/addgroup.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'dart:async';
import 'database.dart';
import 'profile.dart';

class MainMenuPage extends StatefulWidget {
  MainMenuPage({super.key, required this.title});
  final String title;
  @override
  Key? get key => const Key("MainMenu");

  List<MovieGroupData> groupData = [];
  List<MovieGroup> movieGroups = [];

  double levelUpPercent = 0.0;
  @override
  State<MainMenuPage> createState() => _MainMenuPageState();
}

class _MainMenuPageState extends State<MainMenuPage> {
  _MainMenuPageState();
  CarouselController movieGroupsController = CarouselController();

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    initGroupData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          //Profile box
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.2,
            child: Row(
              children: [
                Align(
                  alignment: const AlignmentDirectional(-1, 0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      'https://picsum.photos/seed/426/600',
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 100,
                          height: 100,
                          color: const Color.fromARGB(255, 59, 255, 157),
                        );
                      },
                    ),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                        'Level: ${DatabaseHelper.currentUser.xpValue ~/ XP_PER_LEVEL}\nXP: ${DatabaseHelper.currentUser.xpValue % XP_PER_LEVEL}'),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                          thumbColor: Colors.transparent,
                          thumbShape: const RoundSliderThumbShape(
                              enabledThumbRadius: 0.0)),
                      child: Slider(
                        //Getting percentage remaining
                        value: 1 -
                            ((XP_PER_LEVEL -
                                    (DatabaseHelper.currentUser.xpValue %
                                        XP_PER_LEVEL)) /
                                XP_PER_LEVEL),
                        onChanged: (val) {},
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.5,
            //Group carousel
            child: CarouselSlider(
              items: widget.movieGroups,
              carouselController: movieGroupsController,
              options: CarouselOptions(
                initialPage: 0,
                viewportFraction: 0.5,
                disableCenter: true,
                enlargeCenterPage: true,
                enlargeFactor: 0.25,
                enableInfiniteScroll: false,
                scrollDirection: Axis.horizontal,
                autoPlay: false,
                onPageChanged: (index, reason) {
                  _currentIndex = index;
                },
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.25,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //Remove group button
                    ElevatedButton.icon(
                      icon: const Icon(
                        Icons.remove_circle_outline,
                        color: Color.fromARGB(255, 255, 255, 255),
                        size: 80,
                      ),
                      onPressed: () {
                        if (widget.groupData.isNotEmpty) {
                          showDialog<void>(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Remove Group"),
                                content: const Text(
                                    "Are you sure you want to remove this group?"),
                                actions: [
                                  TextButton(
                                    child: const Text('Yes'),
                                    onPressed: () {
                                      Navigator.pop(context, true);
                                      removeCurrentGroup();
                                    },
                                  ),
                                  TextButton(
                                    child: const Text('No'),
                                    onPressed: () {
                                      Navigator.pop(context, false);
                                    },
                                  )
                                ],
                              );
                            },
                          );
                        }
                      },
                      label: const Text(""),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        fixedSize: const Size(100, 100),
                        padding: const EdgeInsets.only(left: 10.0),
                        backgroundColor: const Color.fromARGB(255, 0, 255, 242),
                      ),
                    ),
                    const SizedBox(width: 50),
                    //Add group button
                    ElevatedButton.icon(
                      icon: const Icon(
                        Icons.add_circle_outline,
                        size: 80,
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                      onPressed: () {
                        DatabaseHelper.updateMovieData(widget.groupData);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddGroupPage(
                              title: 'Add Group',
                            ),
                          ),
                        ).then((value) {
                          widget.groupData = [];
                          initGroupData();
                        });
                      },
                      label: const Text(""),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        fixedSize: const Size(100, 100),
                        padding: const EdgeInsets.only(left: 10.0),
                        backgroundColor: const Color.fromARGB(255, 0, 255, 242),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Back'),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.1),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfilePage(
                              title: 'Profile',
                            ),
                          ),
                        );
                      },
                      child: const Text('Profile'),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  //Removes the group that is currently focused on
  void removeCurrentGroup() {
    DatabaseHelper.removeGroup(widget.groupData[_currentIndex].id);
    initGroupData();
  }

  //Updates watched movies list
  void onMovieChanged(int groupIndex, int movieIndex, bool val) {
    setState(() {
      widget.groupData[groupIndex].data[movieIndex].isCompleted = val;
    });
    if (val) {
      DatabaseHelper.addWatchedMovie(
          widget.groupData[groupIndex].data[movieIndex].movieID.toString(),
          widget.groupData[groupIndex].data[movieIndex].movieName);
    } else {
      DatabaseHelper.removeWatchedMovie(
          widget.groupData[groupIndex].data[movieIndex].movieID.toString());
    }
    DatabaseHelper.updateMovieData(widget.groupData);
  }

  void onGroupCompleted(int groupIndex) {
    DatabaseHelper.addUserExperience(20);
    DatabaseHelper.removeGroup(widget.groupData[groupIndex].id);
    initGroupData();
  }

  //Gets all current group data from the database and creates the movieGroups list.
  Future<void> initGroupData() async {
    widget.groupData = await DatabaseHelper.getMovieGroups();
    setState(() {
      widget.movieGroups = List<MovieGroup>.generate(
        widget.groupData.length,
        (index) => MovieGroup(
          header: widget.groupData[index].header,
          index: index,
          onMovieChanged: onMovieChanged,
          onGroupCompleted: onGroupCompleted,
          movieData: widget.groupData[index].data,
        ),
      );
    });
    if (_currentIndex > widget.groupData.length - 1 &&
        widget.groupData.isNotEmpty) {
      _currentIndex = widget.groupData.length - 1;
    }
  }
}

//A movie group is a panel within the carrousel that shows five movies and a completion value.
class MovieGroup extends StatefulWidget {
  MovieGroup(
      {super.key,
      this.header = "",
      required this.index,
      required this.onMovieChanged,
      required this.onGroupCompleted,
      required this.movieData});
  final String header;
  final int index;
  final Function(int, int, bool) onMovieChanged;
  final Function(int) onGroupCompleted;
  final List<MovieData> movieData;
  int numMoviesCompleted = 0;
  double percentMoviesCompleted = 0.0;
  @override
  State<MovieGroup> createState() => _MovieGroupState();
}

class _MovieGroupState extends State<MovieGroup> {
  List<MovieCard> movies = [];
  @override
  Widget build(BuildContext context) {
    widget.numMoviesCompleted = 0;
    movies = List<MovieCard>.generate(widget.movieData.length, (index) {
      setState(() {
        if (widget.movieData[index].isCompleted) {
          widget.numMoviesCompleted++;
        }
        widget.percentMoviesCompleted =
            widget.numMoviesCompleted.toDouble() / 5.0;
      });
      return MovieCard(
        index: index,
        onMovieCompleted: onMovieChanged,
        movieId: widget.movieData[index].movieID,
        isCompleted: widget.movieData[index].isCompleted,
        movieName: widget.movieData[index].movieName,
      );
    });
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
        CompletionSlider(
            completionAmount: widget.percentMoviesCompleted,
            onGroupCompleted: onGroupCompleted),
      ],
    );
  }

  //When a movie is watched or unwatched, we update the current number watched in the group and update our watched movies list.
  void onMovieChanged(int index, bool val) {
    setState(() {
      if (val) {
        widget.numMoviesCompleted++;
      } else {
        widget.numMoviesCompleted--;
      }
      widget.percentMoviesCompleted =
          widget.numMoviesCompleted.toDouble() / 5.0;
    });
    widget.onMovieChanged(widget.index, index, val);
  }

  void onGroupCompleted() {
    widget.onGroupCompleted(widget.index);
  }
}

//Completion progress bar displays how close the user is to completing a group.
class CompletionSlider extends StatelessWidget {
  CompletionSlider(
      {super.key,
      required this.completionAmount,
      required this.onGroupCompleted});

  final double completionAmount;
  final Function onGroupCompleted;

  @override
  Widget build(context) {
    if (completionAmount < 1.0) {
      return (SizedBox(
        height: MediaQuery.of(context).size.height * 0.04,
        child: SliderTheme(
          data: SliderTheme.of(context).copyWith(
              thumbColor: Colors.transparent,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 0.0)),
          child: Slider(
            value: completionAmount,
            onChanged: (val) {},
          ),
        ),
      ));
    } else {
      return (SizedBox(
        height: MediaQuery.of(context).size.height * 0.04,
        child: ElevatedButton(
            onPressed: () {
              onGroupCompleted.call();
            },
            child: const Text("Complete Group")),
      ));
    }
  }
}

//Movie cards display the movie's name and if the movie has been watched.
class MovieCard extends StatefulWidget {
  MovieCard({
    super.key,
    this.movieId = -1,
    required this.movieName,
    required this.index,
    required this.onMovieCompleted,
    required this.isCompleted,
  });

  int movieId;
  String movieName;
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
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.07,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFF00D2FF),
        shape: BoxShape.rectangle,
        border: Border.all(
          width: 2,
        ),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 160,
              child: Text(widget.movieName),
            ),
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
