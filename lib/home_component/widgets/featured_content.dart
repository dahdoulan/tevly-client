// lib/widgets/featured_content.dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/movie.dart';

class FeaturedContent extends StatelessWidget {
  final Movie movie;
  final Function(Movie) onPlay;
  final Function(Movie) onMyList;
  final bool isInMyList;

  const FeaturedContent({
    super.key,
    required this.movie,
    required this.onPlay,
    required this.onMyList,
    required this.isInMyList,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 500,
          width: double.infinity,
          child: CachedNetworkImage(
            imageUrl: movie.thumbnailUrl, //movie.thumbnailUrl
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(color: Colors.black),
            errorWidget: (context, url, error) => Container(
              color: Colors.black,
              child: Icon(Icons.error, color: Colors.white),
            ),
          ),
        ),
        Container(
          height: 500,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.2),
                Colors.black.withOpacity(0.5),
                Colors.black,
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 40,
          left: 0,
          right: 0,
          child: Column(
            children: [
              Text(
                movie.title,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => onPlay(movie),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                    ),
                    icon: Icon(Icons.play_arrow),
                    label: Text('Play'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
