// lib/screens/movie_details_screen.dart
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
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
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
                Container(
                  height: 300,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Colors.black],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Text(
                      widget.movie.title,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
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
                            'HD': widget
                                .movie.videoUrl, // todo: add HD url to backend
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        widget.movie.category.substring(0, 4),
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(width: 16),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '${widget.movie.id}/10',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(widget.movie.description,
                      style: TextStyle(fontSize: 16)),
                ],
              ),
            ),

            // Comments section   TODO TEST
            CommentsSection(movie: widget.movie),
          ],
        ),
      ),
    );
  }
}
