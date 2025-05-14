import 'package:flutter/material.dart';
import 'package:tevly_client/auth_components/api/ApiConstants.dart';
import 'package:tevly_client/auth_components/service/authenticationService.dart';
import 'package:tevly_client/commons/logger/logger.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tevly_client/home_component/models/user.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isLoading = true;
  UserInfo? _userInfo;

  @override
  void initState() {
    super.initState();
    _fetchUserInfo();
  }

  Future<void> _fetchUserInfo() async {
    try {
      final token = AuthenticationService().getToken();
      if (token == null) {
        Navigator.of(context).pushReplacementNamed('/login');
        return;
      }

      final response = await http.get(
        Uri.parse(ApiConstants.viewPorfile),
        headers: {'Authorization': 'Bearer $token'},
      );
      Logger.debug('Response status: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _userInfo = UserInfo.fromJson(data);
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load user info');
      }
    } catch (e) {
      Logger.debug('Error fetching user info: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _handleLogout(BuildContext context) async {
    try {
       showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

       AuthenticationService().clearToken();

       Navigator.of(context).pop();

       Navigator.of(context).pushReplacementNamed('/login');
    } catch (e) {
      Logger.debug('Error during logout: $e');
       ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to logout. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.grey[850],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_userInfo != null) ...[
              _buildInfoItem('FullName', _userInfo!.fullName),
              _buildInfoItem('Email', _userInfo!.email),
              _buildInfoItem('Birthdate', _userInfo!.birthDate),
            ],
            const Spacer( ), 
           SizedBox(
                  width: double.infinity,
                  height: 50,  
                  child: ElevatedButton(
                    onPressed: () => _handleLogout(context),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical:1),  
                      backgroundColor: Colors.red,  
                    ),
                    child: const Text(
                      'Logout',
                      style: TextStyle(
                        fontSize: 21, 
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                     
                  ),

                ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 21,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}