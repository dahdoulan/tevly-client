import 'package:flutter/material.dart';
import '../services/rating_service.dart';

class RatingProvider with ChangeNotifier {
  final RatingService _ratingService = RatingService();
  bool isLoading = false;
  String? error;
  static bool hasRated = false;

  Future<void> submitRating(int videoId, int rating) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      hasRated = true;
      await _ratingService.submitRating(videoId, rating);
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}