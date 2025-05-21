import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/Rating_provider.dart';

class RatingWidget extends StatelessWidget {
  final int videoId;
  final double currentRating;

  const RatingWidget({
    Key? key,
    required this.videoId,
    this.currentRating = 0,
  }) : super(key: key);

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
                    index < currentRating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 30,
                  ),
                  onPressed: ratingProvider.isLoading
                      ? null
                      : () {
                          ratingProvider.submitRating(
                            videoId,
                            index + 1,
                          );
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
