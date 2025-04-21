import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:tevly_client/auth_components/api/ApiConstants.dart';
import 'package:tevly_client/commons/logger/logger.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  DateTime? _selectedBirthdate;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;

  Future<void> _signup() async {
  /*  if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Passwords do not match")));
      return;
    }*/

    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse(ApiConstants.signup); // Replace with actual backend URL
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'firstname': _firstnameController.text,
        'lastname': _lastnameController.text,
        'email': _emailController.text,
        'password': _passwordController.text,
        'dateOfBirth': _selectedBirthdate?.toIso8601String(),
       /* 'phone': _phoneController.text,*/
      }),
    );

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 202) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Signup Successful")));
      Navigator.pushReplacementNamed(context, '/verification');
                 Logger.debug('Status Code: ${response.statusCode}, Response: ${response.body}');

    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Signup Failed")));
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
        color: Colors.black, // Dark theme
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

                
                  // Firstname Field
                  _buildTextField(
                      _firstnameController, "Firstname", Icons.person, false),
                  SizedBox(height: screenHeight * 0.02),


                     // Lastname Field
                   _buildTextField(
                      _lastnameController, "Lastname", Icons.person, false),
                  SizedBox(height: screenHeight * 0.02),


                  // Email Field
                  _buildTextField(
                      _emailController, "Email", Icons.email, false),
                  SizedBox(height: screenHeight * 0.02),



                  // Password Field
                  _buildTextField(
                      _passwordController, "Password", Icons.lock, true,
                      isPasswordField: true),
                  SizedBox(height: screenHeight * 0.02),

                  // Confirm Password Field
                 /* _buildTextField(_confirmPasswordController,
                      "Confirm Password", Icons.lock, true,
                      isConfirmPassword: true),
                  SizedBox(height: screenHeight * 0.02),*/

                  // Birthdate Picker
                  _buildDatePicker(),
                  SizedBox(height: screenHeight * 0.02),

                  // Phone Number Field
                 /* _buildTextField(
                      _phoneController, "Phone Number", Icons.phone, false,
                      keyboardType: TextInputType.phone),
                  SizedBox(height: screenHeight * 0.03),*/

                  // Signup Button
                  Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: SizedBox(
                      width: double.infinity,
                      height: screenHeight * 0.06,
                       child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 205, 189, 43)),
                        onPressed: _isLoading ? null : _signup,
                        child: _isLoading
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text("Sign Up", style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.04),

                  // Login Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already have an account?",
                          style: TextStyle(color: Colors.white)),
                      TextButton(
                        onPressed: () => Navigator.pushNamed(context, '/login'),
                        child: Text("Login",
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

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon,
    bool isPassword, {
    bool isPasswordField = false,
    bool isConfirmPassword = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
     width: kIsWeb
    ? MediaQuery.of(context).size.width * 0.4
    : MediaQuery.of(context).size.width * 0.6,

      child: TextField(
        controller: controller,
        obscureText: (isPasswordField && !_isPasswordVisible) ||
            (isConfirmPassword && !_isConfirmPasswordVisible),
        keyboardType: keyboardType,
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
          suffixIcon: isPasswordField
              ? IconButton(
                  icon: Icon(
                    _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                )
              : isConfirmPassword
                  ? IconButton(
                      icon: Icon(
                        _isConfirmPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                        });
                      },
                    )
                  : null,
        ),
      ),
    );
  }
Widget _buildDatePicker() {
  return GestureDetector(
    onTap: () async {
      DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime(2000),
        firstDate: DateTime(1900),
        lastDate: DateTime.now(),
        builder: (context, child) {
          return Theme(
            data: ThemeData.dark().copyWith(
              colorScheme: const ColorScheme.dark(
                primary: Colors.yellow,
                surface: Colors.black,
                onSurface: Colors.white,
              ),
              dialogBackgroundColor: Colors.black,
            ),
            child: child!,
          );
        },
      );

      if (pickedDate != null) {
        setState(() {
          _selectedBirthdate = pickedDate;
        });
      }
    },
    child: Container(
     width: kIsWeb
    ? MediaQuery.of(context).size.width * 0.4
    : MediaQuery.of(context).size.width * 0.6,

      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: [
          Icon(Icons.calendar_today, color: Colors.white),
          SizedBox(width: 12),
          Text(
            _selectedBirthdate == null
                ? "Select Birthdate"
                : "${_selectedBirthdate!.day}/${_selectedBirthdate!.month}/${_selectedBirthdate!.year}",
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    ),
  );
}

}
