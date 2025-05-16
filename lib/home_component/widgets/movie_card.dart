import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tevly_client/home_component/providers/movie_thumbnail_provider.dart';
import '../models/movie.dart';
class MovieCard extends StatelessWidget {
  final Movie movie;
  final Function()? onTap;

  const MovieCard({Key? key, required this.movie, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      key: ValueKey(movie.id),  // <-- Add this key here
      create: (_) => MovieThumbnailProvider()..loadThumbnail(movie.id),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 120,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.25,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Consumer<MovieThumbnailProvider>(
                    builder: (context, provider, child) {
                      if (provider.isLoading) {
                        return _placeholderWidget();
                      } else if (provider.base64Image != null) {
                        return Image.memory(
                          base64Decode(provider.base64Image!.split(',').last),
                          height: 160,
                          width: 120,
                          fit: BoxFit.cover,
                        );
                      } else {
                        return _errorWidget();
                      }
                    },
                  ),
                ),
                const SizedBox(height: 4),
                Flexible(
                  child: Text(
                    movie.title,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
 


  Widget _placeholderWidget() {
    return Container(
      height: 160,
      width: 120,
      color: Colors.grey[900],
      child: const Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _errorWidget() {
    return Container(
      height: 160,
      width: 120,
      color: Colors.grey[900],
      child: const Icon(Icons.error, color: Colors.white),
    );
  }
}