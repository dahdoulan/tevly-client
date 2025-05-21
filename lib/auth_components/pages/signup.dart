import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:tevly_client/auth_components/api/api_constants.dart';
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
  bool _isLoading = false;

  Future<void> _signup() async {
  // Form validation
  bool isValid = true;
  String errorMessage = '';

  // Validate first name
  if (!RegExp(r'^[a-zA-Z]{1,12}$').hasMatch(_firstnameController.text)) {
    isValid = false;
    errorMessage = 'Invalid first name';
  }
  // Validate last name
  else if (!RegExp(r'^[a-zA-Z]{1,12}$').hasMatch(_lastnameController.text)) {
    isValid = false;
    errorMessage = 'Invalid last name';
  }
  // Validate email
  else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(_emailController.text)) {
    isValid = false;
    errorMessage = 'Invalid email address';
  }
  // Validate password
  else if (!RegExp(r'^(?=.*[A-Z])(?=.*[!@#$&*])(?=.*[0-9])(?=.*[a-z]).{8,}$')
      .hasMatch(_passwordController.text)) {
    isValid = false;
    errorMessage = 'Invalid password format';
  }
  // Validate phone number
  else if (!RegExp(r'^\+?[\d-]{10,}$').hasMatch(_phoneController.text)) {
    isValid = false;
    errorMessage = 'Invalid phone number';
  }
  // Check if passwords match
  else if (_passwordController.text != _confirmPasswordController.text) {
    isValid = false;
    errorMessage = 'Passwords do not match';
  }

  if (!isValid) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(errorMessage))
    );
    return;
  }
   if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Passwords do not match")));
      return;
    }

    setState(() {
      _isLoading = false;
    });

    final url = Uri.parse(ApiConstants.signup); 
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'firstname': _firstnameController.text.trim().toLowerCase(),
        'lastname': _lastnameController.text.trim().toLowerCase(),
        'email': _emailController.text.trim().toLowerCase(),
        'password': _passwordController.text.trim(),
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
              // Logo
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
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
                    'lib/assets/logo.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              
              _buildTextField(_firstnameController, "First Name", Icons.person_outline, false),
              const SizedBox(height: 20),
              
              _buildTextField(_lastnameController, "Last Name", Icons.person_outline, false),
              const SizedBox(height: 20),
              
              _buildTextField(_emailController, "Email", Icons.email_outlined, false),
              const SizedBox(height: 20),
              
              _buildTextField(_passwordController, "Password", Icons.lock_outline, true),
              const SizedBox(height: 20),

              _buildTextField(_confirmPasswordController, "Confirm Password", Icons.lock_outline, true),
              const SizedBox(height: 20),
              
              _buildTextField(_phoneController, "Phone Number", Icons.phone_outlined, false),
              const SizedBox(height: 20),

              _buildDatePicker(),
              const SizedBox(height: 30),
              
              _buildSignUpButton(),
              const SizedBox(height: 20),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account? ",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/login'),
                    child: Text(
                      "Login",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
               Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Sign up as fillmaker? ",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/signupFilmmaker'),
                    child: Text(
                      "Fillmaker Signup",
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
  // Regex patterns
  final nameRegex = RegExp(r'^[a-zA-Z]{1,12}$');
  final passwordRegex = RegExp(r'^(?=.*[A-Z])(?=.*[!@#$&*])(?=.*[0-9])(?=.*[a-z]).{8,}$');
  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  final phoneRegex = RegExp(r'^\+?[\d-]{10,}$');

  String? getErrorText(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }

    switch (hintText) {
      case "First Name":
      case "Last Name":
        if (!nameRegex.hasMatch(value)) {
          return 'Only letters allowed, max 12 characters';
        }
        break;
      case "Password":
      case "Confirm Password":
        if (!passwordRegex.hasMatch(value)) {
          return 'Min 8 chars, 1 uppercase, 1 symbol';
        }
        break;
      case "Email":
        if (!emailRegex.hasMatch(value)) {
          return 'Enter a valid email address';
        }
        break;
      case "Phone Number":
        if (!phoneRegex.hasMatch(value)) {
          return 'Enter a valid phone number';
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
        cursorColor: Colors.black, // Optional: Cursor color
        selectionHandleColor: Colors.black, // Optional: Handle color
      ),
    ),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword && !_isPasswordVisible,
        style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) => getErrorText(value),
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
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          errorStyle: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
    ),
  );
}
Widget _buildDatePicker() {
  return Container(
    width: kIsWeb
        ? MediaQuery.of(context).size.width * 0.4
        : MediaQuery.of(context).size.width * 0.8,
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: GestureDetector(
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: _selectedBirthdate ?? DateTime(2000),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: Theme.of(context).colorScheme.secondary,
                ),
              ),
              child: child!,
            );
          },
        );
        if (picked != null && picked != _selectedBirthdate) {
          setState(() {
            _selectedBirthdate = picked;
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            const SizedBox(width: 10),
            Text(
              _selectedBirthdate == null
                  ? 'Select Birthdate'
                  : '${_selectedBirthdate!.day}/${_selectedBirthdate!.month}/${_selectedBirthdate!.year}',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildSignUpButton() {
  return SizedBox(
    width: kIsWeb
        ? MediaQuery.of(context).size.width * 0.4
        : MediaQuery.of(context).size.width * 0.8,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ElevatedButton(
        onPressed: _isLoading ? null : _signup,
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
                'Sign Up',
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
