import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tevly_client/admin_component/services/preview_movie.dart';
import 'package:tevly_client/admin_component/services/preview_thumbnail.dart';
import 'dart:convert';
import 'package:tevly_client/auth_components/api/api_constants.dart';
import 'package:tevly_client/auth_components/service/authenticationService.dart';
import 'package:tevly_client/commons/logger/logger.dart';
 
class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  
  int _selectedIndex = 0;
  bool _isLoading = true;
  List<Map<String, dynamic>> _pendingMovies = [];
 
  @override
  void initState() {
    super.initState();
    _fetchPendingMovies();
  }

  Future<void> _fetchPendingMovies() async {
    setState(() => _isLoading = true);
    try {
      final token = AuthenticationService().getToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }

      final response = await http.post(
        Uri.parse( ApiConstants.adminPendingMovies ),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _pendingMovies = List<Map<String, dynamic>>.from(data);
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load pending movies');
      }
    } catch (e) {
      Logger.debug('Error fetching pending movies: $e');
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load pending movies')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: Colors.blue,
      ),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.upload),
            label: 'Filmmaker',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_selectedIndex == 0) {
      return RefreshIndicator(
        onRefresh: _fetchPendingMovies,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Pending Movies',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
        DataTable(
  showCheckboxColumn: false,
  horizontalMargin: 16,
  columnSpacing: 24,
  border: TableBorder.all(
    color: Colors.grey.shade300,
    width: 1,
    borderRadius: BorderRadius.circular(8),
  ),
  headingRowColor: MaterialStateProperty.all(const Color.fromARGB(255, 0, 0, 0)),
  dataRowHeight: 60,
  columns: const [
    DataColumn(
      label: Text('Title', style: TextStyle(fontWeight: FontWeight.bold)),
    ),
    DataColumn(
      label: Text('Description', style: TextStyle(fontWeight: FontWeight.bold)),
    ),
    DataColumn(
      label: Text('Filmmaker', style: TextStyle(fontWeight: FontWeight.bold)),
    ),
    DataColumn(
      label: Text('Email', style: TextStyle(fontWeight: FontWeight.bold)),
    ),
    DataColumn(
      label: Text('Category', style: TextStyle(fontWeight: FontWeight.bold)),
    ),
    DataColumn(
      label: Text('Date', style: TextStyle(fontWeight: FontWeight.bold)),
    ),
    DataColumn(
      label: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold)),
    ),
  ],
  rows: _pendingMovies.map((movie) {
    return DataRow(cells: [
      DataCell(
        Container(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Text(
            movie['title'] ?? '',
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      DataCell(
        Container(
          constraints: const BoxConstraints(maxWidth: 2000),
          child: Text(
            movie['description'] ?? '',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      DataCell(Text(movie['filmmakerFullName'] ?? 'Unknown')),
      DataCell(Text(movie['filmmakerEmail'] ?? '')),
      DataCell(
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.category, size: 16, color: Colors.grey[600]),
            const SizedBox(width: 4),
            Text(movie['category'] ?? 'Uncategorized'),
          ],
        ),
      ),
      DataCell(Text(movie['created']?.toString().substring(0, 10) ?? '')),
      DataCell(
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.visibility),
              onPressed: () => PreviewThumbnail.previewThumbnail(context, movie),
            ),
            IconButton(
              icon: const Icon(Icons.play_arrow),
              onPressed: () => Previewmovie.previewMovie(context, movie),
            ),
            IconButton(
              icon: const Icon(Icons.check, color: Colors.green),
              onPressed: () => _handleApprove(movie),
            ),
            IconButton(
              icon: const Icon(Icons.close, color: Colors.red),
              onPressed: () => _handleReject(movie),
            ),
          ],
        ),
      ),
    ]);
  }).toList(),
),
              
            ],
          ),
        ),
      );
     } else if (_selectedIndex == 1) {
    return const Center(child: Text('Select Upload to navigate'));
  } else {
    return const Center(child: Text('Select Home to navigate'));
  }
  }

  void _onItemTapped(int index) {
  final token = AuthenticationService().getToken();
  if (token == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Authentication error. Please login again.')),
    );
    Navigator.pushReplacementNamed(context, '/login');
    return;
  }

  setState(() => _selectedIndex = index);

  if (index == 1) {
    Navigator.pushNamed(
      context,
      '/upload',
      arguments: {'token': token},
    );
  } else if (index == 2) {
    Navigator.pushNamed(
      context,
      '/home',
      arguments: {'token': token},
    );
  }
}

  Future<void> _handleApprove(Map<String, dynamic> movie) async {
  try {
    final token = AuthenticationService().getToken();
    if (token == null) throw Exception('No authentication token found');

    final videoId = int.parse(movie['id'].toString());
    Logger.debug('Approving movie with ID: $videoId');

    final url = Uri.parse('${ApiConstants.approveMovie}?videoId=$videoId');
    
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    Logger.debug('Approve response status: ${response.statusCode}');
    Logger.debug('Approve response body: ${response.body}');

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Approved: ${movie['title']}')),
      );
      await _fetchPendingMovies();
    } else {
      throw Exception('Failed to approve movie: ${response.statusCode}');
    }
  } catch (e) {
    Logger.debug('Error approving movie: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Failed to approve movie')),
    );
  }
}

Future<void> _handleReject(Map<String, dynamic> movie) async {
  try {
    final token = AuthenticationService().getToken();
    if (token == null) throw Exception('No authentication token found');

    final videoId = int.parse(movie['id'].toString());
    Logger.debug('Rejecting movie with ID: $videoId');


    final url = Uri.parse('${ApiConstants.rejectMovie}?videoId=$videoId');
    
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    Logger.debug('Reject response status: ${response.statusCode}');
    Logger.debug('Reject response body: ${response.body}');

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Rejected: ${movie['title']}')),
      );
      await _fetchPendingMovies();
    } else {
      throw Exception('Failed to reject movie: ${response.statusCode}');
    }
  } catch (e) {
    Logger.debug('Error rejecting movie: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Failed to reject movie')),
    );
  }
}

 

 
}