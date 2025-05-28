import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tevly_client/home_component/models/theme.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../models/movie.dart';
import '../providers/comment_provider.dart';

class CommentsSection extends StatefulWidget {
  final Movie movie;
  const CommentsSection({
    super.key,
    required this.movie,
  });

  @override
  State<CommentsSection> createState() => _CommentsSectionState();
}

class _CommentsSectionState extends State<CommentsSection> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load initial comments into provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CommentProvider>(context, listen: false)
          .loadComments(widget.movie.comments);
    });
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submitComment(BuildContext context) async {
    if (_commentController.text.isEmpty) return;

    final commentProvider = Provider.of<CommentProvider>(context, listen: false);

    try {
      await commentProvider.addComment(
        widget.movie.id,
        _commentController.text,
      );

      if (mounted) {
        _commentController.clear();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to post comment'),
            backgroundColor: Colors.red[700],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CommentProvider>(
      builder: (context, commentProvider, child) {
        return Container(
          padding: EdgeInsets.all(AppTheme.defaultPadding),
          decoration: AppTheme.containerDecoration,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Comments', style: AppTheme.subheaderStyle),
              const SizedBox(height: AppTheme.defaultSpacing),

              // Comment input field
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey[700]!,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey[900],
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 8.0,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _commentController,
                        style: AppTheme.bodyStyle,
                        decoration: InputDecoration(
                          hintText: 'Write a comment...',
                          hintStyle: AppTheme.captionStyle,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                        ),
                        maxLines: null,
                      ),
                    ),
                    IconButton(
                      onPressed: commentProvider.isLoading
                          ? null
                          : () => _submitComment(context),
                      icon: commentProvider.isLoading
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppTheme.primaryColor,
                                ),
                              ),
                            )
                          : Icon(
                              Icons.send,
                              color: AppTheme.primaryColor,
                            ),
                    ),
                  ],
                ),
              ),

              // Error message
              if (commentProvider.error != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    commentProvider.error!,
                    style: TextStyle(color: Colors.red[400]),
                  ),
                ),

              // Comments list
              const SizedBox(height: AppTheme.defaultSpacing),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemCount: commentProvider.comments.length,
                itemBuilder: (context, index) {
                  final comment = commentProvider.comments[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey[700]!,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey[900],
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                comment.fullName,
                                style: AppTheme.bodyStyle.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                timeago.format(comment.date),
                                style: AppTheme.captionStyle,
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            comment.comment,
                            style: AppTheme.bodyStyle,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}