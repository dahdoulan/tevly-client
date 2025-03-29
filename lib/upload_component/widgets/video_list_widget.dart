import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tevly_client/upload_component/constants/upload_constants.dart';
import 'package:tevly_client/upload_component/providers/video_provider.dart';
import '../models/uploaded_video.dart';

class VideoListWidget extends StatelessWidget {
  final Function(int) onRemove;
  final bool isSmallScreen;

  const VideoListWidget({
    Key? key,
    required this.onRemove,
    required this.isSmallScreen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<VideoUploadProvider>(
      builder: (context, provider, child) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Text(
              'Selected Videos (${provider.videos.length})',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: provider.videos.length,
              itemBuilder: (context, index) {
                final video = provider.videos[index];
                return VideoItemWidget(
                  video: video,
                  onRemove: () => onRemove(index),
                  isSmallScreen: isSmallScreen,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class VideoItemWidget extends StatelessWidget {
  final UploadedVideo video;
  final VoidCallback onRemove;
  final bool isSmallScreen;

  const VideoItemWidget({
    Key? key,
    required this.video,
    required this.onRemove,
    required this.isSmallScreen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.black12,
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Center(
            child: Icon(Icons.movie, color: kPrimaryColor),
          ),
        ),
        title: Text(
          video.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
              fontWeight: FontWeight.bold, color: kSecondaryColor),
        ),
        subtitle: Text(
          video.mime,
          style: const TextStyle(
              fontWeight: FontWeight.bold, color: kSecondaryColor),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: kPrimaryColor),
          onPressed: onRemove,
        ),
        isThreeLine: false,
      ),
    );
  }
}
