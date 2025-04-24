// ignore_for_file: prefer_const_constructors

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tevly_client/auth_components/api/ApiConstants.dart';
import 'package:tevly_client/auth_components/service/authenticationService.dart';
import 'package:tevly_client/commons/logger/logger.dart';
class LoginPage extends StatefulWidget {
  String get token => "";

  set tokenGetter(String tokenGetter) {}

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  String token = "";

    get tokenGetter => token;

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
    final responseData = jsonDecode(response.body);
    final token = responseData['token'].toString().trim();

    // Save the token using AuthenticationService
    AuthenticationService().setToken(token);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Login Successful")));
    Navigator.pushReplacementNamed(context, '/home');
    Logger.debug('Token: $token');
  } else {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Login Failed")));
    Logger.debug('Status Code: ${response.statusCode}, Response: ${response.body}');
  }
}

   @override
   Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.secondary,
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Replace Icon with Image
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    // Optional: add a subtle shadow
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.asset(
                      'lib/assets/logo.jpg', // Replace with your image path
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                const SizedBox(height: 20),
                _buildTextField(_emailController, "Email", Icons.email_outlined, false),
                const SizedBox(height: 20),
                _buildTextField(_passwordController, "Password", Icons.lock_outline, true),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: kIsWeb
                          ? MediaQuery.of(context).size.width * 0.3
                          : MediaQuery.of(context).size.width * 0.1,
                    ),
                    child: TextButton(
                      onPressed: () => Navigator.pushNamed(context, '/forgot-password'),
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _buildLoginButton(),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pushNamed(context, '/signup'),
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

 Widget _buildTextField(
    TextEditingController controller,
    String hintText,
    IconData icon,
    bool isPassword,
  ) {
    return Container(
      width: kIsWeb
          ? MediaQuery.of(context).size.width * 0.4
          : MediaQuery.of(context).size.width * 0.8,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword && !_isPasswordVisible,
        style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.5),
          ),
          prefixIcon: Icon(
            icon,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                )
              : null,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.onPrimary,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
Widget _buildLoginButton() {
    return SizedBox(
      width: kIsWeb
          ? MediaQuery.of(context).size.width * 0.4
          : MediaQuery.of(context).size.width * 0.8,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ElevatedButton(
          onPressed: _isLoading ? null : _login,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 15),
            backgroundColor: Theme.of(context).colorScheme.secondary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: _isLoading
              ? const CircularProgressIndicator()
              : Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                ),
        ),
      ),
    );
  }
}
