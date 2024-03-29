import 'package:assignment_project/database.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

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
  @override
  State<AddGroupPage> createState() => _AddGroupPageState();
}

class _AddGroupPageState extends State<AddGroupPage> {
  _AddGroupPageState();
  bool validGroupSelected = false;

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
          //Title text box
          SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.05,
            child: const Text(
              "Add Group",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 30),
            ),
          ),
          //Search bar
          SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.05,
            child: Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.01,
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.05,
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
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                  width: MediaQuery.of(context).size.width * 0.19,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.search),
                    label: const Text(""),
                    onPressed: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                      searchMovies(searchController.text);
                    },
                  ),
                ),
              ],
            ),
          ),
          //Found items from search
          SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.4,
            child: ListView.builder(
              itemCount: widget.loadedMovieCards.length,
              itemBuilder: (context, index) {
                return widget.loadedMovieCards[index];
              },
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),
          SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.3,
            child: Container(
              decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 186, 241, 255)),
              child: ListView.builder(
                itemCount: widget.selectedMovies.length,
                itemBuilder: (context, index) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.06,
                    child: SelectedMovieCard(
                        widget.selectedMovies[index], removeSelectedMovie),
                  );
                },
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.08,
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
                  onPressed: validGroupSelected
                      ? () {
                          addGroup();
                        }
                      : null,
                  child: const Text("Create Group"),
                ),
              ],
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
            validGroupSelected = true;
          } else {
            validGroupSelected = false;
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
            validGroupSelected = true;
          } else {
            validGroupSelected = false;
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
    await DatabaseHelper.addNewGroup("", [
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
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      showNetworkError();
      return;
    }

    List<dynamic> movies = await DatabaseHelper.searchForMovies(searchTerm);
    setState(() {
      widget.loadedMovieCards.clear();
      widget.loadedMoviePairs.clear();
      for (int i = 0; i < movies.length; i++) {
        widget.loadedMoviePairs.add(MoviePair(
            movies[i]['title'].toString(), movies[i]['id'].toString()));
        widget.loadedMovieCards.add(MovieCard(
            movieName:
                "${movies[i]['title'].toString()} - ${movies[i]['release_date'].toString()}",
            pairIndex: i,
            movieSelected: movieSelected));
      }
    });
  }

  void showNetworkError() {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Error"),
          content: const Text("No internet connection."),
          actions: [
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }
}

class MovieCard extends StatelessWidget {
  const MovieCard(
      {super.key,
      required this.movieName,
      required this.pairIndex,
      required this.movieSelected});
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
            backgroundColor: const Color.fromARGB(255, 132, 255, 132)),
        child: Text(pair.name),
        onPressed: () {
          movieRemoved(pair.id);
        },
      ),
    );
  }
}
