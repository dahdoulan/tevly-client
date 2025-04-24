 
import 'dart:async';
import 'dart:convert';
import 'dart:math' as Math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:tevly_client/auth_components/api/ApiConstants.dart';
import 'package:tevly_client/auth_components/service/authenticationService.dart';
import 'package:tevly_client/commons/logger/logger.dart';
import 'package:tevly_client/home_component/widgets/image_loader.dart';
import '../models/movie.dart';

class MovieCard extends StatefulWidget {
  final Movie movie;
  final Function()? onTap;

  const MovieCard({super.key, required this.movie, this.onTap});

  @override
  State<MovieCard> createState() => _MovieCardState();
}

class _MovieCardState extends State<MovieCard> {
  String? _imageUrl;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    if (!kIsWeb) {
      setState(() {
        _imageUrl = widget.movie.thumbnailUrl;
        _isLoading = false;
      });
      return;
    }

    try {
      final imageUrl = await ImageLoaderService.loadImage(widget.movie.id);
      setState(() {
        _imageUrl = imageUrl;
        _isLoading = false;
      });
    } catch (e) {
      Logger.debug('Error in MovieCard: $e');
      setState(() => _isLoading = false);
    }
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
                  ? Container(
                      height: 180,
                      width: 120,
                      color: Colors.grey[900],
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : _imageUrl != null
                      ? Image.network(
                          _imageUrl!,
                          height: 180,
                          width: 120,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            Logger.debug('Image load error: $error');
                            return Container(
                              height: 180,
                              width: 120,
                              color: Colors.grey[900],
                              child: const Icon(Icons.error, color: Colors.white),
                            );
                          },
                        )
                      : Container(
                          height: 180,
                          width: 120,
                          color: Colors.grey[900],
                          child: const Icon(Icons.error, color: Colors.white),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}