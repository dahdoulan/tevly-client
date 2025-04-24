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
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentNavIndex = 0;

  @override
  void initState() {
    super.initState();
    // Fetch movies when screen loads
    Future.microtask(() {
      Provider.of<MovieProvider>(context, listen: false).fetchMovies();
    });
  }

  void _onNavTap(int index) {
    setState(() {
      _currentNavIndex = index;
    });
  }

  void _onMovieTap(Movie movie) {
    // Navigate to movie details page
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
            return Center(child: CircularProgressIndicator());
          }

          // If there are movies, use the first one as featured
          final featuredMovie = movieProvider.allMovies.isNotEmpty
              ? movieProvider.allMovies[0]
              : null;

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: Colors.transparent,
                pinned: true,
                expandedHeight: 50.0,
                flexibleSpace: FlexibleSpaceBar(
                  title: Row(
                    children: [
                      SizedBox(width: 16),
                      Text(
                        'Tevely',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Spacer(),
                      IconButton(
                        icon: Icon(Icons.cast, color: Colors.white),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  centerTitle: false,
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate([
                  // Featured content
                  if (featuredMovie != null)
                    FeaturedContent(
                      movie: featuredMovie,
                      onPlay: (movie) {
                        Logger.debug('Play: ${movie.title}');
                        // Implement video playback functionality
                      },
                      onMyList: (movie) {
                        movieProvider.toggleMyList(movie);
                      },
                      isInMyList: movieProvider.isInMyList(featuredMovie.id),
                    ),

                  SizedBox(height: 20),

                  // My List (if not empty)
                  if (movieProvider.myList.isNotEmpty)
                    MovieRow(
                      title: 'My List',
                      movies: movieProvider.myList,
                      onMovieTap: _onMovieTap,
                    ),

                  // All Movies
                  if (movieProvider.allMovies.isNotEmpty)
                    MovieRow(
                      title: 'All Movies',
                      movies: movieProvider.allMovies,
                      onMovieTap: _onMovieTap,
                    ),

                  // Action Movies
                  if (movieProvider.actionMovies.isNotEmpty)
                    MovieRow(
                      title: 'Action Movies',
                      movies: movieProvider.actionMovies,
                      onMovieTap: _onMovieTap,
                    ),
                  if (movieProvider.horrorMovies.isNotEmpty)
                    MovieRow(
                      title: 'Horror Movies',
                      movies: movieProvider.horrorMovies,
                      onMovieTap: _onMovieTap,
                    ),
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
