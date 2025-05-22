import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tevly_client/home_component/models/theme.dart';
import 'package:tevly_client/home_component/widgets/check_authentication.dart';
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
  CheckAuthentication checkAuth = const CheckAuthentication(child: Text("Welcome Home"),);

class _HomeScreenState extends State<HomeScreen> {
  int _currentNavIndex = 0;
  final ScrollController _scrollController = ScrollController();

   @override
  void initState() {
    super.initState();
    _initializeData();
  }
 Future<void> _initializeData() async {
    final movieProvider = Provider.of<MovieProvider>(context, listen: false);
    if (movieProvider.allMovies.isEmpty) {
      await movieProvider.fetchMovies();
    }
  }
  void _onNavTap(int index) {
    switch (index) {
      case 1:
        Navigator.pushNamed(context, '/search');
        break;
      case 2:
        Navigator.pushNamed(context, '/settings');
        break;
      default:
        setState(() => _currentNavIndex = index);
    }
  }
 @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Consumer<MovieProvider>(
          builder: (context, movieProvider, child) {
            if (movieProvider.isLoading) {
              return Center(child: AppTheme.loadingIndicator);
            }

            return RefreshIndicator(
              color: AppTheme.primaryColor,
              onRefresh: () => movieProvider.fetchMovies(),
              child: CustomScrollView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverAppBar(
                    backgroundColor: Colors.transparent,
                    pinned: true,
                    expandedHeight: 50.0,
                    flexibleSpace: FlexibleSpaceBar(
                      title: Text('Tvely', style: AppTheme.headerStyle),
                      centerTitle: false,
                    ),
                  ),

                  // Content
                    SliverList(
                    delegate: SliverChildListDelegate([
                      // Static featured image instead of first movie
                      Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                        'lib/assets/banner.jpg', // Replace with your image path
                        fit: BoxFit.cover,
                        height: MediaQuery.of(context).size.height *0.5333333333333333,
                        width:  MediaQuery.of(context).size.width * 0.23,
                        ),
                      ),
                      ),

                      const SizedBox(height: 20),

                      // Cached sections using RepaintBoundary
                      if (movieProvider.myList.isNotEmpty)
                        RepaintBoundary(
                          child: MovieRow(
                            title: 'My List',
                            movies: movieProvider.myList,
                            onMovieTap: _onMovieTap,
                          ),
                        ),

                      RepaintBoundary(
                        child: MovieRow(
                          title: 'All Movies',
                          movies: movieProvider.allMovies,
                          onMovieTap: _onMovieTap,
                        ),
                      ),

                      // Optimized category rendering
                      ...movieProvider.categories.map((category) {
                        final categoryMovies =
                            movieProvider.getMoviesByCategory(category);
                        if (categoryMovies.isEmpty) {
                          return const SizedBox.shrink();
                        }

                        return RepaintBoundary(
                          child: MovieRow(
                            title: category,
                            movies: categoryMovies,
                            onMovieTap: _onMovieTap,
                          ),
                        );
                      }).toList(),

                      // Bottom padding for better scrolling experience
                      const SizedBox(height: 20),
                    ]),
                  ),
                ],
              ),
            );
          },
        ),
      ),
        bottomNavigationBar: TevelyBottomNavigation(
        currentIndex: _currentNavIndex,
        onTap: _onNavTap,
      ),
    );
  }

  
}
 
