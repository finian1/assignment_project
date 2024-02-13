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
                    searchMovies(searchController.text);
                  },
                ),
              ],
            ),
          ),
          //Found items from search
          SizedBox(
            width: double.infinity,
            height: 500,
            child: ListView.builder(
              itemCount: widget.loadedMovieCards.length,
              itemBuilder: (context, index) {
                return widget.loadedMovieCards[index];
              },
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: 100,
            child: Container(
              decoration:
                  BoxDecoration(color: Color.fromARGB(255, 186, 241, 255)),
              child: ListView.builder(
                itemCount: widget.selectedMovies.length,
                itemBuilder: (context, index) {
                  return Text(widget.selectedMovies[index].name);
                },
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
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Back")),
                  const SizedBox(
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

  void movieSelected(int pairIndex) {
    if (widget.selectedMovies.length < 5) {
      setState(() {
        widget.selectedMovies.add(widget.loadedMoviePairs[pairIndex]);
      });
    }
  }

  Future<void> searchMovies(String searchTerm) async {
    List<dynamic> movies = await DatabaseHelper.searchForMovies(searchTerm);
    setState(() {
      widget.loadedMovieCards.clear();
      widget.loadedMoviePairs.clear();
      for (int i = 0; i < movies.length; i++) {
        widget.loadedMoviePairs.add(MoviePair(
            movies[i]['original_title'].toString(),
            movies[i]['id'].toString()));
        widget.loadedMovieCards.add(MovieCard(
            movies[i]['original_title'].toString(), i, movieSelected));
      }
    });
  }
}

class MovieCard extends StatelessWidget {
  MovieCard(this.movieName, this.pairIndex, this.movieSelected);
  String movieName = "";
  int pairIndex = -1;
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
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ElevatedButton(
        child: Text("movieName"),
        onPressed: () {},
      ),
    );
  }
}
