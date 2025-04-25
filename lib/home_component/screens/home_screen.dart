// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tevly_client/commons/logger/logger.dart';
import '../providers/movie_provider.dart';
import '../models/movie.dart';
import '../widgets/bottom_navigation.dart';
import '../widgets/featured_content.dart';
import '../widgets/movie_row.dart';
import 'movie_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentNavIndex = 0;

  @override
  void initState() {
    super.initState();
    // Only fetch if data is not already loaded
    final movieProvider = Provider.of<MovieProvider>(context, listen: false);
    if (movieProvider.allMovies.isEmpty) {
      Future.microtask(() {
        movieProvider.fetchMovies();
      });
    }
  }

  void _onNavTap(int index) {
    setState(() {
      _currentNavIndex = index;
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Consumer<MovieProvider>(
        builder: (context, movieProvider, child) {
          if (movieProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final featuredMovie = movieProvider.allMovies.isNotEmpty
              ? movieProvider.allMovies[0]
              : null;

          return CustomScrollView(
            slivers: [
              // App Bar
              SliverAppBar(
                backgroundColor: Colors.transparent,
                pinned: true,
                expandedHeight: 50.0,
                flexibleSpace: FlexibleSpaceBar(
                  title: Row(
                    children: [
                      const SizedBox(width: 16),
                      const Text(
                        'Tevely',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.cast, color: Colors.white),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  centerTitle: false,
                ),
              ),

              // Content
              SliverList(
                delegate: SliverChildListDelegate([
                  // Featured Content
                  if (featuredMovie != null)
                    FeaturedContent(
                      movie: featuredMovie,
                      onPlay: _onMovieTap,
                      onMyList: movieProvider.toggleMyList,
                      isInMyList: movieProvider.isInMyList(featuredMovie.id),
                    ),

                  const SizedBox(height: 20),

                  // My List Section
                  if (movieProvider.myList.isNotEmpty)
                    MovieRow(
                      title: 'My List',
                      movies: movieProvider.myList,
                      onMovieTap: _onMovieTap,
                    ),
                  if (movieProvider.allMovies.isNotEmpty)
                    MovieRow(
                      title: 'All Movies',
                      movies: movieProvider.allMovies,
                      onMovieTap: _onMovieTap,
                    ),

                  // Dynamic Categories
                  ...movieProvider.categories.map((category) {
                    final categoryMovies = movieProvider.getMoviesByCategory(category);
                    if (categoryMovies.isEmpty) return const SizedBox.shrink();

                    return MovieRow(
                      title: category,
                      movies: categoryMovies,
                      onMovieTap: _onMovieTap,
                    );
                  }).toList(),
                ]),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: TevelyBottomNavigation(
        currentIndex: _currentNavIndex,
        onTap: _onNavTap,
      ),
    );
  }
}