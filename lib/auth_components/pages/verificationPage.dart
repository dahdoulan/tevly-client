import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tevly_client/auth_components/api/ApiConstants.dart';

class VerificationPage extends StatefulWidget {
  @override
  _VerificationPageState createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final TextEditingController _verificationController = TextEditingController();
  bool _isLoading = false;

  Future<void> _activateAccount() async {
    final token = _verificationController.text.trim();

    if (token.isEmpty) {
      _showSnackBar("Please enter your activation code.");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final uri = Uri.parse(ApiConstants.verifyEmail).replace(
        queryParameters: {'token': token},
      );

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        _showSnackBar("Account Activated Successfully!");
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        _showSnackBar("Activation Failed: ${response.body}");
      }
    } catch (e) {
      _showSnackBar("Error: ${e.toString()}");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: screenSize.width,
        height: screenSize.height,
        color: Colors.black,
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.08),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: screenSize.height * 0.1),
                  SizedBox(
                    height: screenSize.height * 0.15,
                    child: Image.asset('lib/assets/logo.jpg', fit: BoxFit.contain),
                  ),
                  SizedBox(height: screenSize.height * 0.05),
                  _buildVerificationField(),
                  SizedBox(height: screenSize.height * 0.02),
                  _buildActivateButton(screenSize),
                  SizedBox(height: screenSize.height * 0.04),
                  _buildLoginLink(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVerificationField() {
    final width = kIsWeb
        ? MediaQuery.of(context).size.width * 0.4
        : MediaQuery.of(context).size.width * 0.6;

    return Container(
      width: width,
      child: TextField(
        controller: _verificationController,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: "Activation Code",
          labelStyle: TextStyle(color: Colors.white),
          border: OutlineInputBorder(),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.yellow),
          ),
          prefixIcon: Icon(Icons.verified, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildActivateButton(Size screenSize) {
    final width = kIsWeb
        ? MediaQuery.of(context).size.width * 0.4
        : MediaQuery.of(context).size.width * 0.6;

    return SizedBox(
      width: width,
      height: screenSize.height * 0.06,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color.fromARGB(255, 205, 189, 43),
        ),
        onPressed: _isLoading ? null : _activateAccount,
        child: _isLoading
            ? CircularProgressIndicator(color: Colors.white)
            : Text("Activate Account", style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildLoginLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Go Back?", style: TextStyle(color: Colors.white)),
        TextButton(
          onPressed: () => Navigator.pushNamed(context, '/login'),
          child: Text("Log in", style: TextStyle(color: Colors.yellow)),
        ),
      ],
    );
  }
}