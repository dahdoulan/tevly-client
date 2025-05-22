import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tevly_client/auth_components/api/api_constants.dart';
import 'package:tevly_client/auth_components/service/authenticationService.dart';
import 'package:tevly_client/commons/logger/logger.dart';
import 'package:tevly_client/home_component/models/encoded_movie.dart';
import 'package:tevly_client/home_component/screens/movie_details_screen.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
 
class UniversalVideoPlayer extends StatefulWidget {
  final Map<String, String> resolutionUrls;

  const UniversalVideoPlayer({super.key, required this.resolutionUrls});
  
  get movie => null;

  @override
  State<UniversalVideoPlayer> createState() => _UniversalVideoPlayerState();
}

class _UniversalVideoPlayerState extends State<UniversalVideoPlayer> {
  late VideoPlayerController _videoController;
  ChewieController? _chewieController;
  String _currentResolution = 'Full HD';
  List <EncodedMovie> _movies = [];

  @override
void initState() {
  super.initState();
  _videoController = VideoPlayerController.networkUrl(Uri.parse('')); // Initialize with a dummy value
  _initializePlayer(widget.resolutionUrls[_currentResolution]!);
 //loadEncoded();

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
    return widget.resolutionUrls.keys.map((res) {
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
    await _initializePlayer(widget.resolutionUrls[newRes]!);

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








// Future<List <EncodedMovie>> loadEncoded() async {

//       final token = AuthenticationService().getToken();

//       if (token == null) {
//         throw Exception('User is not authenticated. Token is missing.');
//       }
//       Logger.debug('Token: $token');
//       final response = await http.post(
//         Uri.parse(ApiConstants.fetchvideoURL).replace(queryParameters: {
//           'id': widget.movie.id.toString(),
//         }),
//         headers: {'Authorization': 'Bearer $token'},
//     );
//       Logger.debug('Response: ${response.body}');
//       Logger.debug('Status Code: ${response.statusCode}');

//       if (response.statusCode == 200) {
//         final List<dynamic> moviesJson = json.decode(response.body);
//         return moviesJson.map((json) => EncodedMovie.fromJson(json)).toList();
//       } else {
//         throw Exception('Failed to load movies');
//       }
//     }