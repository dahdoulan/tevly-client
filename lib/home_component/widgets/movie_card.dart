// lib/widgets/movie_card.dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/movie.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;
  final Function()? onTap;

  const MovieCard({super.key, required this.movie, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        margin: EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: CachedNetworkImage(
                imageUrl: movie.thumbnailUrl, // movie.thumbnailUrl
                height: 180,
                width: 120,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  height: 180,
                  width: 120,
                  color: Colors.grey[900],
                ),
                errorWidget: (context, url, error) => Container(
                  height: 180,
                  width: 120,
                  color: Colors.grey[900],
                  child: Icon(Icons.error),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
