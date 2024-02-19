import 'dart:collection';

import 'package:assignment_project/database.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'dart:async';

class MoviePair {
  MoviePair(this.name, this.id);
  String name = "";
  String id = "";
}

class AddGroupPage extends StatefulWidget {
  AddGroupPage({super.key, required this.title});
  final String title;
  final loadedMoviePairs = <MoviePair>[];
  final loadedMovieCards = <MovieCard>[];
  final selectedMovies = <MoviePair>[];
  bool validGroupSelected = false;
  @override
  State<AddGroupPage> createState() => _AddGroupPageState();
}

class _AddGroupPageState extends State<AddGroupPage> {
  _AddGroupPageState();

  TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          const SizedBox(
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
                const SizedBox(
                  width: 20,
                  height: 90,
                ),
                SizedBox(
                  width: 300,
                  height: 90,
                  child: TextFormField(
                    controller: searchController,
                    textInputAction: TextInputAction.search,
                    onFieldSubmitted: (value) {
                      searchMovies(searchController.text);
                    },
                    decoration: const InputDecoration(
                      labelText: 'Search...',
                    ),
                  ),
                ),
                //Search button
                ElevatedButton.icon(
                  icon: const Icon(Icons.search),
                  label: const Text(""),
                  onPressed: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    searchMovies(searchController.text);
                  },
                ),
              ],
            ),
          ),
          //Found items from search
          SizedBox(
            width: double.infinity,
            height: 400,
            child: ListView.builder(
              itemCount: widget.loadedMovieCards.length,
              itemBuilder: (context, index) {
                return widget.loadedMovieCards[index];
              },
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            width: double.infinity,
            height: 200,
            child: Container(
              decoration:
                  BoxDecoration(color: Color.fromARGB(255, 186, 241, 255)),
              child: ListView.builder(
                itemCount: widget.selectedMovies.length,
                itemBuilder: (context, index) {
                  return SizedBox(
                    height: 200 / 5,
                    child: SelectedMovieCard(
                        widget.selectedMovies[index], removeSelectedMovie),
                  );
                },
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Back")),
                  const SizedBox(
                    width: 50,
                    height: 100,
                  ),
                  ElevatedButton(
                    onPressed: widget.validGroupSelected
                        ? () {
                            addGroup();
                          }
                        : null,
                    child: Text("Create Group"),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void movieSelected(int pairIndex) {
    if (widget.selectedMovies.length < 5) {
      bool alreadyAdded = false;
      for (MoviePair pair in widget.selectedMovies) {
        if (widget.loadedMoviePairs[pairIndex].id == pair.id) {
          alreadyAdded = true;
        }
      }
      if (!alreadyAdded) {
        setState(() {
          widget.selectedMovies.add(widget.loadedMoviePairs[pairIndex]);
          if (widget.selectedMovies.length == 5) {
            widget.validGroupSelected = true;
          } else {
            widget.validGroupSelected = false;
          }
        });
      }
    }
  }

  void removeSelectedMovie(String id) {
    for (int i = 0; i < widget.selectedMovies.length; i++) {
      if (widget.selectedMovies[i].id == id) {
        setState(() {
          widget.selectedMovies.removeAt(i);
          if (widget.selectedMovies.length == 5) {
            widget.validGroupSelected = true;
          } else {
            widget.validGroupSelected = false;
          }
        });
        break;
      }
    }
  }

  Future<void> addGroup() async {
    for (MoviePair pair in widget.selectedMovies) {
      await DatabaseHelper.addNewMovie(pair.id, false, pair.name);
    }
    await DatabaseHelper.addNewGroup("header", [
      widget.selectedMovies[0].id,
      widget.selectedMovies[1].id,
      widget.selectedMovies[2].id,
      widget.selectedMovies[3].id,
      widget.selectedMovies[4].id,
    ]);
    returnToMenu();
  }

  void returnToMenu() {
    Navigator.pop(context);
  }

  Future<void> searchMovies(String searchTerm) async {
    List<dynamic> movies = await DatabaseHelper.searchForMovies(searchTerm);
    setState(() {
      widget.loadedMovieCards.clear();
      widget.loadedMoviePairs.clear();
      for (int i = 0; i < movies.length; i++) {
        widget.loadedMoviePairs.add(MoviePair(
            movies[i]['title'].toString(), movies[i]['id'].toString()));
        widget.loadedMovieCards
            .add(MovieCard(movies[i]['title'].toString(), i, movieSelected));
      }
    });
  }
}

class MovieCard extends StatelessWidget {
  const MovieCard(this.movieName, this.pairIndex, this.movieSelected);
  final String movieName;
  final int pairIndex;
  final Function(int) movieSelected;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ElevatedButton(
        child: Text(movieName),
        onPressed: () {
          movieSelected(pairIndex);
        },
      ),
    );
  }
}

class SelectedMovieCard extends StatelessWidget {
  SelectedMovieCard(this.pair, this.movieRemoved);
  final MoviePair pair;
  final Function(String) movieRemoved;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromARGB(255, 132, 255, 132)),
        child: Text(pair.name),
        onPressed: () {
          movieRemoved(pair.id);
        },
      ),
    );
  }
}
