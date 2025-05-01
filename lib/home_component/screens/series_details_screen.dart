import 'package:flutter/material.dart';
import 'package:tevly_client/home_component/models/series.dart';

class SeriesDetailsScreen extends StatefulWidget {
  final Series series;

  const SeriesDetailsScreen({Key? key, required this.series}) : super(key: key);

  @override
  State<SeriesDetailsScreen> createState() => _SeriesDetailsScreenState();
}

class _SeriesDetailsScreenState extends State<SeriesDetailsScreen> {
  int _selectedSeason = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Series thumbnail and info
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                widget.series.thumbnailUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Season selector
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: DropdownButton<int>(
                value: _selectedSeason,
                items: widget.series.seasons
                    .map((season) => DropdownMenuItem(
                          value: season.seasonNumber,
                          child: Text('Season ${season.seasonNumber}'),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() => _selectedSeason = value!);
                },
              ),
            ),
          ),
          // Episodes list
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final episode = widget.series.seasons
                    .firstWhere(
                        (season) => season.seasonNumber == _selectedSeason)
                    .episodes[index];
                return ListTile(
                  leading: Image.network(episode.thumbnailUrl),
                  title: Text(episode.title),
                  subtitle: Text(episode.description),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/video-player',
                      arguments: {
                        'resolutionUrls': {'HD': episode.videoUrl},
                      },
                    );
                  },
                );
              },
              childCount: widget.series.seasons
                  .firstWhere((season) => season.seasonNumber == _selectedSeason)
                  .episodes
                  .length,
            ),
          ),
        ],
      ),
    );
  }
}