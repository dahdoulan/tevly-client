import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/Rating_provider.dart';
import '../providers/movie_provider.dart';

class RatingWidget extends StatefulWidget {
  final int videoId;
  final double currentRating;
  final Function(double)? onRatingChanged;

  const RatingWidget({
    Key? key,
    required this.videoId,
    this.currentRating = 0,
    this.onRatingChanged,
  }) : super(key: key);

  @override
  State<RatingWidget> createState() => _RatingWidgetState();
}

class _RatingWidgetState extends State<RatingWidget> {
  late double _currentRating;

  @override
  void initState() {
    super.initState();
    _currentRating = widget.currentRating;
  }

  @override
  void didUpdateWidget(RatingWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentRating != widget.currentRating) {
      _currentRating = widget.currentRating;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RatingProvider>(
      builder: (context, ratingProvider, child) {
        return Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    index < _currentRating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 30,
                  ),
                  onPressed: ratingProvider.isLoading
                      ? null
                      : () async {
                          await ratingProvider.submitRating(
                            widget.videoId,
                            index + 1,
                          );

                          if (ratingProvider.error == null) {
                            setState(() {
                              _currentRating = index + 1.0;
                            });
                            widget.onRatingChanged?.call(_currentRating);
                          }
                        },
                );
              }),
            ),
            if (ratingProvider.isLoading)
              const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              ),
            if (ratingProvider.error != null)
              Text(
                ratingProvider.error!,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                ),
              ),
          ],
        );
      },
    );
  }
}
