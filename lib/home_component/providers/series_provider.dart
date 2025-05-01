import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:tevly_client/auth_components/api/ApiConstants.dart';
import 'package:tevly_client/auth_components/service/authenticationService.dart';
import 'package:tevly_client/commons/logger/logger.dart';
import 'package:tevly_client/home_component/models/series.dart';

class SeriesProvider with ChangeNotifier {
  final List<Series> _allSeries = [];
  final List<Series> _myList = [];
  bool _isLoading = false;
  List<String> get categories => [
    'Horror',
    'Action',
    'Adventure',
    'Comedy',
    'Crime and mystery',
    'Fantasy',
    'Historical',
    'Romance',
    'Science fiction',
    'Thriller',
    'Animation',
    'Drama',
    'Western',
    'documentary',
    'Other',
  ];

  List<Series> get allSeries => _allSeries;
  List<Series> get myList => _myList;
  bool get isLoading => _isLoading;

  Future<void> fetchSeries() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse(ApiConstants.fetchSeries),
        headers: {
          'Authorization': 'Bearer ${AuthenticationService().getToken()}',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> seriesJson = json.decode(response.body);
        _allSeries.clear();
        _allSeries.addAll(
          seriesJson.map((json) => Series.fromJson(json)).toList(),
        );
      }
    } catch (e) {
      Logger.debug('Error fetching series: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  // Add getSeriesByCategory method
  List<Series> getSeriesByCategory(String category) {
    return _allSeries.where((series) => series.category == category).toList();
  }

  // Add toggleMyList method
  void toggleMyList(Series series) {
    if (_myList.any((item) => item.id == series.id)) {
      removeFromMyList(series.id);
    } else {
      addToMyList(series);
    }
  }

  // Add helper methods for My List
  void addToMyList(Series series) {
    if (!_myList.any((item) => item.id == series.id)) {
      _myList.add(series);
      notifyListeners();
    }
  }

  void removeFromMyList(int seriesId) {
    _myList.removeWhere((series) => series.id == seriesId);
    notifyListeners();
  }

  bool isInMyList(int seriesId) {
    return _myList.any((series) => series.id == seriesId);
  }
}