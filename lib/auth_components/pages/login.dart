// ignore_for_file: prefer_const_constructors

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tevly_client/auth_components/api/ApiConstants.dart';
import 'package:tevly_client/commons/logger/logger.dart';
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  String _token = "";

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse(ApiConstants.login);

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': _emailController.text,
        'password': _passwordController.text,
      }),
    );

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Login Successful")));
      Navigator.pushReplacementNamed(context, '/signup');   //todo: make navigation dynamic
      final responseData = jsonDecode(response.body);
      _token = responseData['token'].toString().trim();      
      Logger.debug('Status Code: ${response.statusCode}, Response: ${response.body}');
      Logger.debug('Token: $_token');

    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Login Failed")));
      
      Logger.debug('Status Code: ${response.statusCode}, Response: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: screenWidth,
        height: screenHeight,
        color: Colors.black, // Background color
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.08), // Responsive padding
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: screenHeight * 0.1),
                  
                  // Logo
                  SizedBox(
                    height: screenHeight * 0.15, // Adjust logo size dynamically
                    child:
                        Image.asset('lib/assets/logo.jpg', fit: BoxFit.contain),
                  ),
                  SizedBox(height: screenHeight * 0.05),

                  // Email Field
                  _buildTextField(
                      _emailController, "Email", Icons.email, false),
                  SizedBox(height: screenHeight * 0.02),

                  // Password Field
                  _buildTextField(
                      _passwordController, "Password", Icons.lock, true),
                  SizedBox(height: screenHeight * 0.01),

                  // Forgot Password
                  Align(
                    alignment: Alignment.centerRight/2,
                    child: TextButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, '/forgot-password'),
                      child: Text("Forgot Password?",
                          style: TextStyle(color: Colors.yellow)),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.03),

                  // Login Button
                  SizedBox(
                    width: kIsWeb
                        ? MediaQuery.of(context).size.width * 0.4
                        : MediaQuery.of(context).size.width * 0.6,
                    height: screenHeight * 0.06,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 205, 189, 43)),
                      onPressed: _isLoading ? null : _login,
                      child: _isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text("Log in", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.04),

                  // Signup Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account?",
                          style: TextStyle(color: Colors.white)),
                      TextButton(
                        onPressed: () =>
                            Navigator.pushNamed(context, '/signup'),
                        child: Text("Sign Up",
                            style: TextStyle(color: Colors.yellow)),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.05),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      IconData icon, bool isPassword) {
    return Container(
      width: kIsWeb
        ? MediaQuery.of(context).size.width * 0.4
        : MediaQuery.of(context).size.width * 0.6,

      child: TextField(
        controller: controller,
        obscureText: isPassword && !_isPasswordVisible,
        keyboardType:
            isPassword ? TextInputType.text : TextInputType.emailAddress,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.white),
          border: OutlineInputBorder(),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.yellow),
          ),
          prefixIcon: Icon(icon, color: Colors.white),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.white),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                )
              : null,
        ),
      ),
    );
  }
}
