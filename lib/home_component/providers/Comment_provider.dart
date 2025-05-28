import 'package:flutter/material.dart';
import 'package:tevly_client/commons/logger/logger.dart';
import '../services/comment_service.dart';
import '../models/movie.dart';

class CommentProvider with ChangeNotifier {
  final CommentService _commentService = CommentService();
  bool isLoading = false;
  String? error;
  List<Comment> comments = [];
  Movie ?movie;
  String? userFullName; // <-- Add this field
  static  bool hasCommented = false;

  void loadComments(List<Comment> initialComments) {
    comments = List<Comment>.from(initialComments);
    notifyListeners();
  }  
  void setUserFullName(String fullName) {
    userFullName = fullName;
    notifyListeners();
  }

  Future<void> addComment(int videoId, String comment) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      await _commentService.submitComment(videoId, comment);
      // Add the new comment locally (optimistic update)
      hasCommented = true;
      comments.insert(
        0,
        Comment(
         
          comment: comment,
          fullName: movie?.comments.isNotEmpty == true
              ? movie!.comments.first.fullName
              : (userFullName ?? 'You'),  
          date: DateTime.now(),
        ),
      );      Logger.debug('Current userFullName: $userFullName');
      Logger.debug('Comment added: $comment by $userFullName');
    }
     catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}