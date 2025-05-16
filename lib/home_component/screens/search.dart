import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tevly_client/auth_components/api/ApiConstants.dart';
import 'package:tevly_client/auth_components/service/authenticationService.dart';
import 'package:tevly_client/commons/logger/logger.dart';
import 'package:tevly_client/home_component/models/movie.dart';
import 'package:tevly_client/home_component/screens/movie_details_screen.dart';
import 'package:tevly_client/home_component/widgets/movie_card.dart';

class MovieSearchPage extends StatefulWidget {
  const MovieSearchPage({Key? key}) : super(key: key);

  @override
  State<MovieSearchPage> createState() => _MovieSearchPageState();
}

class _MovieSearchPageState extends State<MovieSearchPage> {
  List<Movie> _allMovies = [];
  List<Movie> _filteredMovies = [];
  bool _isLoading = false;
  Timer? _debounce;

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchAllMovies(); 
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _filterMovies(_searchController.text);
    });
  }

  Future<void> _fetchAllMovies() async {
  setState(() => _isLoading = true);
  try {
    final token = await AuthenticationService().getToken();
    final response = await http.post(
      Uri.parse(ApiConstants.metadata),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    Logger.debug("Status Code: ${response.statusCode}");
    Logger.debug("Response Body: ${response.body}");

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      _allMovies = data.map((json) => Movie.fromJson(json)).toList();
      _filterMovies(_searchController.text);
    } else {
      throw Exception("Failed to fetch movies: ${response.statusCode}");
    }
  } catch (e) {
    Logger.debug("Error fetching movies: $e");
  } finally {
    setState(() => _isLoading = false);
  }
}


  void _filterMovies(String query) {
  setState(() {
    _filteredMovies = _allMovies.where((movie) {
      final titleLower = movie.title.toLowerCase();
      final searchLower = query.toLowerCase();
      return titleLower.contains(searchLower);
    }).toList();
  });
}
  void _onMovieTap(Movie movie) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MovieDetailsScreen(movie: movie),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: const Text("Search Movies")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search for a movie...',
                hintStyle: const TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[900],
              ),
            ),
          ),
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else
            Expanded(
  child: _filteredMovies.isEmpty
      ? Center(child: Text('No movies found.'))
      :GridView.builder(
  shrinkWrap: true,
  physics: const AlwaysScrollableScrollPhysics(), // Disable scrolling
  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
    maxCrossAxisExtent: 200, // Each item max width
    mainAxisSpacing: 8,
    crossAxisSpacing: 8,
    childAspectRatio: 0.7, // Adjust based on your MovieCard dimensions
  ),
  itemCount: _filteredMovies.length,
  itemBuilder: (context, index) {
    final movie = _filteredMovies[index];
    return MovieCard(
      movie: movie,
      onTap: () => _onMovieTap(movie),
    );
  },
)
,
)
,
        ],
      ),
    );
  }
}
