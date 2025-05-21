import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:provider/provider.dart';
import 'package:tevly_client/upload_component/providers/video_provider.dart';

class ThumbnailDropZoneWidget extends StatelessWidget {
  const ThumbnailDropZoneWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<VideoUploadProvider>(
      builder: (context, provider, child) {
        return Container(
          height: 150,
          width: 250,
          decoration: BoxDecoration(
            color: provider.isDragging ? Colors.grey[800] : Colors.grey[900],
            border: Border.all(
              color: provider.selectedThumbnail != null
                  ? Colors.green
                  : provider.isDragging
                  ? Colors.blue
                  : Colors.grey,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              DropzoneView(
                onCreated: provider.setThumbnailDropzoneController, // Use thumbnail-specific controller
                onDropFile: provider.handleThumbnailDrop, // Changed to use onDropFile instead of onDrop
                onHover: () => provider.isDragging = true,
                onLeave: () => provider.isDragging = false,
              ),
              if (provider.selectedThumbnail == null)
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.image,
                      color: provider.isDragging ? Colors.blue : Colors.grey,
                      size: 40,
                    ),
                    SizedBox(height: 8),
                    Text(
                      provider.isDragging
                          ? 'Drop to upload'
                          : 'Drop thumbnail here',
                      style: TextStyle(
                        color: provider.isDragging ? Colors.blue : Colors.grey,
                      ),
                    ),
                  ],
                )
              else
                const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 40,
                ),
            ],
          ),
        );
      },
    );
  }
}
