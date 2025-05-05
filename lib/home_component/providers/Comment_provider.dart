import 'package:flutter/material.dart';
import '../services/comment_service.dart';

class CommentProvider with ChangeNotifier {
  final CommentService _commentService = CommentService();
  bool isLoading = false;
  String? error;

  Future<void> addComment(int videoId, String comment) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      await _commentService.submitComment(videoId, comment);
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
