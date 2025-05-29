import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tevly_client/home_component/models/movie.dart';
import 'package:tevly_client/home_component/models/theme.dart';
import 'package:tevly_client/home_component/providers/search_provider.dart';
import 'package:tevly_client/home_component/screens/movie_details_screen.dart';
import 'package:tevly_client/home_component/widgets/movie_card.dart';

class MovieSearchPage extends StatefulWidget {
  const MovieSearchPage({Key? key}) : super(key: key);

  @override
  State<MovieSearchPage> createState() => _MovieSearchPageState();
}

class _MovieSearchPageState extends State<MovieSearchPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SearchProvider>().fetchMovies();
    });
  }

  void _onSearchChanged() {
    context.read<SearchProvider>().onSearchChanged(_searchController.text);
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text("Search Movies", style: AppTheme.headerStyle),
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(AppTheme.defaultPadding),
            child: TextField(
              controller: _searchController,
              style: AppTheme.bodyStyle,
              decoration: InputDecoration(
                hintText: 'Search for a movie by Title, Category or Director...',
                hintStyle: AppTheme.captionStyle,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: AppTheme.surfaceColor,
              ),
            ),
          ),
          Consumer<SearchProvider>(
            builder: (context, provider, child) {
              if (provider.isLoading) {
                return Center(child: AppTheme.loadingIndicator);
              }
              
              return Expanded(
                child: provider.filteredMovies.isEmpty
                    ? Center(
                        child: Text('No Movies, Categories or Filmmakers found.', style: AppTheme.bodyStyle))
                    : GridView.builder(
                        shrinkWrap: true,
                        physics: const AlwaysScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 200,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                          childAspectRatio: 0.7,
                        ),
                        itemCount: provider.filteredMovies.length,
                        itemBuilder: (context, index) {
                          final movie = provider.filteredMovies[index];
                          return MovieCard(
                            movie: movie,
                            onTap: () => _onMovieTap(movie),
                          );
                        },
                      ),
              );
            },
          ),
        ],
      ),
    );
  }
}