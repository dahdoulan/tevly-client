import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
 import 'package:tevly_client/auth_components/api/api_constants.dart';
import 'package:tevly_client/auth_components/service/authenticationService.dart';
import 'package:tevly_client/commons/logger/logger.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tevly_client/home_component/models/theme.dart';
import 'package:tevly_client/home_component/models/user.dart';
import 'package:tevly_client/home_component/providers/comment_provider.dart';

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
      return Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        body: Center(child: AppTheme.loadingIndicator),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        elevation: 0,
        title: Text('Settings', style: AppTheme.headerStyle),
        backgroundColor: AppTheme.backgroundColor,
      ),
      body: SingleChildScrollView(
            padding: EdgeInsets.all(AppTheme.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
            padding: EdgeInsets.all(AppTheme.defaultPadding),
              decoration: AppTheme.containerDecoration,
              
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Profile Information', style: AppTheme.headerStyle,selectionColor:AppTheme.primaryColor,),
                  const SizedBox(height: AppTheme.defaultSpacing),
                  if (_userInfo != null) ...[
                    _buildInfoItem('FULL NAME', _userInfo!.fullName, Icons.person),
                    _buildDivider(),
                    _buildInfoItem('EMAIL', _userInfo!.email, Icons.email),
                    _buildDivider(),
                    _buildInfoItem('BIRTHDATE', _userInfo!.birthDate, Icons.cake),
                  ],
                ],
              ),
            ),
            const SizedBox(height: AppTheme.defaultSpacing),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildActionButton(
                    
                    'My List',
                    Icons.bookmark,
                    Colors.blue[700]!,
                    () {
                      // Navigate to My List
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildActionButton(
                    'Help & Support',
                    Icons.help_outline,
                    Colors.green[700]!,
                    () {
                      // Navigate to Help
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildActionButton(
                    'Privacy Policy',
                    Icons.privacy_tip_outlined,
                    Colors.orange[700]!,
                    () {
                      // Navigate to Privacy Policy
                    },
                  ),
                  const SizedBox(height: 24),
                  _buildLogoutButton(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical:AppTheme.defaultPadding),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.grey[400],
            size: 24,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 12,
                    letterSpacing: 1,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: Colors.grey[500],
      height: 1,
      thickness: 3,
    );
  }

  Widget _buildActionButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
      padding: const EdgeInsets.symmetric(vertical: AppTheme.defaultPadding),
          margin: const EdgeInsets.symmetric(vertical: 8.0),
      width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(icon, color: color, size: 30),
              const SizedBox(width: 17),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey[600],
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 56,
      
      margin: const EdgeInsets.only(bottom: 24),
      child: ElevatedButton.icon(
        onPressed: () => _handleLogout(context),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 15),
          backgroundColor: Colors.red[700],
          foregroundColor: AppTheme.textColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        icon: const Icon(Icons.logout, color: Colors.white),
        label: const Text(
          'Logout',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }
}