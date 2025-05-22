import 'package:flutter/material.dart';
import 'package:tevly_client/home_component/services/Rating_service.dart';
class RatingProvider with ChangeNotifier {
  final RatingService _ratingService = RatingService();
  bool isLoading = false;
  String? error;

  Future<void> submitRating(int videoId, int rating) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      await _ratingService.submitRating(videoId, rating);
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
