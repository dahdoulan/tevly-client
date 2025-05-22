import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tevly_client/commons/logger/logger.dart';
import 'package:tevly_client/home_component/services/movie_service.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
 
class UniversalVideoPlayer extends StatefulWidget {
  final int movieId;

  const UniversalVideoPlayer({
    super.key, 
    required this.movieId,
  });
 
  @override
  State<UniversalVideoPlayer> createState() => _UniversalVideoPlayerState();
}

class _UniversalVideoPlayerState extends State<UniversalVideoPlayer> {
 late VideoPlayerController _videoController;
  ChewieController? _chewieController;
  String _currentResolution = '1080p';
  Map<String, String> _resolutionUrls = {};
  final MovieService _movieService = MovieService();

   @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.networkUrl(Uri.parse('')); 
    _loadVideoUrls();
  }

 Future<void> _loadVideoUrls() async {
  try {
    final encodedMovie = await _movieService.loadEncoded(widget.movieId);
    setState(() {
      // Handle either single encoded movie or list
      if (encodedMovie is List) {
        for (var movie in encodedMovie) {
          if (movie.title.startsWith('720p')) {
            _resolutionUrls['720p'] = movie.url;
          } else if (movie.title.startsWith('1080p')) {
            _resolutionUrls['1080p'] = movie.url;
          }
        }
      } else {
        // Handle single encoded movie
        if (encodedMovie.title.startsWith('720p')) {
          _resolutionUrls['720p'] = encodedMovie.url;
        } else if (encodedMovie.title.startsWith('1080p')) {
          _resolutionUrls['1080p'] = encodedMovie.url;
        }
      }
    });

    // Initialize player with highest available resolution
    if (_resolutionUrls.containsKey('1080p')) {
      _currentResolution = '1080p';
      await _initializePlayer(_resolutionUrls['1080p']!);
    } else if (_resolutionUrls.containsKey('720p')) {
      _currentResolution = '720p';
      await _initializePlayer(_resolutionUrls['720p']!);
    }
  } catch (e) {
    Logger.debug('Error loading video URLs: $e');
  }
}
 Future<void> _initializePlayer(String url) async {
  Logger.debug('Initializing video player with URL: $url');
  try {
    // Dispose of the previous VideoPlayerController if it exists
    if (_videoController.value.isInitialized) {
      Logger.debug('Disposing previous video controller');
      await _videoController.dispose();
    }

    // Initialize the new VideoPlayerController
    _videoController = VideoPlayerController.networkUrl(Uri.parse(url));
    await _videoController.initialize();
    Logger.debug('Video player initialized successfully');

    // Dispose of the previous ChewieController if it exists
    if (_chewieController != null) {
      Logger.debug('Disposing previous Chewie controller');
    _chewieController!.dispose();
    }

    // Create a new ChewieController
    _chewieController = ChewieController(
      videoPlayerController: _videoController,
      autoPlay: false,
      looping: false,
      showControls: true,
      showOptions: true,
      allowFullScreen: true,
      customControls: const MaterialControls(),
      additionalOptions: (context) => _buildResolutionOptions(),
    );

    if (mounted) setState(() {});
  } catch (e) {
    Logger.debug('Error initializing video player: $e');
  }
}

  List<OptionItem> _buildResolutionOptions() {
  return _resolutionUrls.keys.map((res) {
    return OptionItem(
      onTap: (context) => _changeResolution(context, res),
      iconData: Icons.hd_rounded,
      title: res,
    );
  }).toList();
}
  void _changeResolution(BuildContext context, String newRes) async {
  if (newRes != _currentResolution) {
    final currentPosition = _videoController.value.position; // Save current position
    final wasPlaying = _videoController.value.isPlaying; // Save playback state

    Logger.debug('Changing resolution to $newRes');
    Logger.debug('Current position: $currentPosition');
    Logger.debug('Was playing: $wasPlaying');

    _currentResolution = newRes;
    await _initializePlayer(_resolutionUrls[newRes]!);

    // Use ChewieController to seek to the saved position
    if (_chewieController != null) {
      await _chewieController!.seekTo(currentPosition);
    }

    // Resume playback if it was playing
    if (wasPlaying) {
      _videoController.play();
    }

    Logger.debug('Resolution changed to $newRes');
  }
}
 
  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.black,
    body: Stack(
      children: [
        Center(
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: _chewieController?.videoPlayerController.value.isInitialized == true
                ? Chewie(controller: _chewieController!)
                : const Center(child: CircularProgressIndicator()),
          ),
        ),
     
        Positioned(
          top: 40,
          left: 16,
          child: SafeArea(
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 28,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ),
      ],
    ),
  );
}

   

  @override
void dispose() {
  Logger.debug('Disposing video and Chewie controllers');
  _chewieController?.dispose();
  if (_videoController.value.isInitialized) {
    _videoController.dispose();
  }
  super.dispose();
}
}




