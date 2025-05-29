import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tevly_client/admin_component/providers/admin_provider.dart';
import 'package:tevly_client/admin_component/widgets/pending_movie_table.dart';
import 'package:tevly_client/admin_component/widgets/rejected_movie_table.dart';
import 'package:tevly_client/home_component/models/theme.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AdminDashboardProvider()..fetchPendingMovies(),
      child: const _AdminDashboardBody(),
    );
  }
}

class _AdminDashboardBody extends StatelessWidget {
  const _AdminDashboardBody();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AdminDashboardProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Admin Dashboard',
          style: TextStyle(
            color: AppTheme.textColor,
            fontWeight: FontWeight.bold
          ),
        ),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildBody(context, provider),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: provider.selectedIndex,
        onTap: (index) => provider.onItemTapped(context, index),
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
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Register Admin',
          ),
        ],
      ),
    );
  }

Widget _buildBody(BuildContext context, AdminDashboardProvider provider) {
    if (provider.selectedIndex == 0) {
      return RefreshIndicator(
        onRefresh: provider.fetchPendingMovies,
        child:const SingleChildScrollView(
          padding:  EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Pending Movies',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textColor
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 300, // Fixed height for PendingMoviesTable
                child: const PendingMoviesTable(),
              ),
              const SizedBox(height: 24),
              const Text(
                'Rejected Movies',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textColor
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 300, // Fixed height for RejectedMoviesTable
                child: const RejectedMoviesTable(),
              ),
            ],
          ),
        ),
      );
    } else if (provider.selectedIndex == 1) {
      return const Center(child: Text('Select Upload to navigate'));
    } else {
      return const Center(child: Text('Select Home to navigate'));
    }
  }
}