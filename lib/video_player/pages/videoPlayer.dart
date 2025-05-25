import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tevly_client/video_player/providers/videoPlayer_provider.dart';
 import 'package:chewie/chewie.dart';

class VideoPlayerScreen extends StatelessWidget {
  final int movieId;

  const VideoPlayerScreen({
    Key? key,
    required this.movieId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => VideoProvider()..initialize(movieId),
      child: const VideoPlayerView(),
    );
  }
}

class VideoPlayerView extends StatelessWidget {
  const VideoPlayerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Consumer<VideoProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null) {
            return Center(child: Text(provider.error!));
          }

          return Stack(
            children: [
              Center(
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: provider.chewieController != null
                      ? Chewie(controller: provider.chewieController!)
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
          );
        },
      ),
    );
  }
}