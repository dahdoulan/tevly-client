// lib/services/movie_service.dart
import '../models/movie.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

// lib/services/movie_service.dart
import '../models/movie.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MovieService {
  // Simulating API call for popular movies
  Future<List<Movie>> fetchMovies() async {
    // In a real app, you would make an HTTP request here
    await Future.delayed(Duration(seconds: 1)); // Simulate network delay

    return [
      Movie(
        id: 1,
        title: "Stranger Things",
        category: "Action",
        videoUrl: "https://videos.pexels.com/video-files/31666597/13491606_1920_1080_30fps.mp4",
        description:
            "When a young boy disappears, his mother, a police chief, and his friends must confront terrifying forces in order to get him back.",
        thumbnailUrl:
            "https://images.pexels.com/photos/13424436/pexels-photo-13424436.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      ),
      Movie(
        id: 2,
        title: "Stranger Things",
        category: "Horror",
        videoUrl: "https://videos.pexels.com/video-files/31666597/13491606_1920_1080_30fps.mp4",
        description:
            "When a young boy disappears, his mother, a police chief, and his friends must confront terrifying forces in order to get him back.",
        thumbnailUrl:
            "https://images.pexels.com/photos/13400089/pexels-photo-13400089.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      ),
      // Add more movies...
    ];
  }
}

getTrendingMovies() {}

getPopularMovies() {}
