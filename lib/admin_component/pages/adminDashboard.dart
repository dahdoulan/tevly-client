import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tevly_client/auth_components/api/ApiConstants.dart';
import 'package:tevly_client/auth_components/service/authenticationService.dart';
import 'package:tevly_client/commons/logger/logger.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);

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

      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/admin/pending-movies'),
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
                columns: const [
                  DataColumn(label: Text('Title')),
                  DataColumn(label: Text('Uploaded By')),
                  DataColumn(label: Text('Date')),
                  DataColumn(label: Text('Actions')),
                ],
                rows: _pendingMovies.map((movie) {
                  return DataRow(cells: [
                    DataCell(
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(movie['title'] ?? ''),
                          Text(
                            movie['description'] ?? '',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    DataCell(Text(movie['uploadedBy'] ?? '')),
                    DataCell(Text(movie['date'] ?? '')),
                    DataCell(Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.visibility),
                          onPressed: () => _previewMovie(movie),
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
                    )),
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

      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}/admin/approve-movie/${movie['id']}'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Approved: ${movie['title']}')),
        );
        _fetchPendingMovies(); // Refresh the list
      } else {
        throw Exception('Failed to approve movie');
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

      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}/admin/reject-movie/${movie['id']}'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Rejected: ${movie['title']}')),
        );
        _fetchPendingMovies(); // Refresh the list
      } else {
        throw Exception('Failed to reject movie');
      }
    } catch (e) {
      Logger.debug('Error rejecting movie: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to reject movie')),
      );
    }
  }

  void _previewMovie(Map<String, dynamic> movie) {
    Navigator.pushNamed(
      context,
      '/video-player',
      arguments: {
        'resolutionUrls': {'HD': movie['movieUrl']},
        'title': movie['title'],
      },
    );
  }
}