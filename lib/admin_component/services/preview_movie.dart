import 'package:flutter/material.dart';
import 'package:tevly_client/commons/logger/logger.dart';
class Previewmovie {
   static void previewMovie(BuildContext context, Map<String, dynamic> movie) {
  final Map<String, String> resolutionUrls = {
    'Full HD': movie['videoUrl'] ?? '', 
    'HD': movie['videoUrl'] ?? '', 
  };

  Logger.debug('Preview movie with URL: ${movie['videoUrl']}');

  Navigator.pushNamed(
    context,
    '/video-player',
    arguments: {
      'resolutionUrls': resolutionUrls,
      'title': movie['title'] ?? '',
    },
  );
}






}