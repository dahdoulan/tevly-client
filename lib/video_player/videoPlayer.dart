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
  String _currentResolution = 'Full HD';
  

  @override
  void initState() {
    super.initState();
    _initializePlayer(widget.resolutionUrls[_currentResolution]!);
  } 

  Future<void> _initializePlayer(String url) async {
    _videoController = VideoPlayerController.networkUrl(Uri.parse(url));
    await _videoController.initialize();
    _chewieController = ChewieController(
      videoPlayerController: _videoController,
      autoPlay: false,
      looping: false,
      showControls: true,
      showOptions: true ,
      allowFullScreen: true,
      customControls: const MaterialControls(),
      additionalOptions: (context) => _buildResolutionOptions(),
    );
    if (mounted) setState(() {});
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
      _currentResolution = newRes;
      await _videoController.dispose();
      await _initializePlayer(widget.resolutionUrls[newRes]!);
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
    _videoController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }
}