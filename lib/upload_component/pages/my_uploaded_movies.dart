import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tevly_client/admin_component/services/movie_actions.dart';
import 'package:tevly_client/auth_components/api/api_constants.dart';
import 'package:tevly_client/auth_components/service/authenticationService.dart';

class FilmmakerPendingMoviesPage extends StatefulWidget {
  const FilmmakerPendingMoviesPage({super.key});

  @override
  State<FilmmakerPendingMoviesPage> createState() => _FilmmakerPendingMoviesPageState();
}

class _FilmmakerPendingMoviesPageState extends State<FilmmakerPendingMoviesPage> {
  List<Map<String, dynamic>> _filteredMovies = [];
  bool _loading = true;
   String? filmmakerFullName;
  final String? token = AuthenticationService().getToken();
  final AdminDashboard = AdminDashboardService();

  @override
  void initState() {
    super.initState();
    loadMovies();
  }

  Future<void> loadMovies() async {
    try {
     
      filmmakerFullName = await fetchFilmmakerFullName();

      final allMovies = await AdminDashboard.fetchPendingMovies();
      final filtered = allMovies
          .where((movie) => movie['filmmakerFullName'] == filmmakerFullName)
          .toList();

      setState(() {
        _filteredMovies = filtered;
        _loading = false;
      });
    } catch (e) {
      print("Error loading movies: $e");
      setState(() => _loading = false);
    }
  }

  Future<String> fetchFilmmakerFullName() async {
    final response = await http.get(
       Uri.parse(ApiConstants.viewPorfile),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final profile = json.decode(response.body);
      return profile['fullName'];
    } else {
      throw Exception('Failed to fetch profile');
    }
  }
 
  @override
Widget build(BuildContext context) {
  if (_loading) {
    return const Center(child: CircularProgressIndicator());
  }

  return Scaffold(
    appBar: AppBar(title: const Text('My Pending Movies')),
    body: SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: DataTable(
            showCheckboxColumn: false,
            horizontalMargin: 16,
            columnSpacing: 24,
            border: TableBorder.all(
              color: Colors.grey.shade300,
              width: 1,
              borderRadius: BorderRadius.circular(8),
            ),
            headingRowColor: MaterialStateProperty.all(Colors.black),
            dataRowHeight: 60,
            columns: const [
              DataColumn(label: Text('Title', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
              DataColumn(label: Text('Description', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
              DataColumn(label: Text('Category', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
              DataColumn(label: Text('Date', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
            ],
            rows: _filteredMovies.map((movie) {
              return DataRow(cells: [
                DataCell(
                  Container(
                    constraints: const BoxConstraints(maxWidth: 200),
                    child: Text(movie['title'] ?? '', overflow: TextOverflow.ellipsis),
                  ),
                ),
                DataCell(
                  Container(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: Text(movie['description'] ?? '', overflow: TextOverflow.ellipsis, maxLines: 2),
                  ),
                ),
                DataCell(Text(movie['category'] ?? 'Uncategorized')),
                DataCell(Text(movie['date']?.toString().substring(0, 10) ?? '')),
              ]);
            }).toList(),
          ),
        ),
      ),
    ),
  );
}
}

