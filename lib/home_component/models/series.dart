import 'package:tevly_client/home_component/models/season.dart';

class Series {
  final int id;
  final String title;
  final String description;
  final String thumbnailUrl;
  final String category;
  final List<Season> seasons;
  final bool popularSeries;
  final bool trendingSeries;

  Series({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbnailUrl,
    required this.category,
    required this.seasons,
    this.popularSeries = false,
    this.trendingSeries = false,
  });

  factory Series.fromJson(Map<String, dynamic> json) {
    return Series(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      thumbnailUrl: json['thumbnailUrl'],
      category: json['category'],
      seasons: (json['seasons'] as List)
          .map((season) => Season.fromJson(season))
          .toList(),
      popularSeries: json['popularSeries'] ?? false,
      trendingSeries: json['trendingSeries'] ?? false,
    );
  }
}