import 'package:flutter/material.dart';
import 'package:tevly_client/admin_component/services/movie_actions.dart';
import 'package:tevly_client/commons/logger/logger.dart';

class AdminDashboardProvider extends ChangeNotifier {
  final AdminDashboardService _service = AdminDashboardService();
  
  bool isLoading = true;
  int selectedIndex = 0;
  List<Map<String, dynamic>> pendingMovies = [];
  List<Map<String, dynamic>> rejectedMovies = [];
 bool _tablesLoading = true;
  bool get tablesLoading => _tablesLoading;


//to fetch both Pending and Rejected at the same time
Future<void> fetchInitialData() async {
    _tablesLoading = true;
    notifyListeners();
    
    try {
      await Future.wait([
        fetchPendingMovies(),
        fetchRejectedMovies(),
      ]);
      _tablesLoading = false;
      notifyListeners();
    } catch (e) {
      _tablesLoading = false;
      notifyListeners();
      Logger.debug('Error fetching data: $e');
    }
  }





  Future<void> fetchPendingMovies() async {
    isLoading = true;
    notifyListeners();
    
    try {
      pendingMovies = await _service.fetchPendingMovies();
      Logger.debug('Fetched ${pendingMovies.length} pending movies');
    } catch (e) {
      Logger.debug('Error fetching pending movies: $e');
      pendingMovies = [];
    }
    
    isLoading = false;
    notifyListeners();
  } 


   Future<void> fetchRejectedMovies() async {
    isLoading = true;
    notifyListeners();
    
    try {
      rejectedMovies = await _service.fetchRejectedMovies();
            Logger.debug('Fetched ${rejectedMovies.length} rejected movies');

    } catch (e) {
      Logger.debug('Error fetching rejected movies: $e');
      rejectedMovies = [];
    }
    
    isLoading = false;
    notifyListeners();
  }

  Future<void> handleApprove(BuildContext context, Map<String, dynamic> movie) async {
  if (!context.mounted) return;
  
  isLoading = true;
  notifyListeners();

  try {
    final videoId = int.parse(movie['id'].toString());
    await _service.approveMovie(videoId);
    
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Approved: ${movie['title']}')),
      );
    }

    await Future.wait([
      fetchPendingMovies(),
      fetchRejectedMovies(),
    ]);
  } catch (e) {
    Logger.debug('Error approving movie: $e');
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to approve movie')),
      );
    }
  } finally {
    isLoading = false;
    notifyListeners();
  }
}

Future<void> handleReject(BuildContext context, Map<String, dynamic> movie) async {
  if (!context.mounted) return;

  isLoading = true;
  notifyListeners();

  try {
    final videoId = int.parse(movie['id'].toString());
    await _service.rejectMovie(videoId);
    
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Rejected: ${movie['title']}')),
      );
    }

    await Future.wait([
      fetchPendingMovies(),
      fetchRejectedMovies(),
    ]);
  } catch (e) {
    Logger.debug('Error rejecting movie: $e');
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to reject movie')),
      );
    }
  } finally {
    isLoading = false;
    notifyListeners();
  }
}

  void onItemTapped(BuildContext context, int index) {
    if (_service.token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Authentication error. Please login again.')),
      );
      Navigator.pushReplacementNamed(context, '/login');
      return;
    }

    selectedIndex = index;
    notifyListeners();

    switch (index) {
      case 1:
        Navigator.pushNamed(context, '/upload', arguments: {'token': _service.token});
        break;
      case 2:
        Navigator.pushNamed(context, '/home', arguments: {'token': _service.token});
        break;
      case 3:
        Navigator.pushNamed(context, '/adminSignup', arguments: {'token': _service.token});
        break;
      case 4:
        Navigator.pushNamed(context, '/settings', arguments: {'token': _service.token});
        break;
    }
  }
  void onItemTappedFilmmaker(BuildContext context, int index) {
    if (_service.token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Authentication error. Please login again.')),
      );
      Navigator.pushReplacementNamed(context, '/login');
      return;
    }

    selectedIndex = index;
    notifyListeners();
    switch (index) {
      case 1:
        Navigator.pushNamed(context, '/settings', arguments: {'token': _service.token});
        break;
      
    }
  }
}