import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tevly_client/home_component/models/movie.dart';
import 'package:tevly_client/home_component/services/search_service.dart';

class SearchProvider extends ChangeNotifier {
  final SearchService _searchService = SearchService();
  
  List<Movie> _allMovies = [];
  List<Movie> _filteredMovies = [];
  bool _isLoading = false;
  String _searchQuery = '';
  Timer? _debounce;

  List<Movie> get filteredMovies => _filteredMovies;
  bool get isLoading => _isLoading;

  Future<void> fetchMovies() async {
    _isLoading = true;
    notifyListeners();

    _allMovies = await _searchService.fetchAllMovies();
    _filterMovies(_searchQuery);

    _isLoading = false;
    notifyListeners();
  }

  void onSearchChanged(String query) {
    _searchQuery = query;
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _filterMovies(query);
    });
  }

  void _filterMovies(String query) {
    _filteredMovies = _allMovies.where((movie) {
      final titleLower = movie.title.toLowerCase();
      final searchLower = query.toLowerCase();
      return titleLower.contains(searchLower);
    }).toList();
    notifyListeners();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}