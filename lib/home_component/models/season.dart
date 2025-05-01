import 'package:tevly_client/home_component/models/episode.dart';

class Season {
  final int id;
  final int seasonNumber;
  final List<Episode> episodes;

  Season({
    required this.id,
    required this.seasonNumber,
    required this.episodes,
  });

  factory Season.fromJson(Map<String, dynamic> json) {
    return Season(
      id: json['id'],
      seasonNumber: json['seasonNumber'],
      episodes: (json['episodes'] as List)
          .map((episode) => Episode.fromJson(episode))
          .toList(),
    );
  }
}