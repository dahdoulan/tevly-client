import 'package:flutter/material.dart';
import 'package:tevly_client/auth_components/api/api_constants.dart';
import 'package:tevly_client/auth_components/service/authenticationService.dart';
import 'package:tevly_client/commons/logger/logger.dart';
 
class PreviewThumbnail {

static void  previewThumbnail(BuildContext context, Map<String, dynamic> movie) {
  final String thumbnailUrl = '${ApiConstants.baseUrl}/videos/${movie['id']}/thumbnail';
  Logger.debug('Preview thumbnail with URL: $thumbnailUrl');

  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return Dialog(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(dialogContext).size.width * 0.8,
            maxHeight: MediaQuery.of(dialogContext).size.height * 0.8,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(dialogContext),
                ),
              ),
              Flexible(
                child: Image.network(
                  thumbnailUrl,
                  headers: {
                    'Authorization': 'Bearer ${AuthenticationService().getToken()}',
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    Logger.debug('Error loading thumbnail: $error');
                    return const Center(
                      child: Icon(
                        Icons.error_outline,
                        size: 48,
                        color: Colors.red,
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                    'Thumbnail Preview for the movie ${movie['title'] ?? ''}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}











}