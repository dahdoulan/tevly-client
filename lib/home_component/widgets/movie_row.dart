// lib/widgets/movie_row.dart
import 'package:flutter/material.dart';
import '../models/movie.dart';
import 'movie_card.dart';

class MovieRow extends StatelessWidget {
  final String title;
  final List<Movie> movies;
  final Function(Movie) onMovieTap;

  const MovieRow({
    Key? key,
    required this.title,
    required this.movies,
    required this.onMovieTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 12),
            itemCount: movies.length,
            itemBuilder: (context, index) {
              return MovieCard(
                movie: movies[index],
                onTap: () => onMovieTap(movies[index]),
              );
            },
          ),
        ),
      ],
    );
  }
}