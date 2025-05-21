// lib/screens/movie_details_screen.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tevly_client/commons/logger/logger.dart';
import 'package:tevly_client/home_component/models/theme.dart';
import 'package:tevly_client/home_component/widgets/image_loader.dart';
import 'package:tevly_client/home_component/widgets/rating_widget.dart';
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
    final size = MediaQuery.of(context).size;

     return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              isInMyList ? Icons.bookmark : Icons.bookmark_outline,
              color: Colors.white,
            ),
            onPressed: () => movieProvider.toggleMyList(widget.movie),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                // Gradient overlay for better text readability
                ShaderMask(
                  shaderCallback: (rect) {
                    return LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.8),
                      ],
                      stops: const [0.5, 1.0],
                    ).createShader(rect);
                  },
                  blendMode: BlendMode.darken,
                  child: _isLoading

                      ? Container(
                          height: size.height * 0.4,
                          width: double.infinity,
                          color: Colors.black,
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                        )
                      : _imageUrl != null && _imageUrl!.startsWith('data:image')
                          ? Image.memory(
                              base64Decode(_imageUrl!.split(',').last),
                              height: size.height * 0.6,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            )
                          : Image.network(
                              _imageUrl ?? '',
                              height: size.height * 0.4,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                Logger.debug('Image load error: $error');
                                return Container(
                                  height: size.height * 0.4,
                                  width: double.infinity,
                                  color: Colors.black,
                                  child: const Icon(
                                    Icons.error,
                                    color: Colors.white,
                                    size: 48,
                                  ),
                                );
                              },
                            ),
                ),

                // Title and rating
                Positioned(
                  bottom: 20,
                  left: 16,
                  right: 16,
                  child: Column(
                    crossAxisAlignment: isArabicText(widget.movie.title)
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.movie.title,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          height: 1.5,
                          shadows: [
                            Shadow(
                              offset: Offset(0, 1),
                              blurRadius: 3.0,
                              color: Colors.black,
                            ),
                          ],
                        ),
                        textAlign: isArabicText(widget.movie.title)
                            ? TextAlign.right
                            : TextAlign.left,
                        textDirection: isArabicText(widget.movie.title)
                            ? TextDirection.rtl
                            : TextDirection.ltr,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: isArabicText(widget.movie.category)
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              widget.movie.category,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 20,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${widget.movie.averageRating}/5',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Action buttons with gradient background
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black,
                    Colors.grey[900]!,
                  ],
                ),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
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
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(160, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    icon: const Icon(Icons.play_arrow),
                    label: const Text(
                      'Play',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => movieProvider.toggleMyList(widget.movie),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[800],
                      foregroundColor: Colors.white,
                      minimumSize: const Size(160, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    icon: Icon(isInMyList ? Icons.check : Icons.add),
                    label: Text(
                      isInMyList ? 'Remove' : 'My List',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
 Center(
                    child: Column(
                      children: [
                        const Text(
                          'Rate this movie',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        RatingWidget(
                          videoId: widget.movie.id,
                          currentRating: widget.movie.userRating.toDouble(),
                        ),
                      ],
                    ),
                  ),
            // Description with styled container
           Container(
  width: double.infinity,
  margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
  padding: const EdgeInsets.all(16.0),
  decoration: BoxDecoration(
    color: Colors.grey[900],
    borderRadius: BorderRadius.circular(12.0),
    border: Border.all(
      color: Colors.grey[800]!,
      width: 1.0,
    ),
  ),
  child: Column(
    crossAxisAlignment: isArabicText(widget.movie.description)
        ? CrossAxisAlignment.end
        : CrossAxisAlignment.start,
    children: [
      const Text(
        'About this movie',
        style: AppTheme.subheaderStyle
      ),
      const SizedBox(height: 16.0),
      Text(
        widget.movie.description,
        style: AppTheme.bodyStyle,
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
const SizedBox(height: 24.0), // Spacing between sections

            // Comments section with styled container
           Container(
  width: double.infinity,
  margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
  padding: const EdgeInsets.all(16.0),
  decoration: BoxDecoration(
    color: Colors.grey[900],
    borderRadius: BorderRadius.circular(12.0),
    border: Border.all(
      color: Colors.grey[800]!,
      width: 1.0,
    ),
  ),
  child: CommentsSection(movie: widget.movie),
),
const SizedBox(height: 24.0), // Bottom padding
          ],
        ),
      ),
    );
  }
}
