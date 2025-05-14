// lib/widgets/featured_content.dart
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:tevly_client/commons/logger/logger.dart';
import 'package:tevly_client/home_component/providers/movie_provider.dart';
import 'package:tevly_client/home_component/widgets/image_loader.dart';
import '../models/movie.dart';

class FeaturedContent extends StatefulWidget {
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
  State<FeaturedContent> createState() => _FeaturedContentState();
}

class _FeaturedContentState extends State<FeaturedContent> {
  String? _imageUrl;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

 Future<void> _loadImage() async {
  final movieProvider = Provider.of<MovieProvider>(context, listen: false);
  final cachedUrl = movieProvider.getThumbnailUrl(widget.movie.id);

  if (cachedUrl != null) {
    setState(() {
      _imageUrl = cachedUrl;
      _isLoading = false;
    });
    return;
  }

  try {
    final imageUrl = await ImageLoaderService.loadImage(widget.movie.id);
    final finalUrl = imageUrl ?? widget.movie.thumbnailUrl;

    movieProvider.cacheThumbnailUrl(widget.movie.id, finalUrl);

    setState(() {
      _imageUrl = finalUrl;
      _isLoading = false;
    });
  } catch (e) {
    Logger.debug('Error in FeaturedContent: $e');
    setState(() {
      _imageUrl = widget.movie.thumbnailUrl;
      _isLoading = false;
    });
  }
}



  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
  height: 500,
  width: double.infinity,
  child: _isLoading
      ? Container(
          color: Colors.black,
          child: const Center(child: CircularProgressIndicator()),
        )
      : _imageUrl != null && _imageUrl!.startsWith('data:image')
          ? Image.memory(
              base64Decode(_imageUrl!.split(',').last),
              height: 500,
              width: double.infinity,
              fit: BoxFit.cover,
            )
          : CachedNetworkImage(
              imageUrl: _imageUrl!,
              height: 500,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: Colors.black,
                child: const Center(child: CircularProgressIndicator()),
              ),
              errorWidget: (context, url, error) {
                Logger.debug('Image load error: $error');
                return Container(
                  color: Colors.black,
                  child: const Icon(Icons.error, color: Colors.white),
                );
              },
            ),
),

        Positioned(
          bottom: 40,
          left: 0,
          right: 0,
          child: Column(
            children: [
              Text(
                widget.movie.title,
                style: const TextStyle(
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
                    onPressed: () => widget.onPlay(widget.movie),
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
