// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tevly_client/commons/logger/logger.dart';
import 'package:tevly_client/home_component/models/series.dart';
import 'package:tevly_client/home_component/providers/series_provider.dart';
import 'package:tevly_client/home_component/screens/series_details_screen.dart';
import 'package:tevly_client/home_component/widgets/series_row.dart';
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
    // Fetch both movies and series
    final movieProvider = Provider.of<MovieProvider>(context, listen: false);
    final seriesProvider = Provider.of<SeriesProvider>(context, listen: false);
    
    if (movieProvider.allMovies.isEmpty) {
      Future.microtask(() => movieProvider.fetchMovies());
    }
    if (seriesProvider.allSeries.isEmpty) {
      Future.microtask(() => seriesProvider.fetchSeries());
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
  void _onSeriesTap(Series series) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SeriesDetailsScreen(series: series),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Consumer2<MovieProvider, SeriesProvider>(
        builder: (context, movieProvider, seriesProvider, child) {
          if (movieProvider.isLoading || seriesProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final featuredMovie = movieProvider.allMovies.isNotEmpty
              ? movieProvider.allMovies[0]
              : null;

          return CustomScrollView(
            slivers: [
              // App Bar
             const SliverAppBar(
                backgroundColor: Colors.transparent,
                pinned: true,
                expandedHeight: 50.0,
                flexibleSpace: FlexibleSpaceBar(
                  title: Row(
                    children: [
                      const SizedBox(width: 16),
                      const Text(
                        'Tvely',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      
                      
                    ],
                  ),
                  centerTitle: false,
                  
                ),
              ),

              // Content
              SliverList(
                delegate: SliverChildListDelegate([
                  // Featured Content (Movies)
                  if (movieProvider.allMovies.isNotEmpty)
                    FeaturedContent(
                      movie: movieProvider.allMovies[0],
                      onPlay: _onMovieTap,
                      onMyList: movieProvider.toggleMyList,
                      isInMyList: movieProvider.isInMyList(movieProvider.allMovies[0].id),
                    ),

                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Movies',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
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
                  const SizedBox(height: 40),

                  // TV Series Section Header
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'TV Series',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  // Series My List Section
                  if (seriesProvider.myList.isNotEmpty)
                    SeriesRow(
                      title: 'My List',
                      series: seriesProvider.myList,
                      onSeriesTap: _onSeriesTap,
                    ),

                  // Series Categories
                  ...seriesProvider.categories.map((category) {
                    final categorySeries = seriesProvider.getSeriesByCategory(category);
                    if (categorySeries.isEmpty) return const SizedBox.shrink();
                    return SeriesRow(
                      title: category,
                      series: categorySeries,
                      onSeriesTap: _onSeriesTap,
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