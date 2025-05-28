import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tevly_client/home_component/models/theme.dart';
import 'package:tevly_client/home_component/providers/Rating_provider.dart';
import 'package:tevly_client/home_component/providers/comment_provider.dart';
import '../providers/movie_provider.dart';
import '../models/movie.dart';
import '../widgets/bottom_navigation.dart';
import '../widgets/movie_row.dart';
import 'movie_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}
 
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
  void _onMovieTap(Movie movie) async {
  await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => MovieDetailsScreen(movie: movie),
    ),
  );
  // Fetch movies after returning
  final movieProvider = Provider.of<MovieProvider>(context, listen: false);
  if(CommentProvider.hasCommented==true||RatingProvider.hasRated==true){
    CommentProvider.hasCommented = false;
    RatingProvider.hasRated = false;
  movieProvider.fetchMovies(forceRefresh: true);
  }
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
            backgroundColor: AppTheme.surfaceColor,
            onRefresh: () => movieProvider.fetchMovies(),
            child: CustomScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverAppBar(
                  backgroundColor: AppTheme.primaryColor,
                  pinned: true,
                  expandedHeight: 50.0,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text('Tvely', style: AppTheme.headerStyle),
                    centerTitle: false,
                  ),
                ),

                SliverList(
                  delegate: SliverChildListDelegate([
                    Padding(
                      padding:const EdgeInsets.all(AppTheme.defaultPadding),
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

                const SizedBox(height: AppTheme.defaultSpacing),

                    if (movieProvider.myList.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppTheme.defaultPadding,
                        ),
                        child: RepaintBoundary(
                          child: MovieRow(
                            title: 'My List',
                            movies: movieProvider.myList,
                            onMovieTap: _onMovieTap,
                          ),
                        ),
                      ),

                    Padding(
                      padding:const EdgeInsets.symmetric(
                        horizontal: AppTheme.defaultPadding,
                      ),
                      child: RepaintBoundary(
                        child: MovieRow(
                          title: 'All Movies',
                          movies: movieProvider.allMovies,
                          onMovieTap: _onMovieTap,
                        ),
                      ),
                    ),

                    ...movieProvider.categories.map((category) {
                      final categoryMovies =
                          movieProvider.getMoviesByCategory(category);
                      if (categoryMovies.isEmpty) {
                        return const SizedBox.shrink();
                      }

                      return Padding(
                        padding:const EdgeInsets.symmetric(
                          horizontal: AppTheme.defaultPadding,
                        ),
                        child: RepaintBoundary(
                          child: MovieRow(
                            title: category,
                            movies: categoryMovies,
                            onMovieTap: _onMovieTap,
                          ),
                        ),
                      );
                    }).toList(),

                 const  SizedBox(height: AppTheme.defaultSpacing),
                  ]),
                ),
              ],
            ),
          );
        },
      ),
    ),
    bottomNavigationBar: Theme(
      data: Theme.of(context).copyWith(
        canvasColor: AppTheme.surfaceColor,
      ),
      child: TevelyBottomNavigation(
        currentIndex: _currentNavIndex,
        onTap: _onNavTap,
      ),
    ),
  );
}
}
