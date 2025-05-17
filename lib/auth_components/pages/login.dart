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
  bool isValid = true;
  String errorMessage = '';
   if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(_emailController.text)) {
    isValid = false;
    errorMessage = 'Invalid email address';
  }
  // Validate password
  else if (!RegExp(r'^(?=.*[A-Z])(?=.*[!@#$&*])(?=.*[0-9])(?=.*[a-z]).{8,}$')
      .hasMatch(_passwordController.text)) {
    isValid = false;
    errorMessage = 'Invalid password format';
  }
  setState(() {
    _isLoading = true;
  }); 

  final url = Uri.parse(ApiConstants.login);

  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'email': _emailController.text.trim().toLowerCase(),
      'password': _passwordController.text.trim(),
    }),
  );

  setState(() {
    _isLoading = false;
  });

  if (response.statusCode == 200) {
    final responseData = jsonDecode(response.body);
    final token = responseData['token'].toString().trim();
    final role = responseData['role'].toString().trim();


    // Save the token using AuthenticationService
    AuthenticationService().setToken(token);
    AuthenticationService().setRole(role);


    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Login Successful")));
    if(role == "USER"){
      Navigator.pushReplacementNamed(context, '/home');
    }
    else if(role == "FILMMAKER"){
            Navigator.pushReplacementNamed(context, '/upload');
    }
     else if(role == "ADMIN"){
            Navigator.pushReplacementNamed(context, '/admin');
    }
     Logger.debug('Token: $token');
  } else {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage)));
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
                 Container(
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
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
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
  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  final passwordRegex = RegExp(r'^(?=.*[A-Z])(?=.*[!@#$&*])(?=.*[0-9])(?=.*[a-z]).{8,}$');
  String? getErrorText(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }

    switch (hintText) {
      case "Email":
        if (!emailRegex.hasMatch(value)) {
          return 'Enter a valid email address';
        }
        break;
      case "Password":
        if (!passwordRegex.hasMatch(value)) {
          return 'Min 8 chars, 1 uppercase, 1 symbol';
        }
        break;
      
      
    }
    return null;
  }
   return Container(
  width: kIsWeb
      ? MediaQuery.of(context).size.width * 0.4
      : MediaQuery.of(context).size.width * 0.8,
  padding: const EdgeInsets.symmetric(horizontal: 20),
  child: Theme(
    data: Theme.of(context).copyWith(
      textSelectionTheme: const TextSelectionThemeData(
        selectionColor: Colors.grey, // Highlight color
 
      ),
    ),
    child: TextFormField(
      controller: controller,
      obscureText: isPassword && !_isPasswordVisible,
      style: const TextStyle(color: Colors.black),
        validator: (value) => getErrorText(value),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.black),
        prefixIcon: Icon(icon, color: Colors.black),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.black,
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
                    color: Colors.black,
                  ),
                ),
        ),
      ),
    );
  }
}
