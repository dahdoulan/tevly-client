import 'package:flutter/material.dart';
import 'package:tevly_client/video_player/services/videoPlayer_service.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
 
class VideoProvider extends ChangeNotifier {
  final VideoService _videoService = VideoService();
  // Initialize with an empty video controller
  VideoPlayerController? _videoController;
  ChewieController? chewieController;
  String currentResolution = '1080p';
  Map<String, String> resolutionUrls = {};
  bool isLoading = true;
  String? error;
  double _volume = 1.0;
  double get volume => _volume;
  VideoPlayerController get videoController => _videoController!;

  Future<void> initialize(int movieId) async {
    try {
      isLoading = true;
      notifyListeners();

      // Initialize with a dummy controller until we have the real URL
      _videoController = VideoPlayerController.asset('assets/placeholder.mp4');
      
      resolutionUrls = await _videoService.loadVideoUrls(movieId);
      await _initializeDefaultResolution();
      error = null;
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _initializeDefaultResolution() async {
    if (resolutionUrls.isEmpty) {
      throw Exception('No valid video URLs found');
    }

    final defaultUrl = resolutionUrls['1080p'] ?? resolutionUrls['720p'];
    if (defaultUrl != null) {
      currentResolution = resolutionUrls.containsKey('1080p') ? '1080p' : '720p';
      await _initializePlayer(defaultUrl);
    } else {
      throw Exception('No supported resolution found');
    }
  }

  Future<void> _initializePlayer(String url) async {
    try {
      // Dispose of the previous controllers
      await _cleanupControllers();

      // Create and initialize new controller
      _videoController = VideoPlayerController.networkUrl(Uri.parse(url));
      await _videoController!.initialize();
      await _videoController!.setVolume(_volume);

      // Create new Chewie controller
      chewieController = ChewieController(
        videoPlayerController: _videoController!,
        autoPlay: false,
        looping: false,
        showControls: true,
        showOptions: true,
        allowFullScreen: true,
        customControls: const MaterialControls(),  
        additionalOptions: (context) => _buildResolutionOptions(context),
      );
      notifyListeners();
    } catch (e) {
      error = 'Error initializing video player: ${e.toString()}';
      notifyListeners();
    }
  }

  Future<void> _cleanupControllers() async {
    if (chewieController != null) {
      chewieController!.dispose();
      chewieController = null;
    }
    if (_videoController != null) {
      await _videoController!.dispose();
      _videoController = null;
    }
  }

  Future<void> changeResolution(String newRes) async {
    if (newRes == currentResolution || _videoController == null) return;

    final currentPosition = _videoController!.value.position;
    final wasPlaying = _videoController!.value.isPlaying;

    currentResolution = newRes;
    await _initializePlayer(resolutionUrls[newRes]!);
    
    if (chewieController != null) {
      await chewieController!.seekTo(currentPosition);
      if (wasPlaying) {
        await _videoController!.play();
      }
    }
  }

  List<OptionItem> _buildResolutionOptions(BuildContext context) {
    return resolutionUrls.keys.map((res) {
      return OptionItem(
        onTap: (context) => changeResolution(res),
        iconData: Icons.hd,
        title: res,
      );
    }).toList();
  }

  @override
  void dispose() {
    _cleanupControllers();
    super.dispose();
  }
}