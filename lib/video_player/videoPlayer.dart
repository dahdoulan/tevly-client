import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
 
class UniversalVideoPlayer extends StatefulWidget {
  final Map<String, String> resolutionUrls;

  const UniversalVideoPlayer({super.key, required this.resolutionUrls});

  @override
  State<UniversalVideoPlayer> createState() => _UniversalVideoPlayerState();
}

class _UniversalVideoPlayerState extends State<UniversalVideoPlayer> {
  late VideoPlayerController _videoController;
  ChewieController? _chewieController;
  String _currentResolution = '1080p';
  bool _isMuted = false;
  bool _showControls = true;

  @override
  void initState() {
    super.initState();
    _initializePlayer(widget.resolutionUrls[_currentResolution]!);
  }

  Future<void> _initializePlayer(String url) async {
    _videoController = VideoPlayerController.network(url);
    await _videoController.initialize();
    _chewieController = ChewieController(
      videoPlayerController: _videoController,
      autoPlay: false,
      looping: false,
      showControls: true,
      showOptions: true ,
      customControls: const MaterialControls(),
      fullScreenByDefault: Theme.of(context).platform == TargetPlatform.android,
      additionalOptions: (context) => _buildResolutionOptions(),
    );
    if (mounted) setState(() {});
  }

  List<OptionItem> _buildResolutionOptions() {
    return widget.resolutionUrls.keys.map((res) {
      return OptionItem(
        onTap: (context) => _changeResolution(context, res),
        iconData: Icons.hd,
        title: res,
      );
    }).toList();
  }

  void _changeResolution(BuildContext context, String newRes) async {
    if (newRes != _currentResolution) {
      _currentResolution = newRes;
      await _videoController.dispose();
      await _initializePlayer(widget.resolutionUrls[newRes]!);
    }
  }
 
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: _chewieController?.videoPlayerController.value.isInitialized == true
          ? Stack(
              children: [
                Chewie(controller: _chewieController!),
                 
              ],
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }

   

  @override
  void dispose() {
    _videoController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }
}