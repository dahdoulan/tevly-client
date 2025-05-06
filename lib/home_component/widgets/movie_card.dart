import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/movie.dart';
import 'image_loader.dart';

class MovieCard extends StatefulWidget {
  final Movie movie;
  final Function()? onTap;

  const MovieCard({super.key, required this.movie, this.onTap});

  @override
  _MovieCardState createState() => _MovieCardState();
}

class _MovieCardState extends State<MovieCard> {
  static final Map<int, String> _imageCache = {}; // In-memory cache for images
  String? _base64Image;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadThumbnail();
  }

  Future<void> _loadThumbnail() async {
    // Check if the image is already cached
    if (_imageCache.containsKey(widget.movie.id)) {
      setState(() {
        _base64Image = _imageCache[widget.movie.id];
        _isLoading = false;
      });
      return;
    }

    // If not cached, fetch the image
    final base64Image = await ImageLoaderService.loadImage(widget.movie.id);
    if (base64Image != null) {
      _imageCache[widget.movie.id] = base64Image; // Cache the image
    }
    setState(() {
      _base64Image = base64Image;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: 120,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: _isLoading
                  ? _placeholderWidget()
                  : _base64Image != null
                      ? Image.memory(
                          base64Decode(_base64Image!.split(',').last),
                          height: 160,
                          width: 120,
                          fit: BoxFit.cover,
                        )
                      : _errorWidget(),
            ),
            const SizedBox(height: 4),
            Flexible(
              child: Text(
                widget.movie.title,
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