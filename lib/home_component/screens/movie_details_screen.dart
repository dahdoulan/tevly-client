// lib/screens/movie_details_screen.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tevly_client/commons/logger/logger.dart';
import 'package:tevly_client/home_component/widgets/image_loader.dart';
import '../models/movie.dart';
import '../providers/movie_provider.dart';
import '../widgets/comments_section.dart';

class MovieDetailsScreen extends StatefulWidget {
  final Movie movie;

  const MovieDetailsScreen({Key? key, required this.movie}) : super(key: key);

  @override
  State<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  String? _imageUrl;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }
bool isArabicText(String text) {
  // Unicode range for Arabic characters
  final arabicRegex = RegExp(r'[\u0600-\u06FF]');
  return arabicRegex.hasMatch(text);
}
  Future<void> _loadImage() async {
    final movieProvider = Provider.of<MovieProvider>(context, listen: false);
    
    // Check cache first
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
      if (imageUrl != null) {
        movieProvider.cacheThumbnailUrl(widget.movie.id, imageUrl);
      }
      setState(() {
        _imageUrl = imageUrl ?? widget.movie.thumbnailUrl;
        _isLoading = false;
      });
    } catch (e) {
      Logger.debug('Error in MovieDetailsScreen: $e');
      setState(() {
        _imageUrl = widget.movie.thumbnailUrl;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final movieProvider = Provider.of<MovieProvider>(context);
    final isInMyList = movieProvider.isInMyList(widget.movie.id);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                _isLoading
    ? Container(
        height: 300,
        width: double.infinity,
        color: Colors.black,
        child: const Center(child: CircularProgressIndicator()),
      )
    : _imageUrl != null && _imageUrl!.startsWith('data:image')
        ? Image.memory(
            base64Decode(_imageUrl!.split(',').last),
            height: 300,
            width: double.infinity,
            fit: BoxFit.cover,
          )
        : Image.network(
            _imageUrl ?? '',
            height: 300,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              Logger.debug('Image load error: $error');
              return Container(
                height: 300,
                width: double.infinity,
                color: Colors.black,
                child: const Icon(Icons.error, color: Colors.white),
              );
            },
          ),

               Positioned(
  bottom: 20,
  left: 0,
  right: 0,
  child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0),
    child: Text(
      widget.movie.title,
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        height: 1.5, // Better height for both languages
      ),
      textAlign: isArabicText(widget.movie.title)
          ? TextAlign.right
          : TextAlign.left,
      textDirection: isArabicText(widget.movie.title)
          ? TextDirection.rtl
          : TextDirection.ltr,
    ),
  ),
),
              ],
            ),

            // Action buttons
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                 ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(
                        context, 
                        '/video-player',
                        arguments: {
                          'resolutionUrls': {
                            'Full HD': widget.movie.videoUrl,
                            'HD': widget.movie.videoUrl, // todo: add HD url to backend
                          },
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      minimumSize: Size(150, 48),
                    ),
                    icon: Icon(Icons.play_arrow),
                    label: Text('Play'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      movieProvider.toggleMyList(widget.movie);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.withOpacity(0.3),
                      foregroundColor: Colors.white,
                    ),
                    icon: Icon(isInMyList ? Icons.check : Icons.add),
                    label: Text(isInMyList ? 'Remove' : 'My List'),
                  ),
                ],
              ),
            ),

            // Movie info
            Padding(
  padding: const EdgeInsets.all(16.0),
  child: Column(
    crossAxisAlignment: isArabicText(widget.movie.description)
        ? CrossAxisAlignment.end
        : CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: isArabicText(widget.movie.category)
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          Text(
            widget.movie.category,
            style: const TextStyle(
              color: Colors.grey,
              height: 1.5,
            ),
            textDirection: isArabicText(widget.movie.category)
                ? TextDirection.rtl
                : TextDirection.ltr,
          ),
          const SizedBox(width: 16),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 6,
              vertical: 2,
            ),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.3),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              '${widget.movie.averageRating}/5',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 16),
      Text(
        widget.movie.description,
        style: const TextStyle(
          fontSize: 16,
          height: 1.8, // Better line height for readability
        ),
        textAlign: isArabicText(widget.movie.description)
            ? TextAlign.right
            : TextAlign.left,
        textDirection: isArabicText(widget.movie.description)
            ? TextDirection.rtl
            : TextDirection.ltr,
      ),
    ],
  ),
),
            // Comments section
            CommentsSection(movie: widget.movie),
          ],
        ),
      ),
    );
  }
}
