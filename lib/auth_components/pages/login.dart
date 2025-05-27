import 'dart:io';
import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tevly_client/auth_components/service/login_service.dart';
 import 'package:tevly_client/auth_components/widgets/auth_fields_builder.dart';
 import 'package:tevly_client/home_component/models/theme.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _loginService = LoginService();
  bool _isLoading = false;

  Future<void> _handleLogin(String email, String password) async {
    setState(() => _isLoading = true);

    final result = await _loginService.login(email, password);

    setState(() => _isLoading = false);

    if (result['success']) {
      _handleNavigation(result['role']);
     
      
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['error']))
      );
    }
  }

 void _handleNavigation(String role) {
  bool isMobilePlatform = !kIsWeb && (Platform.isAndroid || Platform.isIOS);
  
  switch (role) {
    case "USER":
      Navigator.pushReplacementNamed(context, '/home');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Welcome back to Tvely!"),
          duration: Duration(seconds: 3),
        ),
      );
      break;
      
    case "FILMMAKER":
    case "ADMIN":
      if (isMobilePlatform) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("${role.toLowerCase()} login is not available on mobile. Please use a non-mobile version."),
            duration: const Duration(seconds: 5),
          ),
        );
      } else {
        Navigator.pushReplacementNamed(
          context, 
          role == "FILMMAKER" ? '/upload' : '/admin'
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Welcome back to Tvely, ${role.toLowerCase()}!"),
            duration: const Duration(seconds: 3),
          ),
        );
      }
      break;
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.center,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.primaryColor,
              AppTheme.backgroundColor,
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                _buildLogo(),
                const SizedBox(height: 20),
                // Login Form
                LoginForm(
                  onSubmit: _handleLogin,
                  isLoading: _isLoading,
                ),
                  const SizedBox(height: 10),
                  _buildForgotPasswordLink(),

          
                // Sign Up Link
                _buildSignUpLink(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Image.asset(
          'lib/assets/logo.jpg',
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildSignUpLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account? ",
          style: AppTheme.bodyStyle,
        ),
        TextButton(
          onPressed: () => Navigator.pushNamed(context, '/signup'),
          child: Text(
            "Sign Up",
            style: AppTheme.linkStyle,
          ),
        ),
      ],
    );
  }
  Widget _buildForgotPasswordLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Forgot your password? ",
          style: AppTheme.bodyStyle,
        ),
        TextButton(
          onPressed: () => Navigator.pushNamed(context, '/forgot-password'),
          child: Text(
            "Forgot Password",
            style: AppTheme.linkStyle,
          ),
        ),
      ],
    );
  }
}