import 'package:tevly_client/auth_components/api/ApiConstants.dart';
import 'package:tevly_client/auth_components/service/authenticationService.dart';
import 'package:tevly_client/commons/logger/logger.dart';
import 'package:tevly_client/home_component/models/episode.dart';
import '../models/series.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SeriesService {
  Future<List<Series>> fetchSeries() async {
    final token = AuthenticationService().getToken();

    if (token == null) {
      throw Exception('User is not authenticated. Token is missing.');
    }

    Logger.debug('Token: $token');
    final response = await http.post(
      Uri.parse(ApiConstants.fetchSeries),
      headers: {'Authorization': 'Bearer $token'},
    );
    Logger.debug('Response: ${response.body}');
    Logger.debug('Status Code: ${response.statusCode}');

    if (response.statusCode == 200) {
      final List<dynamic> seriesJson = json.decode(response.body);
      return seriesJson.map((json) => Series.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load series');
    }
  }

  Future<List<Episode>> fetchEpisodes(int seriesId, int seasonId) async {
    final token = AuthenticationService().getToken();

    if (token == null) {
      throw Exception('User is not authenticated. Token is missing.');
    }

    final response = await http.get(
      Uri.parse('${ApiConstants.fetchEpisode}/$seriesId/seasons/$seasonId/episodes'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> episodesJson = json.decode(response.body);
      return episodesJson.map((json) => Episode.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load episodes');
    }
  }
}