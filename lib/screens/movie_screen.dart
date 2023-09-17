import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class Movie {
  final int id;
  final String title;
  final String overview;
  final String trailerKey;
  Movie({
    required this.id,
    required this.title,
    required this.overview,
    required this.trailerKey,
  });
}

void main() {
  runApp(MaterialApp(
    home: MovieScreen(),
  ));
}

class MovieScreen extends StatefulWidget {
  const MovieScreen({Key? key}) : super(key: key);

  @override
  _MovieScreenState createState() => _MovieScreenState();
}

class _MovieScreenState extends State<MovieScreen> {
  TextEditingController searchController = TextEditingController();
  List<Movie> movies = [];
  Future<void> fetchMovies(String text) async {
    final apiKey = 'a608dd06f460b5f250f532b3ec9beba0';
    final baseUrl = 'https://api.themoviedb.org/3/movie/upcoming';
    final url = Uri.parse('$baseUrl?api_key=$apiKey');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final movieResults = jsonData['results'] as List<dynamic>;
        final fetchedMovies = movieResults
            .map((movieData) => Movie(
                  id: movieData['id'],
                  title: movieData['title'],
                  overview: movieData['overview'],
                  trailerKey: 'a608dd06f460b5f250f532b3ec9beba0',
                ))
            .toList();
        setState(() {
          movies = fetchedMovies;
        });
      } else {
        throw Exception('Failed to load movies');
      }
    } catch (e) {
      print('Error fetching movies: $e');
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Movie Screen',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          Hero(
            tag: 'searchBar',
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  labelText: 'Search for a movie',
                  suffixIcon: IconButton(
                    onPressed: () {
                      fetchMovies(searchController.text);
                    },
                    icon: Icon(Icons.search),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: movies.length,
              itemBuilder: (context, index) {
                final movie = movies[index];
                return Card(
                  elevation: 5,
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(
                      color: Colors.blue[400]!,
                      width: 2.0,
                    ),
                  ),
                  child: ListTile(
                    title: Text(
                      'Title: ${movie.title}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 8, 8, 8),
                      ),
                    ),
                    subtitle: Text(
                      'Overview: ${movie.overview}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color.fromARGB(255, 9, 9, 9),
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => MovieDetailScreen(movie: movie),
                        ),
                      );
                    },
                    trailing: Icon(
                      Icons.arrow_forward,
                      color: Color.fromARGB(255, 2, 2, 2),
                    ), // Blue icon color
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class MovieDetailScreen extends StatelessWidget {
  final Movie movie;
  MovieDetailScreen({required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Movie Detail',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Card(
        margin: EdgeInsets.all(16),
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: Color.fromARGB(255, 4, 32, 247)!,
            width: 2.0,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Title: ${movie.title}',
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(height: 16),
              Text(
                'Overview: ${movie.overview}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => TrailerPlayerScreen(
                        trailerKey: movie.trailerKey,
                      ),
                    ),
                  );
                },
                child: Text('Watch Trailer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TrailerPlayerScreen extends StatefulWidget {
  final String trailerKey;
  TrailerPlayerScreen({required this.trailerKey});

  @override
  _TrailerPlayerScreenState createState() => _TrailerPlayerScreenState();
}

class _TrailerPlayerScreenState extends State<TrailerPlayerScreen> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.trailerKey,
      flags: YoutubePlayerFlags(
        autoPlay: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Movie Detail',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Center(
        child: YoutubePlayer(
          controller: _controller,
          showVideoProgressIndicator: true,
          onReady: () {},
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _controller.pause();
          Navigator.of(context).pop();
        },
        child: Icon(Icons.done),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
